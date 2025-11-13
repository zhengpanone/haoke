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
    title: 'Flutter 3.0 Released with Exciting New Features',
    imageUrl:
        'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
    source: 'Tech News',
    time: '2 hours ago',
    navigateUri: 'login',
  ),
  InfoItem(
    title: 'Dart Language Gains Popularity Among Developers',
    imageUrl:
        'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
    source: 'Dev Weekly',
    time: '5 hours ago',
    navigateUri: 'login',
  ),
  InfoItem(
    title: 'Building Responsive UIs with Flutter',
    imageUrl:
        'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
    source: 'UI Trends',
    time: '1 day ago',
    navigateUri: 'login',
  ),
];
