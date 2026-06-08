import 'package:flutter/material.dart';
import 'package:haoke_app/widgets/common_form_item.dart';

class CommonRadioFormItem extends StatelessWidget {
  final String label;
  final List<String> options;
  final int value;
  final ValueChanged<int> onChange;

  const CommonRadioFormItem({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return CommonFormItem(
      label: label,
      contextBuilder: (BuildContext context) {
        return Row(
          children: List.generate(
            options.length,
            (index) => Expanded(
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<int>(
                    value: index,
                    // ignore: deprecated_member_use
                    groupValue: value,
                    // ignore: deprecated_member_use
                    onChanged: (value) => onChange(value!),
                  ),
                  Text(options[index]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
