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
    title:
        'Cozy Apartment in City Center Cozy Apartment in City CenterCozy Apartment in City Center',
    subTitle: '2 guests · 1 bedroom · 1 bed · 1 bath',
    imageUrl:
        'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
    tags: ['Wifi', 'Kitchen', 'Air conditioning'],
    price: 7500,
  ),
  RoomListItemData(
    id: '2',
    title: 'Modern Loft with Great View',
    subTitle: '4 guests · 2 bedrooms · 2 beds · 1 bath',
    imageUrl:
        'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
    tags: ['Wifi', 'Washer', 'Free parking'],
    price: 1200,
  ),
  RoomListItemData(
    id: '3',
    title: 'Charming Studio Near Park',
    subTitle: '2 guests · Studio · 1 bed · 1 bath',
    imageUrl:
        'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
    tags: ['Wifi', 'Heating', 'Self check-in'],
    price: 6000,
  ),
];
