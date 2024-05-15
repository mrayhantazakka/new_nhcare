import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:nhcoree/Models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  static Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    try {
      String pathDB = await getDatabasesPath();
      String fullPath = path.join(pathDB, 'nhcoree.db');

      return await openDatabase(
        fullPath,
        version: 1,
        onCreate: (db, version) async {
          // Define table schema if the database is newly created
          await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullname TEXT NOT NULL,
            username TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            phone TEXT,
            question TEXT,
            answer TEXT,
            token TEXT
          )
        ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('ALTER TABLE user ADD COLUMN token TEXT');
          }
        },
      );
    } catch (e) {
      print("Error initializing the database: $e");
      rethrow;
    }
  }

  static Future<void> saveUser(User user, String token) async {
    final db = await database;
    await db.insert(
      'user',
      {
        'fullname': user.fullname,
        'username': user.username,
        'email': user.email,
        'password': user.password,
        'phone': user.phone,
        'question': user.question,
        'answer': user.answer,
        'token': token,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateUserLocal(String token, String answer,
      String username, String fullname, String phone) async {
    final db = await database;
    await db.update(
      'user',
      {
        'answer': answer,
        'username': username,
        'fullname': fullname,
        'phone': phone,
      
      },
      where: 'token = ?',
      whereArgs: [token],
    );
  }

  static Future<User?> getUserFromLocal(String token) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'user',
        where: 'token = ?',
        whereArgs: [token],
      );

      if (maps.isNotEmpty) {
        return User.fromJson(maps.first);
      } else {
        return null;
      }
    } catch (error) {
      print("Error fetching user from the local database: $error");
      return null;
    }
  }
}
