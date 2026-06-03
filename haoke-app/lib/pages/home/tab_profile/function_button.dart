import 'package:flutter/material.dart';
import 'package:haoke_app/pages/home/tab_profile/function_button_data.dart';
import 'package:haoke_app/pages/home/tab_profile/function_button_widget.dart';

class FunctionButton extends StatelessWidget {
  const FunctionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.5,
        children: list.map((item) => FunctionButtonWidget(item)).toList(),
      ),
    );
  }
}
