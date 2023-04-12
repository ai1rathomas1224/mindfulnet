  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:percent_indicator/circular_percent_indicator.dart';

  class StudyLog extends StatefulWidget {
    const StudyLog({Key? key}) : super(key: key);

    @override
    _StudyLogState createState() => _StudyLogState();
  }

  class _StudyLogState extends State<StudyLog> {
    double percent = 0.0;
    List<Map<String, String>> _logList = [];

    void _addLog(String subject, String date, String duration) {
      setState(() {
        _logList.add({'subject': subject, 'date': date, 'duration': duration});
      });
    }

    void _showAddLogDialog() {
      String subject = '';
      String date = '';
      String duration = '';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Log'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                    ),
                    onChanged: (value) {
                      subject = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Date (yyyy-mm-dd)',
                    ),
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                    ],
                    onChanged: (value) {
                      date = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Duration (in minutes)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      duration = value;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _addLog(subject, date, duration);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Logbook'),
        ),
        body: _logList.isEmpty
            ? const Center(
                child: Text('Did you really study??.'),
              )
            : ListView.builder(
                itemCount: _logList.length,
                itemBuilder: (BuildContext context, int index) {
                  final log = _logList[index];
                  return ListTile(
                    title: Text(log['subject']!),
                    subtitle: Text('${log['date']} | ${log['duration']}'),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddLogDialog,
          tooltip: 'Add Log',
          child: const Icon(Icons.add),
        ),
      );
    }
  }
