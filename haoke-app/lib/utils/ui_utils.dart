import 'package:flutter/material.dart';

/// 显示 SnackBar 提示
void showSnackBarTip(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
