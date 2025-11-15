import 'package:flutter/material.dart';

class TextHeader extends StatelessWidget {
  final String message;
  const TextHeader({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(message, style: TextStyle(fontSize: 14),);
  }
}
