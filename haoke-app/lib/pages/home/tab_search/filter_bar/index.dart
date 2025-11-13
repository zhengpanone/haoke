import 'package:flutter/material.dart';
import 'package:haoke_rent/models/filter_model.dart';
import 'package:haoke_rent/pages/home/tab_search/filter_bar/data.dart';
import 'package:haoke_rent/pages/home/tab_search/filter_bar/item.dart';
import 'package:haoke_rent/utils/common_picker/index.dart';
import 'package:provider/provider.dart';

class FilterBar extends StatelessWidget {
  final ValueChanged<FilterBarResult> onChange;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const FilterBar({
    super.key,
    required this.onChange,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final filterModel = context.watch<FilterModel>();

    /// 通知 FilterBarResult 回调
    void _notifyChange(FilterModel model) {
      onChange(FilterBarResult(model.filters));
    }

    /// 显示 Picker
    void _showPicker(
      BuildContext context,
      String key,
      List<GeneralType> options,
    ) async {
      final filterModel = context.read<FilterModel>();

      final index = await CommonPicker.showPicker(
        context: context,
        options: options.map((item) => item.name).toList(),
        value: 0,
      );
      if (index != null) {
        filterModel.setFilter(key, [options[index].id]);
        _notifyChange(filterModel);
      }
    }

    /// 打开 Drawer
    void _onFilterChange(context) {
      final filterModel = scaffoldKey.currentContext!.read<FilterModel>();
      scaffoldKey.currentState?.openEndDrawer();
    }

    return Container(
      height: 41,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Builder(
            builder: (context) => FilterBarItem(
              title: '区域',
              isActive: filterModel.filters['area']?.isActive ?? false,
              onTap: (context) => _showPicker(context, 'area', areaList),
            ),
          ),
          Builder(
            builder: (context) => FilterBarItem(
              title: '出租方式',
              isActive: filterModel.filters['rentalType']?.isActive ?? false,
              onTap: (context) =>
                  _showPicker(context, 'rentalType', rentTypeList),
            ),
          ),
          Builder(
            builder: (context) => FilterBarItem(
              title: '租金',
              isActive: filterModel.filters['rental']?.isActive ?? false,
              onTap: (context) => _showPicker(context, 'rental', priceList),
            ),
          ),
          Builder(
            builder: (context) => FilterBarItem(
              title: '筛选',
              isActive:
                  filterModel.filters['roomType']!.isActive ||
                  filterModel.filters['floor']!.isActive ||
                  filterModel.filters['oriented']!.isActive,
              onTap: _onFilterChange,
            ),
          ),
        ],
      ),
    );
  }
}
