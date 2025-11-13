import 'package:flutter/material.dart';

class CommonFloatActionButton extends StatelessWidget {
  final String title;
  final void Function() onTap;

  const CommonFloatActionButton(this.title, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (null != onTap) onTap();
      },
      child: Container(
        height: 40,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            '发布房源',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
