import 'package:flutter/material.dart';

class CommonFormItem extends StatelessWidget {
  final String label;
  final Widget? Function(BuildContext context)? contextBuilder;

  final Widget? suffix;
  final String? suffixText;

  final String? hintText;
  final ValueChanged? onChanged;
  final TextEditingController? controller;

  const CommonFormItem({
    super.key,
    required this.label,
    this.contextBuilder,
    this.suffix,
    this.suffixText,
    this.hintText,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            child: Text(label, style: TextStyle(fontSize: 16)),
          ),

          Expanded(
            child: contextBuilder != null
                ? contextBuilder!(context) ?? const SizedBox.shrink()
                : TextField(
                    controller: controller,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none, // 移除下划线
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
          ),
          if (suffix != null) ...[suffix!],
          if (suffixText != null) ...[
            Text(suffixText!, style: TextStyle(fontSize: 16)),
          ],
        ],
      ),
    );
  }
}
