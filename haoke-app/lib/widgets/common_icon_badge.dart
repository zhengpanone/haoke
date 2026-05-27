import 'package:flutter/material.dart';

class CommonIconBadge extends StatelessWidget {
  final IconData? icon;
  final Widget? child;
  final double boxSize;
  final double iconSize;
  final double radius;
  final Color iconColor;
  final Color backgroundColor;

  const CommonIconBadge({
    super.key,
    this.icon,
    this.child,
    this.boxSize = 36,
    this.iconSize = 18,
    this.radius = 10,
    this.iconColor = const Color(0xFF0F8F7A),
    this.backgroundColor = const Color(0xFFEAF5F2),
  }) : assert(icon != null || child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: child ?? Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}
