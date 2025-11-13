// 结果数据类型
import 'package:haoke_rent/models/filter_model.dart';

class FilterBarResult {
  final Map<String, FilterItem> filters;
  FilterBarResult(this.filters);
}

// 通用类型
class GeneralType {
  final String name;
  final String id;

  GeneralType(this.name, this.id);
}

List<GeneralType> areaList = [
  GeneralType('区域1', '11'),
  GeneralType('区域2', '22'),
];

List<GeneralType> priceList = [
  GeneralType('价格1', '11'),
  GeneralType('价格2', '22'),
];

List<GeneralType> rentTypeList = [
  GeneralType('出租类型1', '11'),
  GeneralType('出租类型2', '22'),
];

List<GeneralType> roomTypeList = [
  GeneralType('房屋类型1', '11'),
  GeneralType('房屋类型2', '12'),
  GeneralType('房屋类型3', '13'),
  GeneralType('房屋类型4', '14'),
  GeneralType('房屋类型5', '15'),
];

List<GeneralType> orientedList = [
  GeneralType('方向1', '21'),
  GeneralType('方向2', '22'),
];

List<GeneralType> floorList = [
  GeneralType('楼层1', '31'),
  GeneralType('楼层2', '32'),
];
