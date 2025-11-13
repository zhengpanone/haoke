import 'package:flutter/material.dart';
import 'package:haoke_rent/config/app_config.dart';
import 'package:haoke_rent/widgets/common_check_button.dart';

class RoomApplianceItem {
  final String title;
  final int iconPoint;
  bool isChecked; // 注意：这里改成可变字段，方便更新

  RoomApplianceItem(this.title, this.iconPoint, this.isChecked);
}

final List<RoomApplianceItem> _dataList = [
  RoomApplianceItem('衣柜', 0xe66d, false),
  RoomApplianceItem('洗衣机', 0xe661, false),
  RoomApplianceItem('空调', 0xe6c2, false),
  RoomApplianceItem('天然气', 0x101dc, false),
  RoomApplianceItem('冰箱', 0xe66e, false),
  RoomApplianceItem('暖气', 0xe67d, false),
  RoomApplianceItem('电视机', 0xe90a, false),
  RoomApplianceItem('热水器', 0xe601, false),
  RoomApplianceItem('宽带', 0xe614, false),
  RoomApplianceItem('沙发', 0xe625, false),
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
        .map((e) => RoomApplianceItem(e.title, e.iconPoint, e.isChecked))
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
              child: Container(
                width: MediaQuery.of(context).size.width / 5,
                child: Column(
                  children: [
                    Icon(
                      IconData(
                        item.iconPoint,
                        fontFamily: AppConfig.commonIcon,
                      ),
                      size: 40,
                    ),
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
        padding: EdgeInsets.only(left: 10),
        child: Text('暂无房屋配置信息！'),
      );
    }
    return Wrap(
      runSpacing: 30,
      children: showList
          .map(
            (item) => Container(
              width: MediaQuery.of(context).size.width / 5,
              child: Column(
                children: [
                  Icon(
                    IconData(item.iconPoint, fontFamily: AppConfig.commonIcon),
                    size: 40,
                  ),
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
