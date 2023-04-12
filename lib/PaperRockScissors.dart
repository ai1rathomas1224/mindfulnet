import 'dart:math';

import 'package:flutter/material.dart';



class Game2 extends StatefulWidget {
  const Game2({Key? key}) : super(key: key);

  @override
  _Game2State createState() => _Game2State();
}

class _Game2State extends State<Game2> with SingleTickerProviderStateMixin {
  late String _playerChoice;
  late String _botChoice;
  late String _result;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _playerChoice = '';
    _botChoice = '';
    _result = '';
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _playGame(String playerChoice) {
    setState(() {
      _playerChoice = playerChoice;
      _botChoice = _getBotChoice();
      _result = _getResult(_playerChoice, _botChoice);
    });
    _controller.reset();
    _controller.forward();
  }

  String _getBotChoice() {
    final choices = ['rock', 'paper', 'scissors'];
    final random = Random();
    return choices[random.nextInt(choices.length)];
  }

  String _getResult(String playerChoice, String botChoice) {
    if (playerChoice == botChoice) {
      return 'Tie!';
    } else if (playerChoice == 'rock' && botChoice == 'scissors' ||
        playerChoice == 'paper' && botChoice == 'rock' ||
        playerChoice == 'scissors' && botChoice == 'paper') {
      return 'You win!';
    } else {
      return 'Bot wins!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff7EA4E9),
      appBar: AppBar(
        title: const Text('Rock Paper Scissors'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _animation,
            child: Text(
              _result.isNotEmpty ? _result : 'Choose your weapon!',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Choose your weapon:',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => _playGame('rock'),
                child: Image.asset(
                  'assets/rock.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              GestureDetector(
                onTap: () => _playGame('paper'),
                child: Image.asset(
                  'assets/paper.jpg',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              GestureDetector(
                onTap: () => _playGame('scissors'),
                child: Image.asset(
                  'assets/scissors.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _botChoice.isNotEmpty ? 'Bot chooses $_botChoice' : '',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
