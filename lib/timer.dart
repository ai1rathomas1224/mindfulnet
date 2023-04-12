import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vibration/vibration.dart';
import 'study_log.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int workTime = 25 * 60;
  int breakTime = 5 * 60;
  bool timeStart = false;
  bool timeReset = false;
  var period = const Duration(seconds: 1);
  double percent = 0;
  List<String> reviseLog = [];
  Timer? timer;
  List<StudyLog> studyLogs = [];
  String _studySubject = "";
  List<String> _studyHistory = [];

  void timeResetCount() {
    timeStart = false;
    workTime = 25 * 60;
    percent = 0;
    timer?.cancel();
  }

  void timeStartCount() {
    if (timeStart) return;

    timeStart = true;

    timer = Timer.periodic(period, (_) {
      if (workTime < 1 || !timeStart) {
        timer?.cancel();
        workTime = 25 * 60;
        percent = 0;
        if (timeStart) {
          _showAlertDialog();
        }
      } else {
        workTime--;
        percent = 1 - (workTime / (25 * 60));
      }
      setState(() {});
    });
  }

  void timePauseCount() {
    timeStart = false;
    timer?.cancel();
  }

  void _showAlertDialog() async {
    TextEditingController subjectController = TextEditingController();
    String subject = '';
    DateTime now = DateTime.now();
    setState(() {
      studyLogs = studyLogs;
    });

    await Vibration.vibrate();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Revise Log'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                ),
                onChanged: (value) {
                  subject = value;
                },
              ),
              SizedBox(height: 16.0),
              Text('Date: ${now.day}/${now.month}/${now.year}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {
                  _studySubject = subject;
                  _studyHistory.add(
                      '${now.day}/${now.month}/${now.year} - ${(workTime)}');
                });
                Navigator.of(context).pop();
                await _saveStudyLog();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<Database> _getDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/study_log.db';

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE study_logs (id INTEGER PRIMARY KEY AUTOINCREMENT, subject TEXT, date TEXT, duration TEXT)',
        );
      },
    );
  }

  String formatTime(int timeInSeconds) {
    final minutes = timeInSeconds ~/ 60;
    final seconds = timeInSeconds % 60;

    return '${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}';
  }

  Future<void> _saveStudyLog() async {
    final database = await _getDatabase();
    final now = DateTime.now();
    final date = '${now.day}/${now.month}/${now.year}';

    await database.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO study_logs(subject, date, duration) VALUES("$_studySubject", "$date", "${formatTime(workTime)}")',
      );
    });

    await _loadStudyLogs();
  }

  Future<void> _loadStudyLogs() async {
    final database = await _getDatabase();
    final data = await database.query('study_logs');

    @override
    void initState() {
      super.initState();
      _loadStudyLogs();
    }

    @override
    void dispose() {
      timer?.cancel();
      super.dispose();
    }

    String formatTime(int timeInSeconds) {
      final minutes = timeInSeconds ~/ 60;
      final seconds = timeInSeconds % 60;

      return '${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}';
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Pomodoro Timer'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: CircularPercentIndicator(
                  percent: percent,
                  animation: true,
                  animateFromLastPercent: true,
                  radius: 150.0,
                  lineWidth: 20.0,
                  progressColor: Colors.yellow,
                  center: Container(
                    width: 150,
                    height: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      '${formatTime(workTime)}',
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 60.0,
                    width: 120.0,
                    child: ElevatedButton(
                      onPressed: () => timeStartCount(),
                      child: Text('START'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                    width: 120.0,
                    child: ElevatedButton(
                      onPressed: () => timePauseCount(),
                      child: Text('PAUSE'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                    width: 120.0,
                    child: ElevatedButton(
                      onPressed: () => timeResetCount(),
                      child: Text('RESET'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: CircularPercentIndicator(
                percent: percent,
                animation: true,
                animateFromLastPercent: true,
                radius: 150.0,
                lineWidth: 20.0,
                progressColor: Colors.yellow,
                center: Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    '${formatTime(workTime)}',
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 60.0,
                  width: 120.0,
                  child: ElevatedButton(
                    onPressed: () => timeStartCount(),
                    child: Text('START'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60.0,
                  width: 120.0,
                  child: ElevatedButton(
                    onPressed: () => timePauseCount(),
                    child: Text('PAUSE'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60.0,
                  width: 120.0,
                  child: ElevatedButton(
                    onPressed: () => timeResetCount(),
                    child: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
