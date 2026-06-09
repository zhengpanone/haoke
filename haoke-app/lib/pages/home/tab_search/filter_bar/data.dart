import 'package:haoke_app/models/filter_model.dart';

class FilterBarResult {
  final Map<String, FilterItem> filters;

  FilterBarResult(this.filters);
}

class GeneralType {
  final String name;
  final String id;

  GeneralType(this.name, this.id);
}

List<GeneralType> areaList = [
  GeneralType('全部区域', ''),
  GeneralType('朝阳', '朝阳'),
  GeneralType('海淀', '海淀'),
  GeneralType('丰台', '丰台'),
  GeneralType('通州', '通州'),
];

List<GeneralType> priceList = [
  GeneralType('不限租金', ''),
  GeneralType('3000元以下', '0-3000'),
  GeneralType('3000-5000元', '3000-5000'),
  GeneralType('5000-8000元', '5000-8000'),
  GeneralType('8000元以上', '8000-'),
];

List<GeneralType> rentTypeList = [
  GeneralType('不限方式', ''),
  GeneralType('整租', '1'),
  GeneralType('合租', '2'),
];

List<GeneralType> roomTypeList = [
  GeneralType('一室', '1室'),
  GeneralType('两室', '2室'),
  GeneralType('三室', '3室'),
  GeneralType('四室及以上', '4室'),
];

List<GeneralType> orientedList = [
  GeneralType('东', '1'),
  GeneralType('南', '2'),
  GeneralType('西', '3'),
  GeneralType('北', '4'),
];

List<GeneralType> floorList = [
  GeneralType('低楼层', '低'),
  GeneralType('中楼层', '中'),
  GeneralType('高楼层', '高'),
];
