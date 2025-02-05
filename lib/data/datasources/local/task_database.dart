import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taski/data/models/task_model.dart';

class TaskDatabase {
  static final TaskDatabase _instance = TaskDatabase._();
  static Database? _database;

  TaskDatabase._();

  factory TaskDatabase() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'tasks.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            title TEXT,
            isCompleted INTEGER,
            description TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE tasks ADD COLUMN description TEXT;
          ''');
        }
      },
    );
  }

  Future<List<TaskModel>> searchTasks(String query) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );
    return result.map((e) => TaskModel.fromJson(e)).toList();
  }

  Future<List<TaskModel>> getTasks(int limit, int offset) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [0],
      limit: limit,
      offset: offset,
    );
    return result.map((e) => TaskModel.fromJson(e)).toList();
  }

  Future<List<TaskModel>> getCompletedTasks(
      {int limit = 10, int offset = 0}) async {
    final db = await _instance.database;
    final result = await db.rawQuery(
      '''
    SELECT * FROM tasks
    WHERE isCompleted = ?
    ORDER BY id DESC
    LIMIT ? OFFSET ?
    ''',
      [1, limit, offset],
    );

    return result.map((e) => TaskModel.fromJson(e)).toList();
  }

  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.insert('tasks', task.toJson());
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await database;
    await db
        .update('tasks', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getTotalTasks() async {
    final db = await database;
    final result = await db
        .rawQuery('SELECT COUNT(*) as total FROM tasks where isCompleted = 0');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> clearTasks() async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [1],
    );
  }
}
