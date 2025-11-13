import 'package:flutter/material.dart' hide SearchBar;
import 'package:haoke_rent/pages/home/info/info.dart';
import 'package:haoke_rent/widgets/search_bar/index.dart' show SearchBar;

// 资讯页
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
        title: SearchBar(
          showLocation: false,
          showMap: false,
          onSearch: () {
            Navigator.of(context).pushNamed('search');
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.only(bottom: 10)),
          Info(),
          Info(),
          Info(),
          Info(),
        ],
      ),
    );
  }
}
