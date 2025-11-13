import 'package:flutter/material.dart';
import 'package:haoke_rent/widgets/common_image.dart';

class Advertisement extends StatelessWidget {
  const Advertisement({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
      child: CommonImage(
        imageUrl:
            "https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg",
        height: 50,
      ),
    );
  }
}
