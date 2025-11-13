import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haoke_rent/widgets/common_float_action_button.dart';
import 'package:haoke_rent/widgets/common_form_item.dart';
import 'package:haoke_rent/widgets/common_image_picker.dart';
import 'package:haoke_rent/widgets/common_radio_form_item.dart';
import 'package:haoke_rent/widgets/common_select_form_item.dart';
import 'package:haoke_rent/widgets/common_title.dart';
import 'package:haoke_rent/widgets/room_appliance.dart';

class RoomAdd extends StatefulWidget {
  const RoomAdd({super.key});

  @override
  State<RoomAdd> createState() => _RoomAddState();
}

class _RoomAddState extends State<RoomAdd> {
  int rendType = 0;
  int decorationType = 0;
  int roomType = 0;
  int floor = 0;
  int oriented = 0;

  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('发布房源')),
      body: ListView(
        children: [
          CommonTitle('房源信息'),
          CommonFormItem(
            label: '小区',
            contextBuilder: (context) {
              return Container(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('请选择小区', style: TextStyle(fontSize: 16)),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('');
                  },
                ),
              );
            },
            controller: TextEditingController(),
          ),
          CommonFormItem(
            label: '租金',
            hintText: '请输入租金',
            suffixText: '元/月',
            controller: TextEditingController(),
          ),
          CommonFormItem(
            label: '大小',
            hintText: '请输入房屋大小',
            suffixText: 'm²',
            controller: TextEditingController(),
          ),

          CommonRadioFormItem(
            label: '租赁方式',
            options: ['合租', '整租'],
            value: rendType,
            onChange: (index) {
              setState(() {
                rendType = index;
              });
            },
          ),

          CommonSelectFormItem(
            label: '户型',
            value: roomType,
            options: ['一室', '二室', '三室', '四室'],
            onChange: (val) {
              setState(() {
                roomType = val;
              });
            },
          ),
          CommonSelectFormItem(
            label: '楼层',
            value: floor,
            options: ['高楼层', '中楼层', '低楼层'],
            onChange: (val) {
              setState(() {
                floor = val;
              });
            },
          ),
          CommonSelectFormItem(
            label: '朝向',
            value: 0,
            options: ['东', '南', '西', '北'],
            onChange: (val) {
              setState(() {
                oriented = val;
              });
            },
          ),
          CommonRadioFormItem(
            label: '装修',
            options: ['精装', '简装'],
            value: decorationType,
            onChange: (index) {
              setState(() {
                decorationType = index;
              });
            },
          ),

          CommonTitle('房屋照片'),
          CommonImagePicker(onChange: (List<File> files) {}),
          CommonTitle('房屋标题'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入标题（例如：整租、小区名 2室 2000元）',
              ),
            ),
          ),
          CommonTitle('房屋配置'),
          RoomAppliance(onChange: (data) => {}),
          CommonTitle('房屋描述'),
          Container(
            margin: EdgeInsets.only(bottom: 100),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: descController,
              maxLength: 2000,
              maxLines: 9,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入房屋描述',
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CommonFloatActionButton('发布', () {}),
    );
  }
}
