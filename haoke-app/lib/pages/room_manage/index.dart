import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/tab_search/data_list.dart';
import 'package:haoke_rent/widgets/common_float_action_button.dart';
import 'package:haoke_rent/widgets/room_list_item_widget.dart';

class RoomManage extends StatelessWidget {
  const RoomManage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CommonFloatActionButton('发布房源', () {
          Navigator.of(context).pushNamed('roomAdd');
        }),
        appBar: AppBar(
          title: Text('房屋管理', style: TextStyle(color: Colors.white)),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  '空置',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '已出租',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              children: dataList
                  .map((item) => RoomListItemWidget(item))
                  .toList(),
            ),
            ListView(
              children: dataList
                  .map((item) => RoomListItemWidget(item))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
