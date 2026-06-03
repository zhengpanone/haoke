import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/models/room/room_model.dart';
import 'package:haoke_app/pages/home/tab_search/data_list.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/widgets/common_float_action_button.dart';
import 'package:haoke_app/widgets/common_refresh_indicator.dart';
import 'package:haoke_app/widgets/room_list_item_widget.dart';

class RoomManage extends StatefulWidget {
  const RoomManage({super.key});

  @override
  State<RoomManage> createState() => _RoomManageState();
}

class _RoomManageState extends State<RoomManage> {
  final ApiService _apiService = ApiService();

  List<RoomModel> _vacantRooms = [];
  List<RoomModel> _rentedRooms = [];
  bool _isLoadingVacant = true;
  bool _isLoadingRented = true;

  @override
  void initState() {
    super.initState();
    _loadVacantRooms();
    _loadRentedRooms();
  }

  // 空置房屋
  Future<void> _loadVacantRooms() async {
    try {
      final response = await _apiService.queryPublishRooms(
        statusList: ['1', '2', '3', '5'],
      );
      if (!mounted) return;

      setState(() {
        if (response.isSuccess && response.data != null) {
          _vacantRooms = response.data!;
        }
        _isLoadingVacant = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingVacant = false);
    }
  }

  // 已出租房屋
  Future<void> _loadRentedRooms() async {
    try {
      final response = await _apiService.queryPublishRooms(status: '4');
      if (!mounted) return;

      setState(() {
        if (response.isSuccess && response.data != null) {
          _rentedRooms = response.data!;
        }
        _isLoadingRented = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingRented = false);
    }
  }

  List<RoomListItemData> _toListItemData(List<RoomModel> rooms) {
    return rooms.map((room) {
      final json = room.toListItemJson();
      return RoomListItemData(
        id: json['id'] as String,
        title: json['title'] as String,
        subTitle: json['subTitle'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        tags: List<String>.from(json['tags'] as List),
        price: json['price'] as int,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CommonFloatActionButton(
          context.tr('publish_new_listing'),
          () {
            Navigator.of(context).pushNamed('roomAdd').then((_) {
              // 发布房源返回后刷新列表
              _loadVacantRooms();
            });
          },
        ),
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
            _buildRoomList(
              isLoading: _isLoadingVacant,
              rooms: _vacantRooms,
              onRefresh: _loadVacantRooms,
            ),
            _buildRoomList(
              isLoading: _isLoadingRented,
              rooms: _rentedRooms,
              onRefresh: _loadRentedRooms,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomList({
    required bool isLoading,
    required List<RoomModel> rooms,
    required Future<void> Function() onRefresh,
  }) {
    Widget child;

    if (isLoading) {
      child = const Center(child: CircularProgressIndicator());
    } else if (rooms.isEmpty) {
      child = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.55,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    context.tr('no_data'),
                    style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      final items = _toListItemData(rooms);

      child = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 90, top: 6),
        children: items.map((item) => RoomListItemWidget(item)).toList(),
      );
    }

    return CommonRefreshIndicator(onRefresh: onRefresh, child: child);
  }
}
