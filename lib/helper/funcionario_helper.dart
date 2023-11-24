import 'package:path/path.dart';
import 'package:prontuario_flutter/model/funcionario.dart';
import 'package:sqflite/sqflite.dart';

class FuncionarioHelper {
  static final FuncionarioHelper _instance = FuncionarioHelper.internal();

  FuncionarioHelper.internal();

  factory FuncionarioHelper() => _instance;

  Database? _db;

  Future<Database?> get db async {
    _db ??= await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    String? databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "funcionarios.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE ${Funcionario.table_funcionario}(${Funcionario.coluna_id} TEXT PRIMARY KEY, "
          "                                 ${Funcionario.coluna_nome} TEXT, "
          "                                 ${Funcionario.coluna_cpf} TEXT, "
          "                                 ${Funcionario.coluna_dataNascimento} TEXT, "
          "                                 ${Funcionario.coluna_endereco} TEXT, "
          "                                 ${Funcionario.coluna_email} TEXT, "
          "                                 ${Funcionario.coluna_cargo} TEXT) ");
    });
  }

  Future<Funcionario> saveFuncionario(Funcionario f) async {
    Database? dbFuncionario = await db;
    if (dbFuncionario != null) {
      await dbFuncionario.insert(Funcionario.table_funcionario, f.toJSON());
    }
    return f;
  }

  Future<Funcionario?> getFuncionario(String id) async {
    Database? dbFuncionario = await db;
    if (dbFuncionario != null) {
      List<Map<String, dynamic>> maps = await dbFuncionario.query(Funcionario.table_funcionario,
          columns: [
            Funcionario.coluna_id,
            Funcionario.coluna_nome,
            Funcionario.coluna_cpf,
            Funcionario.coluna_dataNascimento,
            Funcionario.coluna_endereco,
            Funcionario.coluna_email,
            Funcionario.coluna_cargo,
          ],
          where: "${Funcionario.coluna_id} = ?",
          whereArgs: [id]);
      if (maps.isNotEmpty) return Funcionario.fromJson(maps.first);
    }
    return null;
  }

  Future<int> deleteFuncionario(String id) async {
    Database? dbFuncionario = await db;
    if (dbFuncionario != null) {
      return await dbFuncionario.delete(Funcionario.table_funcionario,
          where: "${Funcionario.coluna_id} = ?", whereArgs: [id]);
    } else {
      return 0;
    }
  }

  Future<int> updateFuncionario(Funcionario f) async {
    Database? dbFuncionario = await db;
    if (dbFuncionario != null) {
      return await dbFuncionario.update(Funcionario.table_funcionario, f.toJSON(),
          where: "${Funcionario.coluna_id} = ?", whereArgs: [f.id]);
    } else {
      return 0;
    }
  }

  Future<List> getAll() async {
    Database? dbFuncionario = await db;
    if (dbFuncionario != null) {
      List listMap = await dbFuncionario.query(Funcionario.table_funcionario);
      List<Funcionario> listFuncionarios = [];

      for (Map<String, dynamic> m in listMap) {
        listFuncionarios.add(Funcionario.fromJson(m));
      }
      return listFuncionarios;
    } else {
      return [];
    }
  }
}