import 'package:new_chat_app/app/models/user.dart';
import 'package:new_chat_app/core/constants.dart';
import 'package:new_chat_app/core/failure.dart';
import 'package:new_chat_app/services/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late DatabaseHelper instance;

  static Database? _db;

  static initialize() {
    instance = DatabaseHelper._internal();
  }

  DatabaseHelper._internal() {
    initDb();
  }

  initDb() async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'news_chat_app.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE IF NOT EXISTS users(user_id varchar primary key,username unique not null,password varchar not null,is_logged_in int not null)');
      },
      version: 1,
    );
    _db = database;
  }

  Future<void> insertUser(Map<String, dynamic> userMap) async {
    await _db!.insert('users', userMap, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> logoutUser(String userId) async {
    await _db!.rawUpdate('UPDATE users SET is_logged_in = 0 WHERE user_id = ?', [userId]); // 0 -> false || 1 - true
  }

  Future<bool> checkUserLoggedIn() async {
    final List<Map<String, dynamic>> maps = await _db!.query('users', where: 'is_logged_in = ?', whereArgs: [1]);

    if (maps.isEmpty) {
      return false;
    } else {
      User.instance.userId = maps.first['user_id'];
      User.instance.username = maps.first['username'];
      return true;
    }
  }

  Future<void> _login(String username) async {
    await _db!.rawUpdate('UPDATE users SET is_logged_in = 1 WHERE username = ?', [username]); // 0 -> false || 1 - true
  }

  Future<Map<String, Object?>> getUser(String username) async {
    try {
      List<Map<String, Object?>> response = await _db!.query('users', where: 'username = ?', whereArgs: [username]);
      if (response.isEmpty) {
        throw Failure(message: 'Invalid Credentials');
      }
      _login(username);
      return response.first;
    } catch (e) {
      logger.e(e);
      throw Failure(message: 'Failed to login');
    }
  }
}
