import 'package:flutter/material.dart';
import 'package:haoke_rent/models/filter_model.dart';
import 'package:haoke_rent/pages/home/tab_search/filter_bar/data.dart';
import 'package:haoke_rent/widgets/common_title.dart';
import 'package:provider/provider.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final filterModel = context.watch<FilterModel>();

    // 构建每个筛选模块
    Widget _buildSection(String title, List<GeneralType> list, String key) {
      final model = context.read<FilterModel>();
      final selectedIds = model.getFilter(key).ids;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTitle(title),
          FilterDrawerItem(
            list: list,
            selectedIds: selectedIds,
            onChange: (ids) {
              model.setFilter(key, ids);
            },
          ),
        ],
      );
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // ===== 顶部标题 + 已选数量 + 重置按钮 =====
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '筛选条件',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      filterModel.resetAll();
                    },
                    child: Text('重置', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
            // ===== 主体条件列表 =====
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ), // 设置左右和上下间距
                children: [
                  _buildSection('户型', roomTypeList, 'roomType'),
                  _buildSection('楼层', floorList, 'floor'),
                  _buildSection('朝向', orientedList, 'oriented'),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('取消'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('确定'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterDrawerItem extends StatelessWidget {
  final List<GeneralType> list;
  final List<String> selectedIds;
  final ValueChanged<List<String>> onChange;

  const FilterDrawerItem({
    super.key,
    required this.list,
    required this.selectedIds,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: list.map((item) {
        var isActive = selectedIds.contains(item.id);
        return GestureDetector(
          onTap: () {
            final newSelected = List<String>.from(selectedIds);
            if (isActive) {
              newSelected.remove(item.id);
            } else {
              newSelected.add(item.id);
            }
            onChange(newSelected);
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            width: 90,
            height: 36,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.white,
              border: Border.all(width: 1, color: Colors.green),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                item.name,
                style: TextStyle(color: isActive ? Colors.white : Colors.green),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
