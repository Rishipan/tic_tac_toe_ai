// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ttt_ai/screens/home_screen/room/create/finite_multi.dart';

import '../../../assets/fonts/fonts.dart';
import '../../../firestore_services.dart';
import '../../../utils/button.dart';
import 'create/infinite_multi.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  void _createRoomInfinite(BuildContext context) async {
    String roomId = await Provider.of<FirestoreService>(context, listen: false)
        .createRoom();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            InfiniteMultiScreen(roomId: roomId, playerId: 'X'),
      ),
    );
  }

  void _createRoomFinite(BuildContext context) async {
    String roomId = await Provider.of<FirestoreService>(context, listen: false)
        .createRoom();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiniteMultiScreen(roomId: roomId, playerId: 'X'),
      ),
    );
  }

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
                    'Choose Type',
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
                      _createRoomFinite(context);
                    },
                    child: const MyButton(
                      name: 'Finite',
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // _createRoomInfinite(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Center(
                            child: Text(
                          'Infinite\n(under work)',
                          style: gameFontBoldDark,
                          textAlign: TextAlign.center,
                        )),
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
