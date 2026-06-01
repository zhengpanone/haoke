import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
import 'package:haoke_rent/models/community/community_model.dart';
import 'package:haoke_rent/routes.dart';
import 'package:haoke_rent/utils/common_toast.dart';
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
  CommunityModel? community;
  List<File> roomImages = [];
  List<String> selectedAppliances = [];

  final rentController = TextEditingController();
  final areaController = TextEditingController();
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    rentController.dispose();
    areaController.dispose();
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> _chooseCommunity() async {
    final result =
        await Navigator.of(context).pushNamed(Routes.communitySelect);
    if (!mounted || result is! CommunityModel || result.name.trim().isEmpty) {
      return;
    }
    setState(() {
      community = result;
    });
  }

  void _publishRoom() {
    if (community == null) {
      CommonToast.showToast(context.tr('please_choose_community'),
          context: context);
      return;
    }
    if (rentController.text.trim().isEmpty) {
      CommonToast.showToast(context.tr('please_input_rent'), context: context);
      return;
    }
    if (areaController.text.trim().isEmpty) {
      CommonToast.showToast(context.tr('please_input_area'), context: context);
      return;
    }
    if (titleController.text.trim().isEmpty) {
      CommonToast.showToast(context.tr('please_input_listing_title'),
          context: context);
      return;
    }
    CommonToast.showToast(context.tr('publish_success'), context: context);
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
                onTap: _chooseCommunity,
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          community == null
                              ? context.tr('choose_community')
                              : community!.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            color: community == null
                                ? const Color(0xFF9AA8A5)
                                : const Color(0xFF1F2B2A),
                          ),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_right_rounded),
                    ],
                  ),
                ),
              );
            },
            controller: TextEditingController(),
          ),
          CommonFormItem(
            label: context.tr('rent'),
            hintText: context.tr('input_rent_amount'),
            suffixText: context.tr('per_month'),
            controller: rentController,
          ),
          CommonFormItem(
            label: context.tr('area'),
            hintText: context.tr('input_area_size'),
            suffixText: context.tr('sqm'),
            controller: areaController,
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
          CommonImagePicker(onChange: (List<File> files) {
            roomImages = files;
          }),
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
            child: RoomAppliance(onChange: (data) {
              selectedAppliances = data
                  .where((item) => item.isChecked)
                  .map((item) => item.title)
                  .toList();
            }),
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
          CommonFloatActionButton(context.tr('publish'), _publishRoom),
    );
  }
}
