import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:untitled11/gamecenter.dart';

import 'Timer.dart';
import 'study_log.dart';


void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("images/backani.gif"),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Mindful Net',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pacifico',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: Icon(FluentIcons.notebook_16_filled),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudyLog()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(FluentIcons.games_24_regular),
            tooltip: "GameCenter",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Gamecenter()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TimerPage()),
          );
        },
        child: Icon(FluentIcons.clock_lock_24_regular),
      ),
    );
  }
}