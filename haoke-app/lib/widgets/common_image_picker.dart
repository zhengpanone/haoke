import 'dart:io';
import 'package:flutter/material.dart';
import 'package:haoke_rent/utils/image_picker_util.dart';

var imageWidth = 750;
var imageHeight = 424;
var imageWidthHeightRatio = imageWidth / imageHeight;

class CommonImagePicker extends StatefulWidget {
  final ValueChanged<List<File>> onChange;
  const CommonImagePicker({super.key, required this.onChange});

  @override
  State<CommonImagePicker> createState() => _CommonImagePickerState();
}

class _CommonImagePickerState extends State<CommonImagePicker> {
  List<File> fileList = [];
  @override
  Widget build(BuildContext context) {
    var width = (MediaQuery.of(context).size.width - 10 * 4) / 3;
    var height = width / imageWidthHeightRatio;
    Widget addButton = GestureDetector(
      onTap: () async {
        List<File> images = await ImagePickerUtil.pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            fileList.addAll(images);
          });
          // 通知外部
          // 回调给父组件
          widget.onChange(fileList);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: Colors.grey,
        width: width,
        height: height,
        child: Center(
          child: Text(
            '+',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
    // 图片包装
    Widget wrapper(File imagFile) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Image.file(imagFile, width: width, height: height, fit: BoxFit.cover),
          Positioned(
            right: -20,
            top: -20,
            child: IconButton(
              onPressed: () {
                // 删除逻辑
                setState(() {
                  fileList.remove(imagFile);
                });
                widget.onChange(fileList); // 通知父组件
              },
              icon: Icon(Icons.delete_forever, color: Colors.red),
            ),
          ),
        ],
      );
    }

    List<Widget> list = fileList.map((item) => wrapper(item)).toList()
      ..add(addButton);

    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(children: list, spacing: 10, runSpacing: 10),
    );
  }
}
