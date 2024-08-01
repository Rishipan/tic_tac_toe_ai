// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ttt_ai/screens/home_screen/room/create_room.dart';

import 'package:ttt_ai/screens/home_screen/room/join_room.dart';

import '../../utils/button.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ROOM',
                    style: GoogleFonts.robotoMono(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        letterSpacing: 3,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      // Add functionality for joining a room here if needed
                      if (await _isConnectedToInternet()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JoinScreen(),
                          ),
                        );
                      } else {
                        _showNoInternetSnackbar(context);
                      }
                    },
                    child: const MyButton(
                      name: 'Join Room',
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (await _isConnectedToInternet()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateScreen(),
                          ),
                        );
                      } else {
                        _showNoInternetSnackbar(context);
                      }
                    },
                    child: const MyButton(
                      name: 'Create Room',
                      color: Colors.white,
                    ),
                  ),
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

  Future<bool> _isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _showNoInternetSnackbar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('No internet connection. Please try again.'),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
