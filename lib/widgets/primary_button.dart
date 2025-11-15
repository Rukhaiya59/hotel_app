import 'package:flutter/material.dart';

enum ActionType { add, refresh, delete, edit, custom }

class PrimaryButton extends StatelessWidget {
  final ActionType type;
  final Function() onPressed;
  final IconData? customIcon;
  final double size;
  final Color color;

  const PrimaryButton({
    super.key,
    required this.type,
    required this.onPressed,
    this.customIcon,
    this.size = 60,
    required this.color,
  });

  IconData _getIconData() {
    switch (type) {
      case ActionType.add:
        return Icons.add;
      case ActionType.refresh:
        return Icons.refresh;
      case ActionType.delete:
        return Icons.delete;
      case ActionType.edit:
        return Icons.edit;
      case ActionType.custom:
      default:
        return customIcon ?? Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              color, // Use color from parameter
              color.withValues(alpha:0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          elevation: 0,
          fillColor: Colors.transparent,
          onPressed: onPressed,
          child: Icon(_getIconData(), color: Colors.white),
        ),
      ),
    );
  }
}
