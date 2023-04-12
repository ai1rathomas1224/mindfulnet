import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<String> gameBoard;
  late String player;
  late String aiPlayer;
  late bool isPlayerTurn;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    setState(() {
      gameBoard = List.generate(9, (index) => '');
      player = 'X';
      aiPlayer = 'O';
      isPlayerTurn = true;
    });
  }

  bool isBoardFull() {
    return !gameBoard.contains('');
  }

  bool hasPlayerWon(String player) {
    // check rows
    for (int i = 0; i < 9; i += 3) {
      if (gameBoard[i] == player &&
          gameBoard[i + 1] == player &&
          gameBoard[i + 2] == player) {
        return true;
      }
    }

    // check columns
    for (int i = 0; i < 3; i++) {
      if (gameBoard[i] == player &&
          gameBoard[i + 3] == player &&
          gameBoard[i + 6] == player) {
        return true;
      }
    }

    // check diagonals
    if (gameBoard[0] == player &&
        gameBoard[4] == player &&
        gameBoard[8] == player) {
      return true;
    }

    if (gameBoard[2] == player &&
        gameBoard[4] == player &&
        gameBoard[6] == player) {
      return true;
    }

    return false;
  }

  void makeAiMove() {
    Future.delayed(Duration(seconds: 1), () {
      int index = Random().nextInt(9);
      while (gameBoard[index] != '') {
        index = Random().nextInt(9);
      }
      setState(() {
        gameBoard[index] = aiPlayer;
        isPlayerTurn = true;
      });
    });
  }

  void handlePlayerMove(int index) {
    if (gameBoard[index] != '') {
      return;
    }

    setState(() {
      gameBoard[index] = player;
      isPlayerTurn = false;
    });

    if (hasPlayerWon(player)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Congratulations'),
            content: Text('You win'),
            actions: <Widget>[
              TextButton(
                child: Text('Play a new game?'),
                onPressed: () {
                  startNewGame();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (isBoardFull()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Draw'),
            content: Text('Its a tie'),
            actions: <Widget>[
              TextButton(
                child: Text('Play a new game?'),
                onPressed: () {
                  startNewGame();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      makeAiMove();
      if (hasPlayerWon(aiPlayer)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Game Over'),
              content: Text('This time the bot wins'),
              actions: <Widget>[
                TextButton(
                  child: Text('Play a new game?'),
                  onPressed: () {
                    startNewGame();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else if (isBoardFull()) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Draw'),
              content: Text('The game ended in a draw.'),
              actions: <Widget>[
                TextButton(
                  child: Text('New Game'),
                  onPressed: () {
                    startNewGame();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: isPlayerTurn
                      ? () {
                          handlePlayerMove(index);
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        gameBoard[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 30.0),
            Text(
              isPlayerTurn ? 'Your turn' : 'Bot is Thinking',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
            SizedBox(height: 30.0),
            IconButton(
              icon: Icon(FluentIcons.play_32_regular),
              onPressed: () {
                startNewGame();
              },
            ),
          ],
        ),
      ),
    );
  }
}
