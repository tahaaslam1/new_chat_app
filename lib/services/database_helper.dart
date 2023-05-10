import 'package:new_chat_app/app/models/user.dart';
import 'package:new_chat_app/core/constants.dart';
import 'package:new_chat_app/core/failure.dart';
import 'package:new_chat_app/services/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late DatabaseHelper instance;
  // factory DatabaseHelper() => _instance;

  static Database? _db;

  // Future<Database?> get db async {
  //   if (_db != null) {
  //     return _db;
  //   }
  //   _db = await initDb();
  //   return _db;
  // }

  static initialize() {
    instance = DatabaseHelper._internal();
  }

  DatabaseHelper._internal() {
    initDb();
  }

  initDb() async {
    // try {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'news_chat_app.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE IF NOT EXISTS users(user_id varchar primary key,username unique not null,password varchar not null,is_logged_in int not null)');
      },
      version: 1,
    );
    _db = database;
    // } catch (e) {
    // logger.e(e);
    // }
  }

  Future<void> insertUser(Map<String, dynamic> userMap) async {
    // try {
    await _db!.insert('users', userMap, conflictAlgorithm: ConflictAlgorithm.replace);
    // } catch (e) {
    // logger.e(e);
    // throw Failure(message: 'Failed to register');
    // }
  }

  Future<void> logoutUser(String userId) async {
    //try {
    await _db!.rawUpdate('UPDATE users SET is_logged_in = 0 WHERE user_id = ?', [userId]); // 0 -> false || 1 - true
    // } catch (e) {
    //   logger.e(e);
    //   throw Failure(message: 'Failed to logout');
    // }
  }

  Future<bool> checkUserLoggedIn() async {
    // _db!.rawQuery('SELECT * FROM users WHERE is_logged_in = true');

    //   try {
    final List<Map<String, dynamic>> maps = await _db!.query('users', where: 'is_logged_in = ?', whereArgs: [1]);

    if (maps.isEmpty) {
      return false;
    } else {
      logger.wtf(maps.first);
      User.instance.userId = maps.first['user_id'];
      User.instance.username = maps.first['username'];
      return true;
    }
    // } catch (e) {
    //   logger.e(e);
    //   throw Failure(message: kGenericErrorMessage);
    // }

    // final users = List.generate(maps.length, (index) {
    //   return User(
    //     userId: maps[index]['user_id'],
    //     username: maps[index]['username'],
    //     password: maps[index]['password'],
    //     isLoggedIn: maps[index]['is_logged_in'],
    //   );
    // });
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
