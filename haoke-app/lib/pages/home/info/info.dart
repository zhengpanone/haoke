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
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
            child: const Text(
              'Latest News',
              style: TextStyle(
                color: Color(0xFF1F2B2A),
                fontWeight: FontWeight.w700,
                fontSize: 18,
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
