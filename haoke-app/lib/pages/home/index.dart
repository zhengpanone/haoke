import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/tab_index/index.dart';
import 'package:haoke_rent/pages/home/tab_info/index.dart';
import 'package:haoke_rent/pages/home/tab_profile/index.dart';
import 'package:haoke_rent/pages/home/tab_search/index.dart';

List<Widget> tabViewList = [
  TableIndex(),
  TableSearch(),
  TableInfo(),
  TabProfile(),
];

List<BottomNavigationBarItem> homeNavItems = [
  BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
  BottomNavigationBarItem(icon: Icon(Icons.search), label: '找房'),
  BottomNavigationBarItem(icon: Icon(Icons.article), label: '资讯'),
  BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: homeNavItems,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: onItemTapped,
      ),
    );
  }
}
