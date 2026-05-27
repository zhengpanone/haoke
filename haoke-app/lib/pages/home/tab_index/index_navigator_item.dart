import 'package:flutter/material.dart';

class IndexNavigatorItem {
  final String title;
  final IconData icon;
  final Function(BuildContext context) onTap;

  IndexNavigatorItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

List<IndexNavigatorItem> indexNavigatorItemList = [
  IndexNavigatorItem(
    title: '整租',
    icon: Icons.apartment_rounded,
    onTap: (context) {
      Navigator.of(context).pushNamed('login');
    },
  ),
  IndexNavigatorItem(
    title: '合租',
    icon: Icons.group_rounded,
    onTap: (context) {
      Navigator.of(context).pushNamed('login');
    },
  ),
  IndexNavigatorItem(
    title: '地图找房',
    icon: Icons.map_rounded,
    onTap: (context) {
      Navigator.of(context).pushNamed('login');
    },
  ),
  IndexNavigatorItem(
    title: '去出租',
    icon: Icons.real_estate_agent_rounded,
    onTap: (context) {
      Navigator.of(context).pushNamed('login');
    },
  ),
];
