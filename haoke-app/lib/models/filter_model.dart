import 'package:flutter/material.dart';

class FilterItem {
  String itemName;
  String itemCode;
  List<String> ids;
  bool isMulti;

  FilterItem({
    required this.itemName,
    required this.itemCode,
    this.isMulti = false,
    List<String>? ids,
  }) : ids = ids ?? [];

  /// 是否激活：只要有选中项，就认为激活
  bool get isActive => ids.isNotEmpty;
}

// 1. Provider使用 定义筛选状态模型
class FilterModel extends ChangeNotifier {
  // 用 Map 管理不同类型的筛选项
  Map<String, FilterItem> filters = {
    'area': FilterItem(itemCode: 'area', itemName: '区域'),
    'rentalType': FilterItem(itemCode: 'rentalType', itemName: '方式'),
    'rental': FilterItem(itemCode: 'rental', itemName: '租金'),

    'roomType': FilterItem(itemCode: 'roomType', itemName: '户型', isMulti: true),
    'floor': FilterItem(itemCode: 'floor', itemName: '楼层', isMulti: true),
    'oriented': FilterItem(itemCode: 'oriented', itemName: '朝向', isMulti: true),
  };

  // 获取某个筛选项
  FilterItem getFilter(String key) => filters[key]!;

  void setFilter(String key, List<String> ids) {
    final item = filters[key];
    if (item == null) return;
    if (!item.isMulti && ids.isNotEmpty) {
      item.ids = [ids.first];
    } else {
      item.ids = ids;
    }
    notifyListeners();
  }

  // 清空某个筛选项
  void clear(String key) {
    filters[key]?.ids = [];
    notifyListeners();
  }

  // 重置所有筛选
  void resetAll() {
    for (var key in filters.keys) {
      filters[key]?.ids = [];
    }
    notifyListeners();
  }
}
