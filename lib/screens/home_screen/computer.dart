import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttt_ai/screens/home_screen/computer/beatable.dart';
import 'package:ttt_ai/screens/home_screen/computer/unbeatable.dart';

import '../../utils/button.dart';

class ComputerScreen extends StatelessWidget {
  const ComputerScreen({super.key});

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
                    'Play With Computer',
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BeatableAI()));
                    },
                    child: const MyButton(
                      name: 'Normal',
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UnbeatableAI()));
                    },
                    child: const MyButton(
                      name: 'Unbeatable',
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
                      '@COBACREATION',
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
