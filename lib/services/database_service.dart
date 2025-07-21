import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/training_session.dart';

abstract class ITrainingSessionService {
  Future<int> addTrainingSession(TrainingSession session);
  Future<List<TrainingSession>> getTrainingSessions(int userId);
  Future<int> updateTrainingSession(TrainingSession session);
  Future<int> deleteTrainingSession(int id);
}

class DatabaseService implements ITrainingSessionService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'myjudo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT,
        dojo TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE training_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        dojo TEXT,
        user_id INTEGER NOT NULL,
        techniques TEXT,
        types TEXT,
        duration INTEGER,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');
  }

  // User CRUD
  Future<int> addUser(User user) async {
    final db = await database;
    return await db.insert('users', {
      'username': user.username,
      'email': user.email,
      'dojo': user.dojo,
    });
  }

  Future<User?> getUser(int id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      final data = maps.first;
      return User(
        id: data['id'] as int,
        username: data['username'] as String,
        email: data['email'] as String,
        dojo: data['dojo'] as String?,
      );
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      {
        'username': user.username,
        'email': user.email,
        'dojo': user.dojo,
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // TrainingSession CRUD
  @override
  Future<int> addTrainingSession(TrainingSession session) async {
    final db = await database;
    return await db.insert('training_sessions', {
      'date': session.date,
      'dojo': session.dojo,
      'user_id': session.userId,
      'techniques': session.techniques.join(','),
      'types': session.types.join(','),
      'duration': session.duration,
    });
  }

  @override
  Future<List<TrainingSession>> getTrainingSessions(int userId) async {
    final db = await database;
    final maps = await db
        .query('training_sessions', where: 'user_id = ?', whereArgs: [userId]);
    return maps
        .map((data) => TrainingSession(
              id: data['id'] as int?,
              date: data['date'] as String,
              dojo: data['dojo'] as String?,
              userId: data['user_id'] as int,
              techniques: (data['techniques'] as String?)
                      ?.split(',')
                      .where((t) => t.isNotEmpty)
                      .toList() ??
                  [],
              types: (data['types'] as String?)
                      ?.split(',')
                      .where((t) => t.isNotEmpty)
                      .toList() ??
                  [],
              duration: data['duration'] as int? ?? 0,
            ))
        .toList();
  }

  @override
  Future<int> updateTrainingSession(TrainingSession session) async {
    final db = await database;
    return await db.update(
      'training_sessions',
      {
        'date': session.date,
        'dojo': session.dojo,
        'user_id': session.userId,
        'techniques': session.techniques.join(','),
        'types': session.types.join(','),
        'duration': session.duration,
      },
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  @override
  Future<int> deleteTrainingSession(int id) async {
    final db = await database;
    return await db
        .delete('training_sessions', where: 'id = ?', whereArgs: [id]);
  }
}
