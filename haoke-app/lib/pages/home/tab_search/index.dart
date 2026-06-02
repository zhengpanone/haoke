import 'package:flutter/material.dart' hide SearchBar;
import 'package:haoke_rent/pages/home/tab_search/data_list.dart';
import 'package:haoke_rent/pages/home/tab_search/filter_bar/filter_drawer.dart';
import 'package:haoke_rent/pages/home/tab_search/filter_bar/index.dart';
import 'package:haoke_rent/widgets/common_refresh_indicator.dart';
import 'package:haoke_rent/widgets/room_list_item_widget.dart';
import 'package:haoke_rent/widgets/search_bar/index.dart' show SearchBar;

class TableSearch extends StatefulWidget {
  const TableSearch({super.key});

  @override
  State<TableSearch> createState() => _TableSearchState();
}

class _TableSearchState extends State<TableSearch> {
  Future<void> _refreshRooms() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const FilterDrawer(),
      appBar: AppBar(
        toolbarHeight: 68,
        titleSpacing: 12,
        actions: [Container()],
        title: SearchBar(
          showLocation: true,
          showMap: true,
          onSearch: () {
            Navigator.of(context).pushNamed('search');
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE4EEEB)),
            ),
            height: 42,
            child: FilterBar(onChange: (data) {}, scaffoldKey: scaffoldKey),
          ),
          Expanded(
            child: CommonRefreshIndicator(
              onRefresh: _refreshRooms,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children:
                    dataList.map((item) => RoomListItemWidget(item)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
