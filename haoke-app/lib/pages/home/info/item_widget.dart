import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/info/data.dart';
import 'package:haoke_rent/widgets/common_image.dart';

const textStyle = TextStyle(color: Color(0xFF7A8885), fontSize: 12);

class ItemWidget extends StatelessWidget {
  final InfoItem data;

  const ItemWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CommonImage(
            imageUrl: data.imageUrl,
            width: 116,
            height: 82,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 82,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2B2A),
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.source, style: textStyle),
                      Text(data.time, style: textStyle),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
