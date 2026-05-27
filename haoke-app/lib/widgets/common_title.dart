import 'package:flutter/material.dart';

class CommonTitle extends StatelessWidget {
  final String title;

  const CommonTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1F2B2A),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
