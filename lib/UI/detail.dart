
import 'package:flutter/material.dart';
import 'package:prontuario_flutter/UI/cadastro.dart';
import 'package:prontuario_flutter/helper/funcionario_helper.dart';
import 'package:prontuario_flutter/main.dart';
import 'package:prontuario_flutter/model/funcionario.dart';
import 'package:prontuario_flutter/repositories/patient_provider.dart';

class FuncionarioDetailScreen extends StatelessWidget {
  final Funcionario funcionario;
  final FuncionarioHelper helper = FuncionarioHelper();
  late final  FuncionarioProvider provider;

  FuncionarioDetailScreen({required this.funcionario}){
    provider = FuncionarioProvider(helper: helper);
  }

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
           
                await provider.delete(funcionario.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Funcionario ${funcionario.nome} deletado com sucesso!'),
                  ),
                );
                Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FuncionarioListScreen(),
                        ),
                      );                
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
