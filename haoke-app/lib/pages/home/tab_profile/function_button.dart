import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/tab_profile/function_button_data.dart';
import 'package:haoke_rent/pages/home/tab_profile/function_button_widget.dart';

class FunctionButton extends StatelessWidget {
  const FunctionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3, // 每行 3 个
      shrinkWrap: true, // 不占满整个屏幕
      physics: const NeverScrollableScrollPhysics(), // 禁用滚动，让外层能滚动
      childAspectRatio: 1.5,
      children: list.map((item) => FunctionButtonWidget(item)).toList(),
    );
  }
}
