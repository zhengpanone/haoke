import 'package:flutter/material.dart';

class CommonToast {
  static void showToast(String message, {BuildContext? context}) {
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }
    debugPrint('Toast: $message');
  }
}
