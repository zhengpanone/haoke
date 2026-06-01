class CityModel {
  final String id;
  final String name;
  final String code;
  final String parentId;
  final int level;
  final int sort;
  final bool hot;
  final List<CityModel> children;

  const CityModel({
    this.id = '',
    required this.name,
    this.code = '',
    this.parentId = '',
    this.level = 0,
    this.sort = 0,
    this.hot = false,
    this.children = const [],
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'];
    return CityModel(
      id: '${json['id'] ?? ''}',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      parentId: json['parentId']?.toString() ?? '',
      level: _parseInt(json['level']),
      sort: _parseInt(json['sort']),
      hot: json['hot'] == true,
      children: rawChildren is List
          ? rawChildren
              .map((item) => CityModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  bool get hasChildren => children.isNotEmpty;

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
