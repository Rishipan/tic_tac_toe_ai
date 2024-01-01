import 'package:flutter/material.dart';
import '../assets/fonts/fonts.dart';

class MyButton extends StatefulWidget {
  final String name;
  final Color color;
  const MyButton({
    required this.name,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.color,
        ),
        child: Center(
            child: Text(
          widget.name,
          style: gameFontBoldDark,
        )),
      ),
    );
  }
}
