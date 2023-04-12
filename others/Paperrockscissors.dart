/*import 'package:flutter/material.dart';
import 'dart:math';

enum Choice {
  paper,
  rock,
  scissors,
}

void main() => runApp(PaperRockScissors());

class PaperRockScissors extends StatefulWidget {
  @override
  _PaperRockScissorsState createState() => _PaperRockScissorsState();
}

class _PaperRockScissorsState extends State<PaperRockScissors> {
  int _playerScore = 0;
  int _computerScore = 0;
  Choice _playerChoice;
  Choice _computerChoice;
  String _gameResult = '';

  void _playGame(Choice playerChoice) {
    setState(() {
      _playerChoice = playerChoice;
      _computerChoice = _getComputerChoice();
      if (_playerChoice == _computerChoice) {
        _gameResult = 'Tie!';
      } else if (_playerChoice == Choice.paper && _computerChoice == Choice.rock ||
          _playerChoice == Choice.rock && _computerChoice == Choice.scissors ||
          _playerChoice == Choice.scissors && _computerChoice == Choice.paper) {
        _playerScore++;
        _gameResult = 'You won!';
      } else {
        _computerScore++;
        _gameResult = 'Computer won!';
      }
    });
  }

  Choice _getComputerChoice() {
    List<Choice> choices = Choice.values;
    return choices[Random().nextInt(choices.length)];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paper Rock Scissors',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Paper Rock Scissors'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: Image.asset('assets/images/paper.png', height: 100),
                  onTap: () {
                    _playGame(Choice.paper);
                  },
                ),
                GestureDetector(
                  child: Image.asset('assets/images/rock.png', height: 100),
                  onTap: () {
                    _playGame(Choice.rock);
                  },
                ),
                GestureDetector(
                  child: Image.asset('assets/images/scissors.png', height: 100),
                  onTap: () {
                    _playGame(Choice.scissors);
                  },
                ),
              ],
            ),
            Text(_gameResult, style: TextStyle(fontSize: 30)),
            Text('You: $_playerScore - Computer: $_computerScore', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
*/