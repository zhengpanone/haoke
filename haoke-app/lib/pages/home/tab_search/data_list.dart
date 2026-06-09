import 'package:haoke_app/models/room/room_model.dart';

const String fallbackRoomImage =
    'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg';

class RoomListItemData {
  final String id;
  final String title;
  final String subTitle;
  final String imageUrl;
  final List<String> tags;
  final double price;

  const RoomListItemData({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.imageUrl,
    required this.tags,
    required this.price,
  });

  factory RoomListItemData.fromRoom(RoomModel room) {
    return RoomListItemData(
      id: room.id,
      title: room.title.isEmpty ? '未命名房源' : room.title,
      subTitle: room.subTitle?.isNotEmpty == true
          ? room.subTitle!
          : _buildSubTitle(room),
      imageUrl: room.imageUrl?.isNotEmpty == true
          ? room.imageUrl!
          : fallbackRoomImage,
      tags: room.tags.isNotEmpty ? room.tags : _buildTags(room),
      price: room.rent ?? 0,
    );
  }
}

List<String> _buildTags(RoomModel room) {
  final tags = <String>[];
  if (room.decoration?.isNotEmpty == true) {
    tags.add(room.decoration!);
  }
  if (room.rentMethod?.isNotEmpty == true) {
    tags.add(room.rentMethod == '2' ? '合租' : '整租');
  }
  return tags;
}

String _buildSubTitle(RoomModel room) {
  final parts = <String>[];
  if (room.houseType?.isNotEmpty == true) {
    parts.add(room.houseType!);
  }
  if (room.coveredArea != null && room.coveredArea! > 0) {
    parts.add('${room.coveredArea!.toStringAsFixed(0)}㎡');
  }
  if (room.communityName?.isNotEmpty == true) {
    parts.add(room.communityName!);
  }
  return parts.join(' · ');
}

const List<RoomListItemData> dataList = [
  RoomListItemData(
    id: '1',
    title: '市中心精装一居室，近地铁生活便利',
    subTitle: '1室 · 52㎡ · 高楼层',
    imageUrl: fallbackRoomImage,
    tags: ['宽带', '厨房', '空调'],
    price: 7500,
  ),
  RoomListItemData(
    id: '2',
    title: '景观复式两居，采光好视野开阔',
    subTitle: '2室 · 89㎡ · 南向',
    imageUrl: fallbackRoomImage,
    tags: ['宽带', '洗衣机', '免费停车'],
    price: 12000,
  ),
  RoomListItemData(
    id: '3',
    title: '公园旁舒适开间，安静宜居',
    subTitle: '开间 · 38㎡ · 随时看房',
    imageUrl: fallbackRoomImage,
    tags: ['宽带', '暖气', '自助入住'],
    price: 6000,
  ),
];
