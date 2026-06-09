import 'package:flutter/material.dart' hide SearchBar;
import 'package:haoke_app/pages/home/info/info.dart';
import 'package:haoke_app/routes.dart';
import 'package:haoke_app/widgets/common_refresh_indicator.dart';
import 'package:haoke_app/widgets/search_bar/index.dart' show SearchBar;

class TableInfo extends StatefulWidget {
  const TableInfo({super.key});

  @override
  State<TableInfo> createState() => _TableInfoState();
}

class _TableInfoState extends State<TableInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        titleSpacing: 12,
        title: SearchBar(
          showLocation: false,
          showMap: false,
          onSearch: () {
            Navigator.of(context).pushNamed(Routes.search);
          },
        ),
      ),
      body: CommonRefreshIndicator(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 6),
            Info(showTitle: true),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
