import 'package:flutter/material.dart';

class CommonTag extends StatelessWidget {
  final String tagText;
  final Color backgroundColor;
  final Color color;

  const CommonTag({
    super.key,
    required this.tagText,
    this.backgroundColor = const Color(0xFFE8F6F2),
    this.color = const Color(0xFF0F8F7A),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6, bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        tagText,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
