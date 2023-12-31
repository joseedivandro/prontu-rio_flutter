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

  String cpf;
  String nome;
  DateTime dataNascimento;
  String endereco;
  String email;
  String cargo;
  String id;

  Funcionario({
    required this.cpf,
    required this.nome,
    required this.dataNascimento,
    required this.endereco,
    required this.email,
    required this.cargo,
    required this.id
  });

  factory Funcionario.fromJson(Map<String, dynamic> json) => Funcionario(
    cpf: json['cpf'],
    nome: json['nome'],
    dataNascimento: DateTime.parse(json['dataNascimento']),
    endereco: json['endereco'],
    email: json['email'],
    cargo: json['cargo'],
    id: json['id']
  );

 Map<String, dynamic> toJSON() {
    return {
      'cpf': cpf,
      'nome': nome,
      'dataNascimento': dataNascimento.toIso8601String(),
      'endereco': endereco,
      'email': email,
      'cargo': cargo,
      'id': id,
    };
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}