import 'package:haoke_app/models/room/room_model.dart';
import 'package:haoke_app/pages/home/tab_search/data_list.dart';
import 'package:haoke_app/routes.dart';

class IndexRecommandItem {
  final String title;
  final String subTitle;
  final String imageUrl;
  final String navigateUrl;

  IndexRecommandItem({
    required this.title,
    required this.subTitle,
    required this.imageUrl,
    required this.navigateUrl,
  });

  factory IndexRecommandItem.fromRoom(RoomModel room) {
    return IndexRecommandItem(
      title: room.title.isEmpty ? '优选房源' : room.title,
      subTitle: room.subTitle?.isNotEmpty == true
          ? room.subTitle!
          : (room.houseType?.isNotEmpty == true ? room.houseType! : '品质好房'),
      imageUrl: room.imageUrl?.isNotEmpty == true
          ? room.imageUrl!
          : fallbackRoomImage,
      navigateUrl: Routes.roomDetail.replaceFirst(':roomId', room.id),
    );
  }
}

List<IndexRecommandItem> indexRecommandItemList = [
  IndexRecommandItem(
    title: '家住回龙观',
    subTitle: '归属的感觉',
    imageUrl: fallbackRoomImage,
    navigateUrl: Routes.search,
  ),
  IndexRecommandItem(
    title: '宜居四五环',
    subTitle: '大都市生活',
    imageUrl: fallbackRoomImage,
    navigateUrl: Routes.search,
  ),
  IndexRecommandItem(
    title: '喧嚣三里屯',
    subTitle: '繁华的背后',
    imageUrl: fallbackRoomImage,
    navigateUrl: Routes.search,
  ),
  IndexRecommandItem(
    title: '比邻十号线',
    subTitle: '地铁心连心',
    imageUrl: fallbackRoomImage,
    navigateUrl: Routes.search,
  ),
];
