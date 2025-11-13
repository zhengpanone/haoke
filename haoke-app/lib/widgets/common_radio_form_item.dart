import 'package:flutter/material.dart';
import 'package:haoke_rent/widgets/common_form_item.dart';

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
        return Container(
          child: Row(
            children: List.generate(
              options.length,
              (index) => Expanded(
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: value,
                      onChanged: (value) => onChange(value!),
                    ),
                    Text(options[index]),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
