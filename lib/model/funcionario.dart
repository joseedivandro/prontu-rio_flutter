// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

class Funcionario {
  static const String table_funcionario = "funcionario_tb";
  static const String coluna_nome = "nome";
  static const String coluna_cpf = "cpf";
  static const String coluna_dataNascimento = "data_nascimento";
  static const String coluna_endereco = "endereco";
  static const String coluna_email = "email";
  static const String coluna_cargo = "cargo";
  static const String coluna_id = "id";

  String cpf = '';
  String nome = '';
  DateTime dataNascimento = DateTime.now();
  String endereco = '';
  String cargo = '';
  String id = '';
  String email = '';

  Funcionario(
     this.cpf,
     this.nome,
     this.dataNascimento,
     this.endereco,
     this.email,
     this.cargo,
     this.id
  );

  factory Funcionario.fromJson(Map<String, dynamic> json) => Funcionario(
    json['cpf'],
    json['nome'],
    DateTime.parse(json['dataNascimento']),
    json['endereco'],
    json['email'],
    json['cargo'],
    json['id']
  );

 Map<String, dynamic> toJSON() {
    return {
      'cpf': cpf,
      'nome': nome,
      'dataNascimento': dataNascimento.toIso8601String(), // Função para formatar a data como String
      'endereco': endereco,
      'email': email,
      'cargo': cargo,
      'id': id,
    };
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date); // ou o formato que seu backend espera
  }
}