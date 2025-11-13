import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/info/data.dart';
import 'package:haoke_rent/widgets/common_image.dart';

var textStyle = TextStyle(color: Colors.black54);

class ItemWidget extends StatelessWidget {
  final InfoItem data;

  const ItemWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: [
          CommonImage(imageUrl: data.imageUrl, width: 120, height: 90),
          Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
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
        ],
      ),
    );
  }
}
