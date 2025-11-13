import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/tab_index/index_recommand_date.dart';
import 'package:haoke_rent/pages/home/tab_index/index_recommond_item_widget.dart';

class IndexRecommond extends StatelessWidget {
  const IndexRecommond({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Color(0x08000000)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('房屋推荐', style: TextStyle(color: Colors.black)),
              Text('更多', style: TextStyle(color: Colors.black54)),
            ],
          ),
          Padding(padding: EdgeInsets.all(5.0)),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: indexRecommandItemList
                .map((item) => IndexRecommondItemWidget(data: item))
                .toList(),
            // List.generate(
            //   4,
            //   (index) => Container(
            //     height: 100,
            //     color: Colors.white,
            //     child: Center(child: Text('推荐房屋$index')),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
