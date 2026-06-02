import 'package:flutter/material.dart' hide SearchBar;
import 'package:haoke_rent/pages/home/info/info.dart';
import 'package:haoke_rent/pages/home/tab_index/index_navigator.dart';
import 'package:haoke_rent/pages/home/tab_index/index_recommond.dart';
import 'package:haoke_rent/widgets/common_refresh_indicator.dart';
import 'package:haoke_rent/widgets/common_swipper.dart';
import 'package:haoke_rent/widgets/search_bar/index.dart';

class TableIndex extends StatelessWidget {
  const TableIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        titleSpacing: 12,
        title: SearchBar(
          showLocation: true,
          showMap: true,
          onSearch: () {
            Navigator.of(context).pushNamed('search');
          },
        ),
      ),
      body: CommonRefreshIndicator(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 8),
            CommonSwipper(indicatorInside: true),
            SizedBox(height: 6),
            IndexNavigator(),
            SizedBox(height: 4),
            IndexRecommond(),
            SizedBox(height: 8),
            Info(showTitle: true),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
