import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prontuario_flutter/helper/funcionario_helper.dart';
import 'package:prontuario_flutter/model/funcionario.dart';
import 'package:prontuario_flutter/main.dart';
import 'package:prontuario_flutter/repositories/patient_provider.dart';


class FuncionarioForm extends StatefulWidget {
  final Funcionario? funcionario;

  FuncionarioForm({this.funcionario});

  @override
  _FuncionarioFormState createState() => _FuncionarioFormState();
}

class _FuncionarioFormState extends State<FuncionarioForm> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _nomeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _emailController = TextEditingController();
  final _cargoController = TextEditingController();
  final _idController = TextEditingController();
  DateTime? _selectedDate;
  final FuncionarioHelper helper = FuncionarioHelper();
  late final FuncionarioProvider provider;

  _FuncionarioFormState(){
    provider = FuncionarioProvider(helper: helper);
  }



  @override
  Widget build(BuildContext context) {
    String pageTitle = widget.funcionario != null ? 'Editar Funcionario' : 'Adicionar Funcionario';

    // Preencher os controladores se estiver editando
    if (widget.funcionario != null) {
      _cpfController.text = widget.funcionario!.cpf;
      _nomeController.text = widget.funcionario!.nome;
      _enderecoController.text = widget.funcionario!.endereco;
      _emailController.text = widget.funcionario!.email;
      _cargoController.text = widget.funcionario!.cargo;
      _idController.text = widget.funcionario!.id;
      _selectedDate = widget.funcionario!.dataNascimento;
      _dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu CPF';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dataNascimentoController,
                decoration: const InputDecoration(labelText: 'Data de nascimento'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua data de nascimento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(labelText: 'Endereço'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu endereco';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cargoController,
                decoration: const InputDecoration(labelText: 'Cargo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu cargo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final funcionario = Funcionario(
                      _cpfController.text,
                       _nomeController.text,
                      _selectedDate ?? DateTime.now(),
                      _enderecoController.text,
                     _emailController.text,
                      _cargoController.text,
                    _idController.text,
                    );
                    

                    try {
                      if (widget.funcionario != null) {
                        await provider.put(widget.funcionario!.id, funcionario);
                      } else {
                        await provider.create(funcionario);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Funcionário ${widget.funcionario != null ? 'editado' : 'criado'} com sucesso!'),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FuncionarioListScreen(),
                        ),
                      );
                    } catch (e) {
                      print('Error ${widget.funcionario != null ? 'editing' : 'creating'} funcionario: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao ${widget.funcionario != null ? 'editar' : 'criar'} funcionário. Tente novamente.'),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(top: 10.0), // Ajuste o valor conforme necessário
                ),

                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
