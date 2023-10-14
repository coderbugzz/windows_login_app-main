import 'dart:io' as io;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  // returns the instance of DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // reference to the database marked as private
  static Database? _database;

  // factory method that returns an instance of DatabaseHelper
  // to ensure that DatabaseHelper has only one instance in the application
  DatabaseHelper._privateConstructor();

  // get the database, if it is not initialized, initialize it first
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    // initialize the ffi loader to ensure that sqlite will work
    sqfliteFfiInit();

    // create path to store the database
    final io.Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbPath = p.join(appDirectory.path, 'databases', 'mysqlite.db');

    final dbFactory = databaseFactoryFfi;

    // Open the database and return the reference
    return await dbFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );
  }

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    // create 'users' table where the user credential will be stored
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<int> createUser(
      {required String name,
      required String username,
      required String password}) async {
    Database db = await instance.database;

    return await db.insert(
      'users',
      <String, Object?>{
        'name': name,
        'username': username,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, Object?>>> loginUser({
    required String username,
    required String password,
  }) async {
    final db = await DatabaseHelper.instance.database;

    // query the database for the user
    return await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [
        username,
        password,
      ],
    );
  }
}
