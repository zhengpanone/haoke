import 'package:flutter/material.dart';

class CommonTag extends StatelessWidget {
  final String tagText;
  final Color backgroundColor;
  final Color color;

  const CommonTag({
    super.key,
    required this.tagText,
    this.backgroundColor = Colors.grey,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      padding: EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(tagText, style: TextStyle(fontSize: 10, color: color)),
    );
  }
}
