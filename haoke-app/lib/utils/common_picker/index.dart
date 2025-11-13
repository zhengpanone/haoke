import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonPicker {
  static Future<int?> showPicker({
    required BuildContext context,
    required List<String> options,
    required int value,
    double height = 300,
    bool looping = false,
    bool useMagnifier = true,
    double magnification = 1.2,
    double itemExtent = 32,
  }) {
    return showCupertinoModalPopup<int>(
      context: context,
      builder: (BuildContext context) {
        var buttonColor = TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        );
        var controller = FixedExtentScrollController(initialItem: value);
        return Container(
          color: Colors.grey,
          height: height,
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('取消', style: buttonColor),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(controller.selectedItem);
                      },
                      child: Text('确定', style: buttonColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: controller,
                  useMagnifier: useMagnifier, // 放大镜效果
                  magnification: magnification, // 放大倍数
                  looping: looping, // 无限循环
                  itemExtent: itemExtent, // 高度
                  children: options.map((item) => Text(item)).toList(),
                  onSelectedItemChanged: (val) {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
