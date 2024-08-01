import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../assets/fonts/fonts.dart';
import '../../../../firestore_services.dart';

class JoinMultiScreen extends StatefulWidget {
  final String roomId;
  final String playerId;

  const JoinMultiScreen(
      {super.key, required this.roomId, required this.playerId});

  @override
  _JoinMultiScreenState createState() => _JoinMultiScreenState();
}

class _JoinMultiScreenState extends State<JoinMultiScreen> {
  List<String> displayExOh = List.filled(9, '');
  bool exTurn = true;
  bool gameFinished = false;
  int exScore = 0;
  int ohScore = 0;
  int filledBox = 0;

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

  void _makeMove(int index) {
    if (displayExOh[index] == '' &&
        !gameFinished &&
        (exTurn && widget.playerId == 'X' ||
            !exTurn && widget.playerId == 'O')) {
      setState(() {
        displayExOh[index] = exTurn ? 'X' : 'O';
        filledBox++;
        exTurn = !exTurn;
        _updateGameInFirestore();
      });
      _checkWinner();
    }
  }

  void _updateGameInFirestore() {
    Provider.of<FirestoreService>(context, listen: false)
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
                  // _clearBoard();
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
        backgroundColor: Colors.grey.shade900,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  // top: 40,
                  // bottom: 60,
                  ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Expanded(
                    child: Column(
                      children: [
                        Text("Room : ${widget.roomId}",
                            style: gameFontBoldBright),
                        Text("ScoreBoard", style: gameFontBoldDark),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Your', style: gameFontBright),
                                const SizedBox(height: 10),
                                Text((ohScore ~/ 2).toString(),
                                    style: gameFontBright),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Opponent', style: gameFontBright),
                                const SizedBox(height: 10),
                                Text((exScore).toString(),
                                    style: gameFontBright),
                              ],
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
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => _makeMove(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade700),
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
                      child: Text(
                        exTurn ? 'Opponent Turn X' : 'Your Turn O',
                        style: gameFontBoldBright,
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
