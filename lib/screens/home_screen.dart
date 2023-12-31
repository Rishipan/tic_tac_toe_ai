import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttt_ai/screens/home_screen/computer.dart';
import 'package:ttt_ai/screens/home_screen/friend.dart';
import 'package:ttt_ai/utils/button.dart';

import '../assests/fonts/fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'TIC TAC TOE',
                style: GoogleFonts.pressStart2p(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  // backgroundColor: Colors.pink,
                  decoration: TextDecoration.underline,
                ),
              ),
              AvatarGlow(
                child: ClipOval(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      'lib/assests/images/ttt.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    "Play with :-",
                    style: GoogleFonts.pressStart2p(
                        textStyle: const TextStyle(
                      color: Colors.white,
                      letterSpacing: 3,
                      fontSize: 15,
                    )),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AiScreen()));
                    },
                    child: const MyButton(
                      name: 'AI',
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FriendScreen()));
                    },
                    child: const MyButton(
                      name: 'Friend',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    '@CREATEDBYCOBA',
                    style: gameFontBright,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
