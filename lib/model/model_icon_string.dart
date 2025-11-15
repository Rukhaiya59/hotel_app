import 'package:flutter/material.dart';

class ModelIconString {
  final IconData icon;
  final String title;

  ModelIconString({required this.icon, required this.title});

  String toStringText() {
    return "title: $title";
  }
}
