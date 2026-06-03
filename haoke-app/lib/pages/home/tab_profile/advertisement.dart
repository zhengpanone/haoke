import 'package:flutter/material.dart';
import 'package:haoke_app/widgets/common_image.dart';

class Advertisement extends StatelessWidget {
  const Advertisement({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: const CommonImage(
        imageUrl:
            'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
        height: 70,
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    );
  }
}
