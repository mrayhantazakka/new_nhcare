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
      String fullPath = path.join(pathDB, 'nurul_care');

      return await openDatabase(
        fullPath,
        version: 2, // Increment the version number
        onCreate: (db, version) async {
          // Define table schema if the database is newly created
          await db.execute('''
          CREATE TABLE user (
            id_donatur TEXT PRIMARY KEY,
            nama_donatur TEXT NOT NULL,
            nomor_handphone TEXT,
            alamat TEXT NOT NULL,
            jenis_kelamin TEXT,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            pertanyaan TEXT,
            jawaban TEXT,
            token TEXT
          )
        ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            // Perform migration if old version is less than 2
            await db.execute('''
              CREATE TABLE user_new (
                id_donatur TEXT PRIMARY KEY,
                nama_donatur TEXT NOT NULL,
                nomor_handphone TEXT,
                alamat TEXT NOT NULL,
                jenis_kelamin TEXT,
                email TEXT NOT NULL UNIQUE,
                password TEXT NOT NULL,
                pertanyaan TEXT,
                jawaban TEXT,
                token TEXT
              )
            ''');
            await db.execute('''
              INSERT INTO user_new (id_donatur, nama_donatur, nomor_handphone, alamat, jenis_kelamin, email, password, pertanyaan, jawaban, token)
              SELECT CAST(id AS TEXT), nama_donatur, nomor_handphone, alamat, jenis_kelamin, email, password, pertanyaan, jawaban, token FROM user
            ''');
            await db.execute('DROP TABLE user');
            await db.execute('ALTER TABLE user_new RENAME TO user');
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
        'id_donatur': user.id_donatur,
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

  static Future<void> updateUserLocal(
      String token,
      String jawaban,
      String alamat,
      String nama_donatur,
      String nomor_handphone,
      String jenis_kelamin) async {
    final db = await database;
    await db.update(
      'user',
      {
        'jawaban': jawaban,
        'alamat': alamat,
        'nama_donatur': nama_donatur,
        'nomor_handphone': nomor_handphone,
        'jenis_kelamin': jenis_kelamin,
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
