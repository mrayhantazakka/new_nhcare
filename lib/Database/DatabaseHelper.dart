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
            nama_donatur TEXT NOT NULL,
            alamat TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            nomor_handphone TEXT,
            pertanyaan TEXT,
            jawaban TEXT,
            jenis_kelamin TEXT,
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

  // static Future<void> deleteDatabase() async {
  //   try {
  //     String pathDB = await getDatabasesPath();
  //     String fullPath = path.join(pathDB, 'nhcoree.db');
  //     await databaseFactory.deleteDatabase(fullPath);
  //     print("Database deleted successfully");
  //   } catch (e) {
  //     print("Error deleting the database: $e");
  //   }
  // }

  static Future<void> saveUser(User user, String token) async {
    final db = await database;
    await db.insert(
      'user',
      {
        'nama_donatur': user.nama_donatur,
        'alamat': user.alamat,
        'email': user.email,
        'password': user.password,
        'nomor_handphone': user.nomor_handphone,
        'pertanyaan': user.pertanyaan,
        'jawaban': user.jawaban,
        'jenis_kelamin': user.jenis_kelamin,
        'token': token,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateUserLocal(String token, String jawaban,
      String alamat, String nama_donatur, String nomor_handphone, String jenis_kelamin) async {
    final db = await database;
    await db.update(
      'user',
      {
        'jawaban': jawaban,
        'alamat': alamat,
        'nama_donatur': nama_donatur,
        'nomor_handphone': nomor_handphone,
        'jenis_kelamin' : jenis_kelamin,
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
