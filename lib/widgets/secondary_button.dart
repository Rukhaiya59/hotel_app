import 'package:flutter/material.dart';
import '../util/app_color.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final double borderRadius;
  final double height;
  final double fontSize;
  final List<Color>? colors;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderRadius = 14,
    this.height = 50,
    this.fontSize = 18,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = colors ??
        [
          LightColor.primaryStart,
          LightColor.primaryEnd,
        ];

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}