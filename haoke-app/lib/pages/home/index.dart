import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/pages/home/tab_index/index.dart';
import 'package:haoke_app/pages/home/tab_info/index.dart';
import 'package:haoke_app/pages/home/tab_profile/index.dart';
import 'package:haoke_app/pages/home/tab_search/index.dart';

const List<Widget> tabViewList = [
  TableIndex(),
  TableSearch(),
  TableInfo(),
  TabProfile(),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeNavItems = [
      BottomNavigationBarItem(
          icon: const Icon(Icons.home_rounded), label: context.tr('home')),
      BottomNavigationBarItem(
          icon: const Icon(Icons.search_rounded),
          label: context.tr('find_house')),
      BottomNavigationBarItem(
          icon: const Icon(Icons.article_rounded), label: context.tr('info')),
      BottomNavigationBarItem(
          icon: const Icon(Icons.account_circle_rounded),
          label: context.tr('mine')),
    ];

    return Scaffold(
      body: tabViewList[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: homeNavItems,
          currentIndex: selectedIndex,
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
