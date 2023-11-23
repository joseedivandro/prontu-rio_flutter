import 'package:flutter/material.dart';
import 'package:prontuario_flutter/cadastro.dart';
import 'package:prontuario_flutter/funcionario.dart';
import 'package:prontuario_flutter/services/patient_provider.dart';

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
  final provider = FuncionarioProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Funcionario>>(
      future: fetchFuncionarios(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Funcionario>? funcionarios = snapshot.data;

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

  Future<List<Funcionario>> fetchFuncionarios() async {
    List<Funcionario> dados = await provider.findAll();
    print(dados);
    return dados;
  }
}


class FuncionarioDetailScreen extends StatelessWidget {
  final Funcionario funcionario;
  final FuncionarioProvider provider = FuncionarioProvider();

  FuncionarioDetailScreen({required this.funcionario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Funcionario'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FuncionarioForm(funcionario: funcionario),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool confirmar = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirmar exclusão'),
                  content: Text('Deseja realmente excluir o funcionário ${funcionario.nome}?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Confirmar'),
                    ),
                  ],
                ),
              );

              if (confirmar == true) {
                // Remova o funcionário da lista
                await provider.delete(funcionario.id);

                // Exibe a mensagem
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Funcionario ${funcionario.nome} deletado com sucesso!'),
                  ),
                );

                // Volta para a lista de funcionários
                Navigator.pop(context);

                // Atualiza a lista após a exclusão
                ScaffoldMessenger.of(context).setState(() {});
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nome: ${funcionario.nome}'),
            Text('Idade: ${funcionario.dataNascimento}'),
            Text('Endereço: ${funcionario.endereco}'),
            Text('E-mail: ${funcionario.email}'),
          ],
        ),
      ),
    );
  }
}
