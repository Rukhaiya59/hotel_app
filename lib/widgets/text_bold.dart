import 'package:flutter/material.dart';

class TextBold extends StatelessWidget {
  final String message;

  const TextBold({super.key, required this.message, required TextStyle style});

  @override
  Widget build(BuildContext context) {
    return Text(message, style: TextStyle(fontWeight: FontWeight.bold));
  }
}
