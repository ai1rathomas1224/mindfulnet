import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiniQuiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _questionsAnswered = 0;

  final List<Question> _questions = [
    Question(
      "What is the capital city of Australia?",
      ["Sydney", "Melbourne", "Canberra", "Brisbane"],
      2,
    ),
    Question(
      "What is the largest planet in our solar system?",
      ["Mars", "Venus", "Jupiter", "Saturn"],
      2,
    ),
    Question(
      "What is the smallest country in the world by land area?",
      ["Monaco", "Nauru", "Vatican City", "San Marino"],
      2,
    ),
    Question(
      "What is the largest country in the world by land area?",
      ["China", "Russia", "Canada", "Brazil"],
      1,
    ),
    Question(
      "What is the name of the world's largest ocean?",
      ["Atlantic Ocean", "Arctic Ocean", "Indian Ocean", "Pacific Ocean"],
      3,
    ),
    Question(
      "In what year did the Titanic sink?",
      ["1910", "1912", "1914", "1916"],
      1,
    ),
    Question(
      "What is the name of the largest desert in the world?",
      ["Sahara", "Gobi", "Arabian", "Antarctic"],
      0,
    ),
    Question(
      "What is the name of the highest waterfall in the world?",
      ["Niagara Falls", "Victoria Falls", "Angel Falls", "Iguazu Falls"],
      2,
    ),
  ];

  void _answerQuestion(int answerIndex) {
    final currentQuestion = _questions[_currentQuestionIndex];
    if (currentQuestion.correctAnswerIndex == answerIndex) {
      setState(() {
        _score++;
      });
    }
    _questionsAnswered++;
    if (_questionsAnswered == 3) {
      // Start a new round
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Round Completed!'),
          content: Text('You scored $_score out of 3!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentQuestionIndex = 0;
                  _score = 0;
                  _questionsAnswered = 0;
                });
              },
              child: const Text('Start New Round'),
            ),
          ],
        ),
      );
    } else if (_currentQuestionIndex < _questions.length - 1) {
      // Ask the next question
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // End of quiz
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Quiz finish!'),
          content: Text('You scored $_score out of ${_questions.length}!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentQuestionIndex = 0;
                  _score = 0;
                  _questionsAnswered = 0;
                });
              },
              child: const Text('Restart Quiz'),
            ),
          ],
        ),
      );
    }
  }

  List<Question> _generateRandomQuestions() {
    List<Question> questionsCopy = List.from(_questions);
    questionsCopy.shuffle();
    return questionsCopy.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _generateRandomQuestions()[_questionsAnswered];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MiniQuizzes'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              currentQuestion.questionText,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ...currentQuestion.answerOptions
              .asMap()
              .entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => _answerQuestion(entry.key),
                    child: Text(entry.value),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> answerOptions;
  final int correctAnswerIndex;

  const Question(
    this.questionText,
    this.answerOptions,
    this.correctAnswerIndex,
  );
}
