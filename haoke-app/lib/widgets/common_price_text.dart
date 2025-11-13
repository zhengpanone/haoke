import 'package:flutter/material.dart';

class CommonPriceText extends StatelessWidget {
  final String price; // 价格内容
  final String unit; // 单位（例如：元/月）
  final double priceSize; // 价格字体
  final double unitSize; // 单位字体大小
  final Color color;
  final double unitOffsetY; // 单位文字的Y轴微调，解决视觉对齐问题
  final FontWeight priceWeight;

  const CommonPriceText({
    super.key,
    required this.price,
    this.unit = '元/月',
    this.priceSize = 18,
    this.unitSize = 14,
    this.color = Colors.red,
    this.unitOffsetY = -4,
    this.priceWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          price,
          style: TextStyle(
            color: color,
            fontSize: priceSize,
            fontWeight: priceWeight,
          ),
        ),

        Transform.translate(
          offset: Offset(3, unitOffsetY),
          child: Text(
            unit,
            style: TextStyle(color: color, fontSize: unitSize),
          ),
        ),
      ],
    );
    ;
  }
}
