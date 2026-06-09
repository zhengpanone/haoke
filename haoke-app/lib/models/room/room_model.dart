class RoomModel {
  final String id;
  final String title;
  final String? estateId;
  final String? communityName;

  // 租金
  final double? rent;

  // 租赁方式
  final String? rentMethod;
  final String? houseType;
  // 建筑面积
  final double? coveredArea;

  // 朝向
  final String? orientation;

  // 装修
  final String? decoration;
  final String? status;
  final String? imageUrl;
  final List<String> tags;
  final String? subTitle;

  const RoomModel({
    required this.id,
    required this.title,
    this.estateId,
    this.communityName,
    this.rent,
    this.rentMethod,
    this.houseType,
    this.coveredArea,
    this.orientation,
    this.decoration,
    this.status,
    this.imageUrl,
    this.tags = const [],
    this.subTitle,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: '${json['id'] ?? ''}',
      title: json['title']?.toString() ?? '',
      estateId: json['estateId']?.toString(),
      communityName: json['communityName']?.toString(),
      rent: (json['rent'] as num?)?.toDouble(),
      rentMethod: json['rentMethod']?.toString(),
      houseType: json['houseType']?.toString(),
      coveredArea: (json['coveredArea'] as num?)?.toDouble(),
      orientation: json['orientation']?.toString(),
      decoration: json['decoration']?.toString(),
      status: json['status']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      subTitle: json['subTitle']?.toString(),
    );
  }

  /// 转换为列表项展示数据
  Map<String, dynamic> toListItemJson() {
    return {
      'id': id,
      'title': title,
      'subTitle': subTitle ?? _buildSubTitle(),
      'imageUrl': imageUrl,
      'tags': tags,
      'price': rent ?? 0,
    };
  }

  String _buildSubTitle() {
    final parts = <String>[];
    if (houseType != null && houseType!.isNotEmpty) {
      parts.add(houseType!);
    }
    if (coveredArea != null && coveredArea! > 0) {
      parts.add('${coveredArea!.toStringAsFixed(0)}㎡');
    }
    return parts.isNotEmpty ? parts.join(' · ') : '';
  }
}
