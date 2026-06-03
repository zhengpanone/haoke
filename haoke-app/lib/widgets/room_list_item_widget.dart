import 'package:flutter/material.dart';
import 'package:haoke_app/pages/home/tab_search/data_list.dart';
import 'package:haoke_app/widgets/common_image.dart';
import 'package:haoke_app/widgets/common_tag.dart';

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
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            CommonImage(
              imageUrl: data.imageUrl,
              width: 126,
              height: 98,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF1F2B2A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(color: Color(0xFF6E7E7A), fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    children: data.tags
                        .map((item) => CommonTag(tagText: item))
                        .toList(),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      text: '${data.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF0F8F7A),
                      ),
                      children: const [
                        TextSpan(
                          text: ' 元/月',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0F8F7A),
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
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
