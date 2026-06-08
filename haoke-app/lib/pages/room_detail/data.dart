import 'package:haoke_app/config/env.dart';

class RoomDetailData {
  String id;
  String title;
  String community;
  String subTitle;
  int size; // 面积
  String floor;
  int price;
  String roomType;
  List<String> houseImages;
  List<String> tags;
  List<String> oriented;
  List<String> applicances;

  RoomDetailData({
    required this.id,
    required this.title,
    required this.community,
    required this.subTitle,
    required this.size,
    required this.floor,
    required this.price,
    required this.roomType,
    required this.houseImages,
    required this.tags,
    required this.oriented,
    required this.applicances,
  });

  factory RoomDetailData.fromJson(Map<String, dynamic> json) {
    final resource =
        (json['houseResources'] ?? json['houseResource'] ?? json)
            as Map<String, dynamic>;
    final estate = json['estate'];

    final images = (json['images'] as List<dynamic>? ?? [])
        .map((item) {
          if (item is Map<String, dynamic>) {
            return _normalizeImageUrl(item['url']?.toString() ?? '');
          }
          return _normalizeImageUrl(item.toString());
        })
        .where((url) => url.isNotEmpty)
        .toList();

    final facilities = (json['facilities'] as List<dynamic>? ?? [])
        .map((item) {
          if (item is Map<String, dynamic>) {
            return item['name']?.toString() ?? '';
          }
          return item.toString();
        })
        .where((name) => name.isNotEmpty)
        .toList();

    return RoomDetailData(
      id: resource['id']?.toString() ?? '',
      title: resource['title']?.toString() ?? '',
      community: _communityName(estate),
      subTitle:
          resource['description']?.toString() ??
          resource['houseDesc']?.toString() ??
          '',
      size: _numValue(resource['coveredArea']).round(),
      floor: resource['floor']?.toString() ?? '',
      price: _numValue(resource['rent']).round(),
      roomType: resource['houseType']?.toString() ?? '',
      houseImages: images,
      tags: _buildTags(resource),
      oriented: _orientationList(resource['orientation']),
      applicances: facilities,
    );
  }
}

String _communityName(dynamic estate) {
  if (estate is Map<String, dynamic>) {
    return estate['name']?.toString() ?? '';
  }
  return '';
}

double _numValue(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

List<String> _buildTags(Map<String, dynamic> resource) {
  final tags = <String>[];
  final decoration = resource['decoration']?.toString();
  final rentMethod = resource['rentMethod']?.toString();

  if (decoration != null && decoration.isNotEmpty) {
    tags.add(_decorationName(decoration));
  }
  if (rentMethod != null && rentMethod.isNotEmpty) {
    tags.add(rentMethod == '2' ? '合租' : '整租');
  }
  return tags.where((tag) => tag.isNotEmpty).toList();
}

String _decorationName(String value) {
  switch (value) {
    case '1':
      return '精装';
    case '2':
      return '简装';
    case '3':
      return '毛坯';
    default:
      return value;
  }
}

List<String> _orientationList(dynamic value) {
  final text = value?.toString() ?? '';
  if (text.isEmpty) return [];
  switch (text) {
    case '1':
      return ['东'];
    case '2':
      return ['南'];
    case '3':
      return ['西'];
    case '4':
      return ['北'];
    default:
      return text
          .split(RegExp(r'[,/、]'))
          .where((item) => item.isNotEmpty)
          .toList();
  }
}

String _normalizeImageUrl(String value) {
  if (value.isEmpty || value.startsWith('http')) return value;
  if (value.startsWith('/')) return '${Env.baseUrl}$value';
  return '${Env.baseUrl}/files/$value';
}

var defaultData = RoomDetailData(
  id: '1',
  title: '精装两居室',
  community: '海淀小区',
  subTitle:
      '交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美交通便利，环境优美',
  size: 80,
  floor: '5/18',
  price: 6500,
  roomType: '两室一厅',
  houseImages: [
    'https://images.pexels.com/photos/33419928/pexels-photo-33419928.jpeg',
    'https://images.pexels.com/photos/33419928/pexels-photo-33419928.jpeg',
    'https://images.pexels.com/photos/33419928/pexels-photo-33419928.jpeg',
  ],
  tags: ['近地铁', '随时看房', '精装修'],
  oriented: ['南', '东'],
  applicances: ['空调', '冰箱', '洗衣机', '电视'],
);
