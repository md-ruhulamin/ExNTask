// ignore_for_file: avoid_print

import 'package:note_app/expences/expense.dart';
import 'package:note_app/notes/notes.dart';
import 'package:note_app/task/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  static final table = 'settings';
  static final columnId = 'id';
  static final columnKey = 'key';
  static final columnValue = 'value';

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnKey TEXT UNIQUE NOT NULL,
        $columnValue TEXT
      )
    ''');
    await db.execute('''
   CREATE TABLE tasks (
        taskId INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        isDone INTEGER,
        startDateTime TEXT,
        deadlineDateTime TEXT,
        taskColor INTEGER
      )
    ''');
    await db.execute('''
     CREATE TABLE notes (
    noteId INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    dateTime TEXT,
    color INTEGER
  )
    ''');

    await db.execute('''
    CREATE TABLE expense (
    expenseId INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT NOT NULL,
    description TEXT,
    amount REAL NOT NULL,
    dateTime TEXT NOT NULL,
    color INTEGER,
    type TEXT NOT NULL CHECK (type IN ('Earning', 'Expense'))
)
    ''');
  }

  Future<bool> checkIfFirstTime() async {
    print("Checking First Time");
    Database db = await instance.database;
    var result = await db
        .query(table, where: "$columnKey = ?", whereArgs: ['isFirstTime']);
    return result.isEmpty;
  }

  Future<void> setFirstTimeComplete() async {
    Database db = await instance.database;
    await db.insert(table, {columnKey: 'isFirstTime', columnValue: 'false'},
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("Completed First Time");
  }
  // --- Task CRUD Operations ---

  Future<void> insertTask(Task task) async {
    print("Insert start");
    final db = await instance.database;
    await db.insert('tasks', task.toMap());
    print("Insert finished");
  }

  Future<List<Task>> fetchTasks() async {
    print("Fetch start");
    final db = await instance.database;
    final result = await db.query('tasks');
    print("Fetch finished " + result.length.toString());

    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<void> updateTask(Task task) async {
    final db = await instance.database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'taskId = ?',
      whereArgs: [task.taskId],
    );
  }

  Future<void> deleteTask(int taskId) async {
    print("Task Delete Method $taskId");
    final db = await instance.database;
    await db.delete(
      'tasks',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
  }

  // --- Note CRUD Operations ---

  Future<void> insertNote(Note note) async {
    final db = await instance.database;
    await db.insert('notes', note.toMap());
  }

  Future<List<Note>> fetchNotes() async {
   
    final db = await instance.database;
    final result = await db.query('notes');

    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<void> updateNote(Note note) async {
    print("Update funtion");
    final db = await instance.database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'noteId = ?',
      whereArgs: [note.noteId],
    );
    print("Updated");
  }

  Future<void> deleteNote(int noteId) async {
    final db = await instance.database;
    await db.delete(
      'notes',
      where: 'noteId = ?',
      whereArgs: [noteId],
    );
  }

  // --- Note CRUD Operations ---

// Create an Expense
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert(
      'expense',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read all Expenses
  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expense');
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  // Read a single Expense by ID
  Future<Expense?> getExpenseById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expense',
      where: 'expenseId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Expense.fromMap(maps.first);
    }
    return null;
  }

  // Update an Expense
  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expense',
      expense.toMap(),
      where: 'expenseId = ?',
      whereArgs: [expense.expenseId],
    );
  }

  // Delete an Expense
  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      'expense',
      where: 'expenseId = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
