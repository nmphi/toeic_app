import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'user_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertUser(String username) async {
    final db = await database;
    await db.insert(
      'users',
      {'username': username},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db.query('users');
    if (users.isNotEmpty) {
      return users[0]['username'];
    } else {
      return null;
    }
  }
}
