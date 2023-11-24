import 'package:flutter/material.dart';
import 'package:prontuario_flutter/UI/cadastro.dart';
import 'package:prontuario_flutter/UI/detail.dart';
import 'package:prontuario_flutter/helper/funcionario_helper.dart';
import 'package:prontuario_flutter/model/funcionario.dart';
import 'package:prontuario_flutter/repositories/patient_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prontuário Eletrônico',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FuncionarioListScreen(),
    );
  }
}

class FuncionarioListScreen extends StatelessWidget {
  final helper = FuncionarioHelper();
  late final FuncionarioProvider provider;

  FuncionarioListScreen(){
    provider = FuncionarioProvider(helper: helper);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchFuncionarios(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<dynamic>? funcionarios = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text('Lista de Funcionarios'),
            ),
            body: ListView.builder(
              itemCount: funcionarios?.length,
              itemBuilder: (context, index) {
                Funcionario funcionario = funcionarios![index];
                return ListTile(
                  title: Text(funcionario.nome),
                  subtitle: Text('Data de Nascimento: ${funcionario.dataNascimento}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FuncionarioDetailScreen(funcionario: funcionario),
                      ),
                    );
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Funcionario? novoFuncionario = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FuncionarioForm(),
                  ),
                );

                if (novoFuncionario != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Funcionario ${novoFuncionario.nome} criado/editado com sucesso!'),
                    ),
                  );
                }

                fetchFuncionarios().then((funcionarios) {
                  ScaffoldMessenger.of(context).setState(() {});
                });
              },
              child: Icon(Icons.add),
            ),
          );
        }
      },
    );
  }

  Future<List<dynamic>> fetchFuncionarios() async {
    List dados = await provider.findAll();
    return dados;
  }
}

