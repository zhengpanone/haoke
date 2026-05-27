import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/tab_index/index.dart';
import 'package:haoke_rent/pages/home/tab_info/index.dart';
import 'package:haoke_rent/pages/home/tab_profile/index.dart';
import 'package:haoke_rent/pages/home/tab_search/index.dart';

const List<Widget> tabViewList = [
  TableIndex(),
  TableSearch(),
  TableInfo(),
  TabProfile(),
];

const List<BottomNavigationBarItem> homeNavItems = [
  BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: '首页'),
  BottomNavigationBarItem(
      icon: Icon(Icons.travel_explore_rounded), label: '找房'),
  BottomNavigationBarItem(icon: Icon(Icons.newspaper_rounded), label: '资讯'),
  BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: '我的'),
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
