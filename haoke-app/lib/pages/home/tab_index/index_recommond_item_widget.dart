import 'package:flutter/material.dart';
import 'package:haoke_app/pages/home/tab_index/index_recommand_date.dart';
import 'package:haoke_app/widgets/common_image.dart';

class IndexRecommondItemWidget extends StatelessWidget {
  final IndexRecommandItem data;

  const IndexRecommondItemWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final width =
        (MediaQuery.of(context).size.width - 12 * 2 - 12 * 2 - 10) / 2;

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(data.navigateUrl),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE4EEEB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2B2A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7C78),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            CommonImage(
              imageUrl: data.imageUrl,
              width: 54,
              height: 54,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
    );
  }
}
