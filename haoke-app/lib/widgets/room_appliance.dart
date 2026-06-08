import 'package:flutter/material.dart';
import 'package:haoke_app/config/app_config.dart';
import 'package:haoke_app/widgets/common_check_button.dart';

class RoomApplianceItem {
  final String title;
  final IconData icon;
  bool isChecked; // 注意：这里改成可变字段，方便更新

  RoomApplianceItem(this.title, this.icon, this.isChecked);
}

final List<RoomApplianceItem> _dataList = [
  RoomApplianceItem(
    '衣柜',
    const IconData(0xe66d, fontFamily: AppConfig.commonIcon),
    false,
  ),
  RoomApplianceItem(
    '洗衣机',
    const IconData(0xe661, fontFamily: AppConfig.commonIcon),
    false,
  ),
  RoomApplianceItem(
    '空调',
    const IconData(0xe6c2, fontFamily: AppConfig.commonIcon),
    false,
  ),
  RoomApplianceItem(
    '天然气',
    const IconData(0x101dc, fontFamily: AppConfig.commonIcon),
    false,
  ),
  RoomApplianceItem(
    '冰箱',
    const IconData(0xe66e, fontFamily: AppConfig.commonIcon),
    false,
  ),
  RoomApplianceItem(
    '暖气',
    const IconData(0xe67d, fontFamily: AppConfig.commonIcon),
    false,
  ),
  RoomApplianceItem(
    '电视机',
    const IconData(0xe90a, fontFamily: AppConfig.commonIcon),
    false,
  ),
  RoomApplianceItem(
    '热水器',
    const IconData(0xe601, fontFamily: AppConfig.commonIcon),
    false,
  ),
  RoomApplianceItem(
    '宽带',
    const IconData(0xe614, fontFamily: AppConfig.commonIcon),
    false,
  ),
  RoomApplianceItem(
    '沙发',
    const IconData(0xe625, fontFamily: AppConfig.commonIcon),
    false,
  ),
];

class RoomAppliance extends StatefulWidget {
  final ValueChanged<List<RoomApplianceItem>> onChange;
  const RoomAppliance({super.key, required this.onChange});

  @override
  State<RoomAppliance> createState() => _RoomApplianceState();
}

class _RoomApplianceState extends State<RoomAppliance> {
  late List<RoomApplianceItem> list;

  @override
  void initState() {
    super.initState();
    // 深拷贝一份，避免修改 _dataList 影响常量
    list = _dataList
        .map((e) => RoomApplianceItem(e.title, e.icon, e.isChecked))
        .toList();
  }

  void _toggleItem(RoomApplianceItem item) {
    setState(() {
      item.isChecked = !item.isChecked;
    });
    widget.onChange(list);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 30,
      children: list
          .map(
            (item) => GestureDetector(
              onTap: () => _toggleItem(item),
              behavior: HitTestBehavior.translucent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 5,
                child: Column(
                  children: [
                    Icon(item.icon, size: 40),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(item.title),
                    ),
                    CommonCheckButton(item.isChecked),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class RoomApplianceList extends StatelessWidget {
  final List<String> list;
  const RoomApplianceList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    var showList = _dataList
        .where((item) => list.contains(item.title))
        .toList();
    if (showList.isEmpty) {
      return Container(
        padding: const EdgeInsets.only(left: 10),
        child: const Text('暂无房屋配置信息！'),
      );
    }
    return Wrap(
      runSpacing: 30,
      children: showList
          .map(
            (item) => SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              child: Column(
                children: [
                  Icon(item.icon, size: 40),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(item.title),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
