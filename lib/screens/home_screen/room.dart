import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Stack(
        children: [
          Center(
            child: Text(
              "Not Available",
              style: GoogleFonts.robotoMono(
                textStyle: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 3,
                  fontSize: 15,
                ),
              ),
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
    );
  }
}
