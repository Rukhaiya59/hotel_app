import 'package:flutter/material.dart';

class TextSmall extends StatelessWidget {
  final String message;

  const TextSmall({super.key, required this.message, required TextStyle style});

  @override
  Widget build(BuildContext context) {
    return Text(message, style: TextStyle(fontSize: 12));
  }
}
