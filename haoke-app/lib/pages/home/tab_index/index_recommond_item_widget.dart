import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/tab_index/index_recommand_date.dart';
import 'package:haoke_rent/widgets/common_image.dart';

var textStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

class IndexRecommondItemWidget extends StatelessWidget {
  final IndexRecommandItem data;

  const IndexRecommondItemWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {Navigator.of(context).pushNamed(data.navigateUrl)},
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        width: (MediaQuery.of(context).size.width - 10 * 3) / 2,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(data.title, style: textStyle),
                Text(data.subTitle, style: textStyle),
              ],
            ),
            CommonImage(imageUrl: data.imageUrl, width: 60, height: 80),
          ],
        ),
      ),
    );
  }
}
