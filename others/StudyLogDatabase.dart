import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class StudyLogDatabase {
  static final StudyLogDatabase instance = StudyLogDatabase._init();

  static Database? _database;

  StudyLogDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('study_logs.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE study_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject TEXT,
        date TEXT,
        duration INTEGER
      )
    ''');
  }

  Future<void> insertLog(String subject, String date, int duration) async {
    final db = await instance.database;

    await db.insert(
      'study_logs',
      {'subject': subject, 'date': date, 'duration': duration},
    );
  }

  Future<List<Map<String, dynamic>>> getAllLogs() async {
    final db = await instance.database;

    return await db.query('study_logs');
  }
}
