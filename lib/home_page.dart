import 'package:flutter/material.dart';
import 'package:ttt_ai/screens/home_screen/room/create_room.dart';
import 'package:ttt_ai/screens/home_screen/room/join_room.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateScreen()),
                );
              },
              child: const Text('Create Room'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinScreen()),
                );
              },
              child: const Text('Join Room'),
            ),
          ],
        ),
      ),
    );
  }
}
