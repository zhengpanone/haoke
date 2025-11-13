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
}

List<IndexRecommandItem> indexRecommandItemList = [
  IndexRecommandItem(
    title: "家住回龙观",
    subTitle: "归属的感觉",
    imageUrl:
        "https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg",
    navigateUrl: "login",
  ),
  IndexRecommandItem(
    title: "宜居四五环",
    subTitle: "大都市生活",
    imageUrl:
        "https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg",
    navigateUrl: "login",
  ),
  IndexRecommandItem(
    title: "喧嚣三里屯",
    subTitle: "繁华的背后",
    imageUrl:
        "https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg",
    navigateUrl: "login",
  ),
  IndexRecommandItem(
    title: "比邻十号线",
    subTitle: "地铁心连心",
    imageUrl:
        "https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg",
    navigateUrl: "login",
  ),
];
