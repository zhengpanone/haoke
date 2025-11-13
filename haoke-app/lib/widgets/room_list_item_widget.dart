import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/tab_search/data_list.dart';
import 'package:haoke_rent/widgets/common_image.dart';
import 'package:haoke_rent/widgets/common_tag.dart';

class RoomListItemWidget extends StatelessWidget {
  final RoomListItemData data;

  const RoomListItemWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/roomDetail/${data.id}');
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
          children: [
            CommonImage(imageUrl: data.imageUrl, width: 132.5, height: 100),
            Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    data.subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Wrap(
                    children: data.tags
                        .map((item) => CommonTag(tagText: item))
                        .toList(),
                  ),
                  Text(
                    '${data.price} 元/月',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
