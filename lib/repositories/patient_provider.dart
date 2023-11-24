import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:prontuario_flutter/helper/funcionario_helper.dart';
import 'package:prontuario_flutter/model/funcionario.dart';
import 'package:prontuario_flutter/repositories/provider_exceptions.dart';
class FuncionarioProvider  {
  
  final Uri uri = Uri.parse('https://prontuario-api-github.onrender.com/funcionarios');
  final FuncionarioHelper helper;

  FuncionarioProvider({required this.helper});

  Future<List<dynamic>> findAll() async {

    try{
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['content'] as List)
          .map((funcionario) => Funcionario.fromJson(funcionario)).toList();
      }
    } on SocketException catch (_) {
        return helper.getAll();
      } 
      
    throw Exception("kkkkkkkkkkkkkkkkkkkkk");
  } 
  
   Future<List> create(Funcionario funcionario ) async {
    Map<String, String> headers = {
      'Content-Type' : 'application/json',
    };
    final body = json.encode(funcionario.toJSON());
    final response = await http.post(uri, headers: headers , body: body);
    if (response.statusCode == 201) {
      Map<String, dynamic> data = json.decode(response.body);
      return (data.values.toList());
    } else {
      throw Exception();
    }
  }

  Future<void> delete(String id) async {
    final deleteUri = Uri.parse('$uri/$id');
    try{
      final response = await http.delete(deleteUri);
      if(response.statusCode == 204){
        return; 
      } 
    } on SocketException catch (_) {
      throw NoInternetConnectionException("Sem internet");
      }
    }


  Future<void> put(String id, Funcionario funcionario) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode(funcionario.toJSON());
    final putUri = Uri.parse('$uri/$id');
    final response = await http.put(putUri, headers: headers, body: body);
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }
}

