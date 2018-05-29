import 'dart:async';
import 'dart:io' as io;

import 'package:chat/src/models/auth.dart';
import 'package:path/path.dart';
import 'package:chat/src/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Auth(id INTEGER PRIMARY KEY, name TEXT, email TEXT, avatar TEXT, uid TEXT, accessToken TEXT, clientId TEXT);");

    print("Created tables");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<int> saveAuth(Auth auth) async {
    var dbClient = await db;
    int res = await dbClient.insert("Auth", auth.toMap());
    return res;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("Auth");
    return res.length > 0 ? true : false;
  }

  Future<Auth> getAuth() async {
    var dbClient = await db;
    var res = await dbClient.query("Auth", limit: 1);
    return new Auth.fromMap(res.first);
  }
}
