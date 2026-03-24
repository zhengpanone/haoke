import 'package:flutter/material.dart' hide SearchBar;
import 'package:haoke_rent/pages/home/tab_search/data_list.dart';
import 'package:haoke_rent/pages/home/tab_search/filter_bar/filter_drawer.dart';
import 'package:haoke_rent/pages/home/tab_search/filter_bar/index.dart';
import 'package:haoke_rent/widgets/room_list_item_widget.dart';
import 'package:haoke_rent/widgets/search_bar/index.dart' show SearchBar;

class TableSearch extends StatefulWidget {
  const TableSearch({super.key});

  @override
  State<TableSearch> createState() => _TableSearchState();
}

class _TableSearchState extends State<TableSearch> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const FilterDrawer(),
      appBar: AppBar(
        actions: [Container()],
        elevation: 0,
        title: SearchBar(
          showLocation: true,
          showMap: true,
          onSearch: () {
            Navigator.of(context).pushNamed('search');
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 41,
            child: FilterBar(onChange: (data) {}, scaffoldKey: scaffoldKey),
          ),
          Expanded(
            child: ListView(
              children:
                  dataList.map((item) => RoomListItemWidget(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
