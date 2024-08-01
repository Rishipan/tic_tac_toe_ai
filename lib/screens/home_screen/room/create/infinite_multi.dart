import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../assets/fonts/fonts.dart';
import '../../../../firestore_services.dart';

class InfiniteMultiScreen extends StatefulWidget {
  final String roomId;
  final String playerId;

  const InfiniteMultiScreen(
      {super.key, required this.roomId, required this.playerId});

  @override
  _InfiniteMultiScreenState createState() => _InfiniteMultiScreenState();
}

class _InfiniteMultiScreenState extends State<InfiniteMultiScreen> {
  List<List<String>> _board = List.generate(3, (_) => List.filled(3, ''));
  final List<int> _moveHistory = [];
  String _currentPlayer = 'X';
  String? _winner;
  int _exScore = 0;
  int _ohScore = 0;
  int _filledBoxes = 0;

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
          _board = [
            List<String>.from(data['board']['row0']),
            List<String>.from(data['board']['row1']),
            List<String>.from(data['board']['row2']),
          ];
          _currentPlayer = data['currentPlayer'];
          _winner = _checkWinner();
        });
      }
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] == '' &&
        _winner == null &&
        _currentPlayer == widget.playerId) {
      setState(() {
        _board[row][col] = _currentPlayer;
        _moveHistory.add(row * 3 + col); // Save move history
        _filledBoxes++;
        _checkWinner();
        if (_filledBoxes > 6) {
          int oldestMove = _moveHistory.removeAt(0);
          int r = oldestMove ~/ 3;
          int c = oldestMove % 3;
          _board[r][c] = '';
          _filledBoxes--;
        }
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
      });
      _updateGameInFirestore();
    }
  }

  void _updateGameInFirestore() {
    Provider.of<FirestoreService>(context, listen: false)
        .updateRoom(widget.roomId, {
      'board': {
        'row0': _board[0],
        'row1': _board[1],
        'row2': _board[2],
      },
      'currentPlayer': _currentPlayer,
    });
  }

  String? _checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == _board[i][1] &&
          _board[i][1] == _board[i][2] &&
          _board[i][0] != '') {
        _showWinnerDialog(_board[i][0]);
        return _board[i][0];
      }
      if (_board[0][i] == _board[1][i] &&
          _board[1][i] == _board[2][i] &&
          _board[0][i] != '') {
        _showWinnerDialog(_board[0][i]);
        return _board[0][i];
      }
    }
    if (_board[0][0] == _board[1][1] &&
        _board[1][1] == _board[2][2] &&
        _board[0][0] != '') {
      _showWinnerDialog(_board[0][0]);
      return _board[0][0];
    }
    if (_board[0][2] == _board[1][1] &&
        _board[1][1] == _board[2][0] &&
        _board[0][2] != '') {
      _showWinnerDialog(_board[0][2]);
      return _board[0][2];
    }
    if (_filledBoxes == 9) {
      _showDrawDialog();
    }
    return null;
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade700,
          title: Text('Game Over', style: gameFontBoldBright),
          content: Text('Winner is : $winner', style: gameFontBright),
          actions: [
            ElevatedButton(
              onPressed: () {
                _resetGame();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Text('Play Again', style: gameFontBright),
            ),
          ],
        );
      },
    );
    if (winner == 'O') {
      _ohScore++;
    } else if (winner == 'X') {
      _exScore++;
    }
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
                _resetGame();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Text('Play Again', style: gameFontBright),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.filled(3, ''));
      _currentPlayer = 'X';
      _winner = null;
      _moveHistory.clear();
      _filledBoxes = 0;
    });
    _updateGameInFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room: ${widget.roomId}, $_currentPlayer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Player X: $_exScore  Player O: $_ohScore',
                style: gameFontBoldBright),
            if (_winner != null)
              Text(
                'Winner: $_winner',
                style: const TextStyle(fontSize: 32),
              ),
            ...List.generate(_board.length, (row) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(_board[row].length, (col) {
                    return GestureDetector(
                      onTap: () => _makeMove(row, col),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            _board[row][col],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
