import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firestore_services.dart';

class GamePage extends StatefulWidget {
  final String roomId;
  final String playerId;

  const GamePage({super.key, required this.roomId, required this.playerId});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<List<String>> _board = [
    ['', '', ''],
    ['', '', ''],
    ['', '', '']
  ];
  String _currentPlayer = 'X';
  String? _winner;

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
        _winner = _checkWinner(); // Check for winner after making the move
        if (_winner == null) {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
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
        return _board[i][0];
      }
      if (_board[0][i] == _board[1][i] &&
          _board[1][i] == _board[2][i] &&
          _board[0][i] != '') {
        return _board[0][i];
      }
    }
    if (_board[0][0] == _board[1][1] &&
        _board[1][1] == _board[2][2] &&
        _board[0][0] != '') {
      return _board[0][0];
    }
    if (_board[0][2] == _board[1][1] &&
        _board[1][1] == _board[2][0] &&
        _board[0][2] != '') {
      return _board[0][2];
    }
    return null;
  }

  void _resetGame() {
    setState(() {
      _board = [
        ['', '', ''],
        ['', '', ''],
        ['', '', '']
      ];
      _currentPlayer = 'X';
      _winner = null;
    });
    _updateGameInFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
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
            const SizedBox(
              height: 20,
            ),
            if (_winner != null)
              Text(
                'Winner: $_winner',
                style: const TextStyle(fontSize: 32),
              )
            else if (_currentPlayer == widget.playerId)
              const Text(
                "Your Turn",
                style: TextStyle(fontSize: 24),
              )
            else
              const Text(
                "Opponent Turn",
                style: TextStyle(fontSize: 24),
              ),
          ],
        ),
      ),
    );
  }
}
