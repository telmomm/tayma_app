import 'package:flutter/material.dart';

class SnackBarMessage {
  final BuildContext context;
  final String text;

  SnackBarMessage({required this.context, required this.text});

  void show() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}