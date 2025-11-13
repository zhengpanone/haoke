import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/tab_index/index_navigator_item.dart';
import 'package:haoke_rent/widgets/common_image.dart';

class IndexNavigator extends StatelessWidget {
  const IndexNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: indexNavigatorItemList
            .map(
              (item) => InkWell(
                onTap: () => {item.onTap(context)},
                child: Column(
                  children: [
                    // Image.asset(item.imageUrl, width: 47.5),
                    CommonImage(
                      imageUrl: item.imageUrl,
                      width: 47.5,
                      borderRadius: BorderRadius.circular(8),
                      fit: BoxFit.cover,
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
