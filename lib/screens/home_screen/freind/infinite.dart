import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../assets/fonts/fonts.dart';

class InfiniteScreen extends StatefulWidget {
  const InfiniteScreen({super.key});

  @override
  State<InfiniteScreen> createState() => _InfiniteScreenState();
}

class _InfiniteScreenState extends State<InfiniteScreen> {
  bool exTurn = true;
  bool gameFinished = false;
  List<String> displayExOh = List.filled(9, '');
  List<int> moveHistory = [];

  int exScore = 0;
  int ohScore = 0;
  int filledBox = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Playing With Friend",
                        style: gameFontBoldBright,
                      ),
                      Text(
                        "ScoreBoard",
                        style: gameFontBoldBright,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Player X',
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
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Player O',
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
                      (exTurn)
                          ? Text(
                              'X Turn',
                              style: gameFontBoldBright,
                            )
                          : Text(
                              'O Turn',
                              style: gameFontBoldBright,
                            ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                        itemCount: 9,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              _tapped(index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 3000),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.grey.shade700,
                              )),
                              child: Center(
                                child: Text(
                                  displayExOh[index],
                                  // index.toString(),
                                  style: gameFontBoldBright,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Expanded(
                    child: Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _clearBoard,
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ))
              ],
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

  void _tapped(int index) {
    setState(() {
      if (displayExOh[index] == '') {
        if (exTurn) {
          displayExOh[index] = 'X';
        } else {
          displayExOh[index] = 'O';
        }
        moveHistory.add(index);
        filledBox++;

        _checkWinner();
        if (filledBox > 6) {
          int oldestMove = moveHistory.removeAt(0);
          displayExOh[oldestMove] = '';
          filledBox--;
        }

        exTurn = !exTurn;
      }
    });
  }

  void _checkWinner() {
    // check 1st row
    if (displayExOh[0] == displayExOh[1] &&
        displayExOh[0] == displayExOh[2] &&
        displayExOh[0] != '') {
      _showWinnerDialog(displayExOh[0]);
    }

    // check 2nd row
    if (displayExOh[3] == displayExOh[4] &&
        displayExOh[3] == displayExOh[5] &&
        displayExOh[3] != '') {
      _showWinnerDialog(displayExOh[3]);
    }

    // check 3rd row
    if (displayExOh[6] == displayExOh[7] &&
        displayExOh[6] == displayExOh[8] &&
        displayExOh[6] != '') {
      _showWinnerDialog(displayExOh[6]);
    }

    // check 1st column
    if (displayExOh[0] == displayExOh[3] &&
        displayExOh[0] == displayExOh[6] &&
        displayExOh[0] != '') {
      _showWinnerDialog(displayExOh[0]);
    }

    // check 2nd column
    if (displayExOh[1] == displayExOh[4] &&
        displayExOh[1] == displayExOh[7] &&
        displayExOh[1] != '') {
      _showWinnerDialog(displayExOh[1]);
    }

    // check 3rd column
    if (displayExOh[2] == displayExOh[5] &&
        displayExOh[2] == displayExOh[8] &&
        displayExOh[2] != '') {
      _showWinnerDialog(displayExOh[2]);
    }

    // check 1st diagonal
    if (displayExOh[0] == displayExOh[4] &&
        displayExOh[0] == displayExOh[8] &&
        displayExOh[0] != '') {
      _showWinnerDialog(displayExOh[0]);
    }

    // check 2nd diagonal
    if (displayExOh[2] == displayExOh[4] &&
        displayExOh[2] == displayExOh[6] &&
        displayExOh[2] != '') {
      _showWinnerDialog(displayExOh[2]);
    } else if (filledBox == 9) {
      _showDrawDialog();
    }
  }

  void _showDrawDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
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
                  _clearBoard();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: Text('Play Again', style: gameFontBright),
              ),
            ],
          );
        });
  }

  void _showWinnerDialog(String winner) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade700,
            title: Text(
              'Game Over',
              style: gameFontBoldBright,
            ),
            content: Text(
              'Winner is : $winner',
              style: gameFontBright,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _clearBoard();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: Text('Play Again', style: gameFontBright),
              ),
            ],
          );
        });

    if (winner == 'O') {
      ohScore++;
    } else if (winner == 'X') {
      exScore++;
    }
  }

  void _clearBoard() {
    setState(() {
      displayExOh = List.filled(9, '');
      moveHistory.clear();
      filledBox = 0;
    });
  }
}
