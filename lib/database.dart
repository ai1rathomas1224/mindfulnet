import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QuizDatabase {
  static const String _dbName = 'quiz.db';
  static const int _dbVersion = 1;

  static const String _tableQuestions = 'questions';
  static const String _columnQuestionText = 'questionText';
  static const String _columnAnswerOptions = 'answerOptions';
  static const String _columnCorrectAnswerIndex = 'correctAnswerIndex';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableQuestions (
            $_columnQuestionText TEXT,
            $_columnAnswerOptions TEXT,
            $_columnCorrectAnswerIndex INTEGER
          )
        ''');

        await db.execute('''
          INSERT INTO $_tableQuestions ($_columnQuestionText, $_columnAnswerOptions, $_columnCorrectAnswerIndex)
          VALUES
            ('What is the capital of France?', 'Paris|London|Berlin|Madrid', 2),
('What is the currency of Australia?', 'Australian Dollar|US Dollar|Euro|Pound', 1),
('What is the highest mountain in the world?', 'Mount Everest|K2|Kangchenjunga|Lhotse', 1),
('What is the largest animal in the world?', 'Blue Whale|Elephant|Giraffe|Hippopotamus', 2),
('What is the smallest planet in our solar system?', 'Mercury|Venus|Mars|Earth', 0),
('What is the name of the longest river in Africa?', 'Nile River|Congo River|Zambezi River|Niger River', 1),
('What is the largest country in the world?', 'Russia|Canada|China|United States', 2),
('What is the capital of South Korea?', 'Seoul|Busan|Daegu|Incheon', 0),
('What is the currency of Brazil?', 'Real|US Dollar|Euro|Pound', 1),
('Who is the author of the book "1984"?', 'George Orwell|Aldous Huxley|Ray Bradbury|Ernest Hemingway', 0),
('What is the capital of Italy?', 'Rome|Milan|Naples|Turin', 0),
('What is the currency of Canada?', 'Canadian Dollar|US Dollar|Euro|Pound', 2),
('What is the largest island in the Mediterranean?', 'Sicily|Sardinia|Cyprus|Corsica', 0),
('What is the capital of Egypt?', 'Cairo|Alexandria|Luxor|Aswan', 0),
('What is the currency of South Africa?', 'South African Rand|US Dollar|Euro|Pound', 1),
('What is the highest mountain in South America?', 'Aconcagua|Huascarán|Illimani|Sajama', 0),
('What is the smallest country in Asia by land area?', 'Maldives|Brunei|Lebanon|Singapore', 3),
('What is the name of the longest river in North America?', 'Mississippi River|Missouri River|Yukon River|Rio Grande', 0),
('What is the capital of Thailand?', 'Bangkok|Chiang Mai|Phuket|Pattaya', 0),
('What is the currency of China?', 'Chinese Yuan|US Dollar|Euro|Pound', 2),
('What is the largest country in South America?', 'Brazil|Argentina|Peru|Colombia', 1),
('What is the highest mountain in Europe?', 'Mount Elbrus|Mont Blanc|Mount Kazbek|Mount Olympus', 1),
('What is the smallest country in Africa by land area?', 'Seychelles|The Gambia|Cape Verde|Comoros', 0),
('What is the name of the longest river in South America?', 'Amazon River|Paraná River|Orinoco River|São Francisco River', 0),
('What is the capital of Russia?', 'Moscow|St. Petersburg|Novosibirsk|Yekaterinburg', 0),
('What is the currency of Mexico?', 'Mexican Peso|US Dollar|Euro|Pound', 0),
('What is the highest mountain in North America?', 'Denali|Mount Logan|Pico de Orizaba|Mount Saint Elias', 0),
('What is the largest lake in Africa?', 'Lake Victoria|Lake Tanganyika|Lake Malawi|Lake Chad', 0),
('What is the currency of India?', 'Indian Rupee|US Dollar|Euro|Pound', 1),
('What is the smallest country in Europe by land area?', 'Vatican City|Monaco|San Marino|Liechtenstein', 0),
('What is the name of the longest river in Europe?', 'Volga River|Danube River|Dnieper River|Elbe River', 1),
('What is the capital of Brazil?', 'Brasília|Rio de Janeiro|São Paulo|Salvador', 0),
('What is the currency of Argentina?', 'Argentine Peso|US Dollar|Euro|Pound', 1),
('What is the highest mountain in Asia?', 'Mount Everest|K2|Kangchenjunga|Lhotse', 0),
('What is the capital of Spain?', 'Madrid|Barcelona|Seville|Valencia', 1),
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getQuestions() async {
    final db = await database;
    return await db.query(_tableQuestions);
  }

  Future<void> addQuestion(String questionText, List<String> answerOptions,
      int correctAnswerIndex) async {
    final db = await database;
    await db.insert(_tableQuestions, {
      _columnQuestionText: questionText,
      _columnAnswerOptions: answerOptions.join('|'),
      _columnCorrectAnswerIndex: correctAnswerIndex,
    });
  }

  Future<void> deleteQuestion(String questionText) async {
    final db = await database;
    await db.delete(_tableQuestions,
        where: '$_columnQuestionText = ?', whereArgs: [questionText]);
  }
}
