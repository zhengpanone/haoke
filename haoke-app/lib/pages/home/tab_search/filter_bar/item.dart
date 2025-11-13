import 'package:flutter/material.dart';

class FilterBarItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final Function(BuildContext) onTap;

  const FilterBarItem({
    super.key,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var color = isActive ? Colors.green : Colors.black87;
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap(context);
      },
      child: Container(
        child: Row(
          children: [
            Text(title, style: TextStyle(color: color, fontSize: 18)),
            Icon(Icons.arrow_drop_down, color: color),
          ],
        ),
      ),
    );
  }
}
