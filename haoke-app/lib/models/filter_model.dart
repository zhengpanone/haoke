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

  bool get isActive => ids.isNotEmpty;
}

class FilterModel extends ChangeNotifier {
  Map<String, FilterItem> filters = {
    'area': FilterItem(itemCode: 'area', itemName: '区域'),
    'rentalType': FilterItem(itemCode: 'rentalType', itemName: '方式'),
    'rental': FilterItem(itemCode: 'rental', itemName: '租金'),
    'roomType': FilterItem(itemCode: 'roomType', itemName: '户型', isMulti: true),
    'floor': FilterItem(itemCode: 'floor', itemName: '楼层', isMulti: true),
    'oriented': FilterItem(itemCode: 'oriented', itemName: '朝向', isMulti: true),
  };

  FilterItem getFilter(String key) => filters[key]!;

  void setFilter(String key, List<String> ids) {
    final item = filters[key];
    if (item == null) return;
    final normalized = ids.where((id) => id.isNotEmpty).toList();
    if (!item.isMulti && normalized.isNotEmpty) {
      item.ids = [normalized.first];
    } else {
      item.ids = normalized;
    }
    notifyListeners();
  }

  void clear(String key) {
    filters[key]?.ids = [];
    notifyListeners();
  }

  void resetAll() {
    for (final key in filters.keys) {
      filters[key]?.ids = [];
    }
    notifyListeners();
  }
}
