import 'package:intl/intl.dart';

class Funcionario {
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