import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../assets/fonts/fonts.dart';

class BeatableAI extends StatefulWidget {
  const BeatableAI({super.key});

  @override
  State<BeatableAI> createState() => _BeatableAIState();
}

class _BeatableAIState extends State<BeatableAI> {
  List<String> board = List.filled(9, '');
  bool isPlayer1Turn = true; // Player 1 starts
  bool gameFinished = false;
  int exScore = 0;
  int ohScore = 0;

  void makeMove(int index) {
    if (!gameFinished && board[index] == '') {
      setState(() {
        board[index] = isPlayer1Turn ? 'X' : 'O';
        isPlayer1Turn = !isPlayer1Turn;
      });
      checkWinner();
      if (!isPlayer1Turn && !gameFinished) {
        // AI's turn
        int aiMove = getBestMove();
        makeMove(aiMove);
      }
    }
  }

  int getBestMove() {
    // Introduce randomness to make the AI beatable
    Random random = Random();
    if (random.nextDouble() < 0.3) {
      // 30% chance to make a random move
      List<int> availableMoves = [];
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          availableMoves.add(i);
        }
      }
      return availableMoves[random.nextInt(availableMoves.length)];
    }

    // Otherwise, make the best move
    int bestScore = -1000;
    int bestMove = -1;
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = 'O';
        int score = minimax(board, 0, false);
        board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }
    return bestMove;
  }

  int minimax(List<String> board, int depth, bool isMaximizing) {
    int score = evaluate(board);
    if (score == 10) return score;
    if (score == -10) return score;
    if (!board.contains('')) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'O';
          bestScore = max(bestScore, minimax(board, depth + 1, !isMaximizing));
          board[i] = '';
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'X';
          bestScore = min(bestScore, minimax(board, depth + 1, !isMaximizing));
          board[i] = '';
        }
      }
      return bestScore;
    }
  }

  int evaluate(List<String> board) {
    for (int i = 0; i < 3; i++) {
      if (board[i * 3] == board[i * 3 + 1] &&
          board[i * 3] == board[i * 3 + 2]) {
        if (board[i * 3] == 'O') return 10;
        if (board[i * 3] == 'X') return -10;
      }
      if (board[i] == board[i + 3] && board[i] == board[i + 6]) {
        if (board[i] == 'O') return 10;
        if (board[i] == 'X') return -10;
      }
    }
    if (board[0] == board[4] && board[0] == board[8]) {
      if (board[0] == 'O') return 10;
      if (board[0] == 'X') return -10;
    }
    if (board[2] == board[4] && board[2] == board[6]) {
      if (board[2] == 'O') return 10;
      if (board[2] == 'X') return -10;
    }
    return 0; // No winner yet
  }

  void checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (board[i * 3] == board[i * 3 + 1] &&
          board[i * 3] == board[i * 3 + 2] &&
          board[i * 3] != '') {
        showWinnerDialog(board[i * 3]);
        return;
      }
      if (board[i] == board[i + 3] &&
          board[i] == board[i + 6] &&
          board[i] != '') {
        showWinnerDialog(board[i]);
        return;
      }
    }
    if (board[0] == board[4] && board[0] == board[8] && board[0] != '') {
      showWinnerDialog(board[0]);
      return;
    }
    if (board[2] == board[4] && board[2] == board[6] && board[2] != '') {
      showWinnerDialog(board[2]);
      return;
    }
    if (!board.contains('')) {
      showDrawDialog();
    }
  }

  void showWinnerDialog(String winner) {
    setState(() {
      gameFinished = true;
    });
    String win = '';
    if (winner == 'X') {
      win = 'Congratulations! You are the winner!';
    } else {
      win = 'AI won!';
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade700,
        title: Text(
          'Game Over',
          style: gameFontBoldBright,
        ),
        content: Text(
          win,
          style: gameFontBright,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              resetGame();
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            child: Text(
              'Play Again',
              style: gameFontBright,
            ),
          ),
        ],
      ),
    );
    if (winner == 'O') {
      ohScore++;
    } else if (winner == 'X') {
      exScore++;
    }
  }

  void showDrawDialog() {
    setState(() {
      gameFinished = true;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade700,
        title: Text(
          'Game Over',
          style: gameFontBoldBright,
        ),
        content: Text(
          'Draw',
          style: gameFontBright,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              resetGame();
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            child: Text('Play Again', style: gameFontBright),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isPlayer1Turn = true;
      gameFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Expanded(
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "Playing With Normal AI",
                            style: gameFontBoldBright,
                          ),
                        ),
                        Center(
                          child: Text(
                            "ScoreBoard",
                            style: gameFontBoldBright,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Your Score',
                                    style: gameFontBright,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    exScore.toString(),
                                    style: gameFontBright,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'AI Score',
                                    style: gameFontBright,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    ohScore.toString(),
                                    style: gameFontBright,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              makeMove(index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  board[index],
                                  style: gameFontBoldBright,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: 9,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: resetGame,
                          child: const Icon(
                            Icons.refresh_rounded,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      ' @COBACREATION',
                      textStyle: GoogleFonts.robotoMono(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 3,
                          fontSize: 15,
                        ),
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  isRepeatingAnimation: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
