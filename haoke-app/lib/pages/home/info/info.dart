import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/info/data.dart';
import 'package:haoke_rent/pages/home/info/item_widget.dart';

class Info extends StatelessWidget {
  final bool showTitle;
  final List<InfoItem> dataList;

  const Info({super.key, this.showTitle = false, this.dataList = infoItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showTitle)
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            child: Text(
              '最新资讯',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Column(
          children: dataList.map((item) => ItemWidget(data: item)).toList(),
        ),
      ],
    );
  }
}
