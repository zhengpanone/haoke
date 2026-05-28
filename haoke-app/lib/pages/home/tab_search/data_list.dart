class RoomListItemData {
  final String id;
  final String title;
  final String subTitle;
  final String imageUrl;
  final List<String> tags;
  final int price;

  const RoomListItemData({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.imageUrl,
    required this.tags,
    required this.price,
  });
}

const List<RoomListItemData> dataList = [
  RoomListItemData(
    id: '1',
    title: '市中心精装一居室，近地铁生活便利',
    subTitle: '2人可住 · 1室 · 1床 · 1卫',
    imageUrl:
        'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
    tags: ['宽带', '厨房', '空调'],
    price: 7500,
  ),
  RoomListItemData(
    id: '2',
    title: '景观复式两居，采光好视野开阔',
    subTitle: '4人可住 · 2室 · 2床 · 1卫',
    imageUrl:
        'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
    tags: ['宽带', '洗衣机', '免费停车'],
    price: 1200,
  ),
  RoomListItemData(
    id: '3',
    title: '公园旁舒适开间，安静宜居',
    subTitle: '2人可住 · 开间 · 1床 · 1卫',
    imageUrl:
        'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
    tags: ['宽带', '暖气', '自助入住'],
    price: 6000,
  ),
];
