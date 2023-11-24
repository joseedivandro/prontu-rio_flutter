import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prontuario_flutter/helper/funcionario_helper.dart';
import 'package:prontuario_flutter/main.dart';
import 'package:prontuario_flutter/model/funcionario.dart';
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
                decoration: InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your CPF';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dataNascimentoController,
                decoration: InputDecoration(labelText: 'Birth Date'),
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
                    return 'Please select your birth date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your endereco';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cargoController,
                decoration: InputDecoration(labelText: 'Position'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your cargo';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final funcionario = Funcionario(
                      cpf: _cpfController.text,
                      nome: _nomeController.text,
                      dataNascimento: _selectedDate ?? DateTime.now(),
                      endereco: _enderecoController.text,
                      email: _emailController.text,
                      cargo: _cargoController.text,
                      id: _idController.text,
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
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
