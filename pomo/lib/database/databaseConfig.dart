import 'package:path/path.dart';
import 'package:pomo/database/user_data.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _database = DatabaseService._internal();
  late Future<Database> database;

  factory DatabaseService() => _database;

  DatabaseService._internal() {
    databaseConfig();
  }

  Future<bool> databaseConfig() async {
    try {
      database = openDatabase(
        join(await getDatabasesPath(), 'user_database.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, password TEXT, egg INTEGER)',
          );
        },
        version: 1,
      );
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<bool> addUser(UserData user) async {
    final Database db = await database;
    try {
      db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<UserData> Word(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> data =
        await db.query('words', where: "id = ?", whereArgs: [id]);
    return UserData(
      id: data[0]['id'],
      name: data[0]['name'],
      password: data[0]['password'],
      egg: data[0]['egg'],
    );
  }

  Future<bool> updateUserData(UserData word) async {
    final Database db = await database;
    try {
      db.update(
        'words',
        word.toMap(),
        where: "password = ?",
        whereArgs: [word.password],
      );
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> deleteWord(int id) async {
    final Database db = await database;
    try {
      db.delete(
        'words',
        where: "id = ?",
        whereArgs: [id],
      );
      return true;
    } catch (err) {
      return false;
    }
  }
}
