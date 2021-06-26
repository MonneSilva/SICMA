import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DBController {
  static final DBController _singleton = DBController._();
  static DBController get instance => _singleton;
  String name;
  Database _database;
  String user;
  String pass;
  int version;

  DBController._();

  DBController({
    @required this.name,
    @required this.user,
    @required this.pass,
    @required this.version,
  });

  Future<Database> get database async {
    //open db if db is null
    if (_database == null) {
      _database = await _openDatabase();
    }
    //return already opened db
    return _database;
  }

  Future<Database> _openDatabase() async {
    //construct path
    var appDirectory = await getApplicationDocumentsDirectory();
    var dbPath = appDirectory.path + "/" + "sicma.db";

    //open database
    final db = await databaseFactoryIo.openDatabase(dbPath);
    return db;
  }
}
