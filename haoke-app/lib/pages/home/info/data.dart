class InfoItem {
  final String title;
  final String imageUrl;
  final String source;
  final String time;
  final String navigateUri;

  const InfoItem({
    required this.title,
    required this.imageUrl,
    required this.source,
    required this.time,
    required this.navigateUri,
  });
}

const List<InfoItem> infoItems = [
  InfoItem(
    title: '北京多区发布租房服务新规，提升房源透明度',
    imageUrl:
        'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
    source: '租房资讯',
    time: '2小时前',
    navigateUri: 'login',
  ),
  InfoItem(
    title: '毕业季租房指南：看房前需要确认哪些细节',
    imageUrl:
        'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
    source: '好客指南',
    time: '5小时前',
    navigateUri: 'login',
  ),
  InfoItem(
    title: '通勤半径怎么选？热门商圈周边房源推荐',
    imageUrl:
        'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
    source: '城市生活',
    time: '1天前',
    navigateUri: 'login',
  ),
];
