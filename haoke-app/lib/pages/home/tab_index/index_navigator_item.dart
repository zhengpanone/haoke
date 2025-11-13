import 'package:flutter/material.dart';

class IndexNavigatorItem {
  final String title;
  // final IconData imageUrl;
  final String imageUrl;
  final Function(BuildContext context) onTap;

  IndexNavigatorItem({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });
}

List<IndexNavigatorItem> indexNavigatorItemList = [
  IndexNavigatorItem(
    title: '整租',
    // imageUrl: Icons.home,
    imageUrl: "statics/images/home.png",
    onTap: (context) {
      Navigator.of(context).pushNamed('login');
    },
  ),
  IndexNavigatorItem(
    title: '合租',
    // imageUrl: Icons.apartment,
    imageUrl: "statics/images/connect.png",
    onTap: (context) {
      Navigator.of(context).pushNamed('login');
    },
  ),
  IndexNavigatorItem(
    title: '地图找房',
    // imageUrl: Icons.map,
    imageUrl: "statics/images/map.png",
    onTap: (context) {
      Navigator.of(context).pushNamed('login');
    },
  ),
  IndexNavigatorItem(
    title: '去出租',
    // imageUrl: Icons.publish,
    imageUrl: "statics/images/sitemap_locksmith_tools.png",
    onTap: (context) {
      Navigator.of(context).pushNamed('login');
    },
  ),
];
