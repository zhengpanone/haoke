import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
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
      appBar: AppBar(title: Text(context.tr('publish_listing'))),
      body: ListView(
        children: [
          CommonTitle(context.tr('property_details')),
          CommonFormItem(
            label: context.tr('community'),
            contextBuilder: (context) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.tr('choose_community'),
                          style: const TextStyle(fontSize: 15)),
                      const Icon(Icons.keyboard_arrow_right_rounded),
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
            label: context.tr('rent'),
            hintText: context.tr('input_rent_amount'),
            suffixText: context.tr('per_month'),
            controller: TextEditingController(),
          ),
          CommonFormItem(
            label: context.tr('area'),
            hintText: context.tr('input_area_size'),
            suffixText: context.tr('sqm'),
            controller: TextEditingController(),
          ),
          CommonRadioFormItem(
            label: context.tr('rent_type'),
            options: [context.tr('rent_shared'), context.tr('rent_whole')],
            value: rendType,
            onChange: (index) {
              setState(() {
                rendType = index;
              });
            },
          ),
          CommonSelectFormItem(
            label: context.tr('room_type'),
            value: roomType,
            options: [
              context.tr('one_bedroom'),
              context.tr('two_bedroom'),
              context.tr('three_bedroom'),
              context.tr('four_bedroom'),
            ],
            onChange: (val) {
              setState(() {
                roomType = val;
              });
            },
          ),
          CommonSelectFormItem(
            label: context.tr('floor'),
            value: floor,
            options: [
              context.tr('floor_high'),
              context.tr('floor_middle'),
              context.tr('floor_low'),
            ],
            onChange: (val) {
              setState(() {
                floor = val;
              });
            },
          ),
          CommonSelectFormItem(
            label: context.tr('orientation'),
            value: oriented,
            options: [
              context.tr('east'),
              context.tr('south'),
              context.tr('west'),
              context.tr('north'),
            ],
            onChange: (val) {
              setState(() {
                oriented = val;
              });
            },
          ),
          CommonRadioFormItem(
            label: context.tr('decoration'),
            options: [
              context.tr('decoration_fine'),
              context.tr('decoration_simple'),
            ],
            value: decorationType,
            onChange: (index) {
              setState(() {
                decorationType = index;
              });
            },
          ),
          CommonTitle(context.tr('property_photos')),
          CommonImagePicker(onChange: (List<File> files) {}),
          CommonTitle(context.tr('listing_title')),
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
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: context.tr('listing_title_hint'),
              ),
            ),
          ),
          CommonTitle(context.tr('facilities')),
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
          CommonTitle(context.tr('description')),
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
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: context.tr('description_hint'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          CommonFloatActionButton(context.tr('publish'), () {}),
    );
  }
}
