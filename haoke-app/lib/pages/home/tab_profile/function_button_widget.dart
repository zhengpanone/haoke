import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/tab_profile/function_button_data.dart';
import 'package:haoke_rent/widgets/common_image.dart';

class FunctionButtonWidget extends StatelessWidget {
  final FunctionButtonItem data;

  const FunctionButtonWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (null != data.onTapHandle) {
          data.onTapHandle!(context);
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            CommonImage(imageUrl: data.imageUri, width: 45),
            Text(data.title),
          ],
        ),
      ),
    );
  }
}
