import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'test_app.db');

    return await openDatabase(
      path,
      version: 6,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount REAL NOT NULL,
      category TEXT NOT NULL,
      type TEXT NOT NULL,
      date TEXT NOT NULL,
      notes TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT,
      bank_id INTEGER
    )
  ''');

    await db.execute('''
    CREATE TABLE banks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      card_number TEXT NOT NULL,
      balance REAL NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT
    )
  ''');
  }

  Future<int> updateBank(Map<String, dynamic> bankRow) async {
    Database db = await database;
    int id = bankRow['id'];
    return await db.update('banks', bankRow, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('''
      CREATE TABLE banks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        balance REAL NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
      ''');

      await db.execute('ALTER TABLE transactions ADD COLUMN bank_id INTEGER');
    }

    if (oldVersion < 5) {
      await db.execute(
        'ALTER TABLE banks ADD COLUMN card_number TEXT NOT NULL DEFAULT ""',
      );
    }

    if (oldVersion < 6) {
      await db.execute(
        'ALTER TABLE transactions ADD COLUMN is_payback INTEGER DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE transactions ADD COLUMN is_completed INTEGER DEFAULT 0',
      );
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
    _database = null;
  }
}
