import 'package:flutter/material.dart';
import 'package:untitled11/PaperRockScissors.dart';
import 'package:untitled11/tictactoe1.dart';
import 'package:untitled11/QuizGame.dart';

class Gamecenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 150),
          Text(
            'Mini Games',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 150),
          Row(
            children: [
              const SizedBox(),
              Expanded(
                child: IconButton(
                  icon: Image.asset("images/tac.png"),
                  iconSize: 150,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TicTacToeGame()));
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Image.asset("images/RPS.png"),
                  iconSize: 150,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Game2()));
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Image.asset("images/trivia.png"),
                  iconSize: 150,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => QuizPage()));
                  },
                ),
              ),
              const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
