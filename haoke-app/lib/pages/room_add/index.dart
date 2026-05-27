import 'dart:io';

import 'package:flutter/material.dart';
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

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publish Listing')),
      body: ListView(
        children: [
          const CommonTitle('Property Details'),
          CommonFormItem(
            label: 'Community',
            contextBuilder: (context) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Choose community', style: TextStyle(fontSize: 15)),
                      Icon(Icons.keyboard_arrow_right_rounded),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('');
                },
              );
            },
            controller: TextEditingController(),
          ),
          CommonFormItem(
            label: 'Rent',
            hintText: 'Input rent amount',
            suffixText: '/month',
            controller: TextEditingController(),
          ),
          CommonFormItem(
            label: 'Area',
            hintText: 'Input area size',
            suffixText: 'sqm',
            controller: TextEditingController(),
          ),
          CommonRadioFormItem(
            label: 'Rent Type',
            options: const ['Shared', 'Whole'],
            value: rendType,
            onChange: (index) {
              setState(() {
                rendType = index;
              });
            },
          ),
          CommonSelectFormItem(
            label: 'Room Type',
            value: roomType,
            options: const ['1 Bedroom', '2 Bedroom', '3 Bedroom', '4 Bedroom'],
            onChange: (val) {
              setState(() {
                roomType = val;
              });
            },
          ),
          CommonSelectFormItem(
            label: 'Floor',
            value: floor,
            options: const ['High', 'Middle', 'Low'],
            onChange: (val) {
              setState(() {
                floor = val;
              });
            },
          ),
          CommonSelectFormItem(
            label: 'Orientation',
            value: oriented,
            options: const ['East', 'South', 'West', 'North'],
            onChange: (val) {
              setState(() {
                oriented = val;
              });
            },
          ),
          CommonRadioFormItem(
            label: 'Decoration',
            options: const ['Fine', 'Simple'],
            value: decorationType,
            onChange: (index) {
              setState(() {
                decorationType = index;
              });
            },
          ),
          const CommonTitle('Property Photos'),
          CommonImagePicker(onChange: (List<File> files) {}),
          const CommonTitle('Listing Title'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5EEEB)),
            ),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'For example: 2B1B near metro, great light',
              ),
            ),
          ),
          const CommonTitle('Facilities'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5EEEB)),
            ),
            child: RoomAppliance(onChange: (data) => {}),
          ),
          const CommonTitle('Description'),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 100),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5EEEB)),
            ),
            child: TextField(
              controller: descController,
              maxLength: 2000,
              maxLines: 9,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Describe highlights, transport and nearby services',
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CommonFloatActionButton('Publish', () {}),
    );
  }
}
