import 'package:flutter/material.dart' hide SearchBar;
import 'package:haoke_rent/pages/home/info/info.dart';
import 'package:haoke_rent/pages/home/tab_index/index_navigator.dart';
import 'package:haoke_rent/pages/home/tab_index/index_recommond.dart';

import 'package:haoke_rent/widgets/common_swipper.dart';
import 'package:haoke_rent/widgets/search_bar/index.dart';

// 首页
class TableIndex extends StatelessWidget {
  const TableIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          showLocation: true,
          showMap: true,
          onSearch: () {
            Navigator.of(context).pushNamed('search');
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: const [
          ListTile(title: Text('顶部')),
          CommonSwipper(indicatorInside: true),
          IndexNavigator(),
          IndexRecommond(),
          Info(showTitle: true),
        ],
      ),
    );
  }
}
