import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final String status;
  final VoidCallback? btn;

  const MyDialog({
    Key? key,
    required this.title,
    required this.status,
    required this.btn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(status),
      actions: [
        ElevatedButton(
          onPressed: () {
            btn;
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          child:
              const Text('Play Again', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
