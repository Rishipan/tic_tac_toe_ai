import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../assets/fonts/fonts.dart';
import '../../../../firestore_services.dart';

class FiniteMultiScreen extends StatefulWidget {
  final String roomId;
  final String playerId;

  const FiniteMultiScreen(
      {super.key, required this.roomId, required this.playerId});

  @override
  _FiniteMultiScreenState createState() => _FiniteMultiScreenState();
}

class _FiniteMultiScreenState extends State<FiniteMultiScreen> {
  List<String> displayExOh = List.filled(9, '');
  bool exTurn = true;
  bool gameFinished = false;
  int exScore = 0;
  int ohScore = 0;
  int filledBox = 0;
  bool isProcessingMove = false; // New variable to track move processing

  @override
  void initState() {
    super.initState();
    _listenToGameUpdates();
  }

  void _listenToGameUpdates() {
    Provider.of<FirestoreService>(context, listen: false)
        .listenToRoom(widget.roomId)
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          displayExOh = [
            ...List<String>.from(data['board']['row0']),
            ...List<String>.from(data['board']['row1']),
            ...List<String>.from(data['board']['row2']),
          ];
          exTurn = data['currentPlayer'] == 'X';
          gameFinished = _checkWinner() != null;
        });
      }
    });
  }

  void _makeMove(int index) async {
    if (isProcessingMove) return; // Prevent processing another move

    if (displayExOh[index] == '' &&
        !gameFinished &&
        (exTurn && widget.playerId == 'X' ||
            !exTurn && widget.playerId == 'O')) {
      setState(() {
        displayExOh[index] = exTurn ? 'X' : 'O';
        filledBox++;
        exTurn = !exTurn;
        isProcessingMove = true; // Set move processing flag
      });

      await _updateGameInFirestore();

      setState(() {
        isProcessingMove = false; // Reset move processing flag
      });

      _checkWinner();
    }
  }

  Future<void> _updateGameInFirestore() async {
    await Provider.of<FirestoreService>(context, listen: false)
        .updateRoom(widget.roomId, {
      'board': {
        'row0': displayExOh.sublist(0, 3),
        'row1': displayExOh.sublist(3, 6),
        'row2': displayExOh.sublist(6, 9),
      },
      'currentPlayer': exTurn ? 'X' : 'O',
    });
  }

  String? _checkWinner() {
    List<List<int>> winConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6] // Diagonals
    ];

    for (var condition in winConditions) {
      if (displayExOh[condition[0]] == displayExOh[condition[1]] &&
          displayExOh[condition[1]] == displayExOh[condition[2]] &&
          displayExOh[condition[0]] != '') {
        _showWinnerDialog(displayExOh[condition[0]]);
        return displayExOh[condition[0]];
      }
    }

    if (filledBox == 9) {
      _showDrawDialog();
    }

    return null;
  }

  void _showDrawDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade700,
            title: Text('Game Over', style: gameFontBoldBright),
            content: Text('Draw', style: gameFontBright),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _clearBoard();
                  Navigator.of(context).pop();
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
            title: Text('Game Over', style: gameFontBoldBright),
            content: Text('Winner is: $winner', style: gameFontBright),
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
      filledBox = 0;
      gameFinished = false;
    });
    _updateGameInFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'TIC TAC TOE',
              style: GoogleFonts.pressStart2p(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
                bottom: 60,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Room : ${widget.roomId}",
                            style: gameFontBoldDark),
                        // Text("ScoreBoard", style: gameFontBoldBright),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Your', style: gameFontDark),
                                  const SizedBox(height: 10),
                                  Text((exScore ~/ 2).toString(),
                                      style: gameFontDark),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Opponent', style: gameFontDark),
                                  const SizedBox(height: 10),
                                  Text(ohScore.toString(), style: gameFontDark),
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
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: GridView.builder(
                        itemCount: 9,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => _makeMove(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2.0),
                              ),
                              child: Center(
                                child: Text(
                                  displayExOh[index],
                                  style: gameFontBoldBright,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: _clearBoard,
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Refresh",
                                  style: gameFontDark,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            exTurn ? 'Your Turn' : 'Opponent Turn',
                            style: gameFontBoldDark,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
