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
