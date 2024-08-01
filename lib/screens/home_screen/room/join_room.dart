// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ttt_ai/utils/button.dart';
import '../../../firestore_services.dart';
import '../../../game.dart';

class JoinScreen extends StatelessWidget {
  final TextEditingController _roomIdController = TextEditingController();

  JoinScreen({super.key});

  void _joinRoom(BuildContext context) async {
    String roomId = _roomIdController.text;

    if (roomId.isNotEmpty) {
      try {
        await Provider.of<FirestoreService>(context, listen: false)
            .joinRoom(roomId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GamePage(roomId: roomId, playerId: 'O'),
          ),
        );
      } catch (e) {
        _showErrorDialog(context, e.toString());
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
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
              // backgroundColor: Colors.pink,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _roomIdController,
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Room ID',
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _joinRoom(context);
              },
              child: const MyButton(
                name: 'Join',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
