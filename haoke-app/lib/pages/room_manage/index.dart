import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/pages/home/tab_search/data_list.dart';
import 'package:haoke_app/widgets/common_float_action_button.dart';
import 'package:haoke_app/widgets/room_list_item_widget.dart';

class RoomManage extends StatelessWidget {
  const RoomManage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            CommonFloatActionButton(context.tr('publish_new_listing'), () {
          Navigator.of(context).pushNamed('roomAdd');
        }),
        appBar: AppBar(
          title: Text(context.tr('house_management')),
          bottom: TabBar(
            tabs: [
              Tab(text: context.tr('vacant')),
              Tab(text: context.tr('rented')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 90, top: 6),
              children:
                  dataList.map((item) => RoomListItemWidget(item)).toList(),
            ),
            ListView(
              padding: const EdgeInsets.only(bottom: 90, top: 6),
              children:
                  dataList.map((item) => RoomListItemWidget(item)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
