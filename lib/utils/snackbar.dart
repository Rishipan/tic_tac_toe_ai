// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MySnackbar extends StatefulWidget {
  String message;
  MySnackbar({required this.message, super.key});

  @override
  State<MySnackbar> createState() => _MySnackbarState();
}

class _MySnackbarState extends State<MySnackbar> {
  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(widget.message),
    );
  }
}
