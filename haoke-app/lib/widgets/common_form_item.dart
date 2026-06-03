import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonFormItem extends StatelessWidget {
  final String label;
  final Widget? Function(BuildContext context)? contextBuilder;

  final Widget? suffix;
  final String? suffixText;

  final String? hintText;
  final ValueChanged? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CommonFormItem({
    super.key,
    required this.label,
    this.contextBuilder,
    this.suffix,
    this.suffixText,
    this.hintText,
    this.onChanged,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5EEEB)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF4D5F5C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: contextBuilder != null
                ? contextBuilder!(context) ?? const SizedBox.shrink()
                : TextField(
                    controller: controller,
                    onChanged: onChanged,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
          ),
          if (suffix != null) ...[suffix!],
          if (suffixText != null) ...[
            Text(
              suffixText!,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6F7E7B)),
            ),
          ],
        ],
      ),
    );
  }
}
