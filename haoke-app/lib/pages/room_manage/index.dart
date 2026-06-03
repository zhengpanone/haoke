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
  static const int _pageSize = 2;

  final ApiService _apiService = ApiService();
  final ScrollController _vacantScrollController = ScrollController();
  final ScrollController _rentedScrollController = ScrollController();

  List<RoomModel> _vacantRooms = [];
  List<RoomModel> _rentedRooms = [];
  bool _isLoadingVacant = true;
  bool _isLoadingRented = true;
  bool _isLoadingMoreVacant = false;
  bool _isLoadingMoreRented = false;
  bool _hasMoreVacant = true;
  bool _hasMoreRented = true;
  int _vacantPageNum = 1;
  int _rentedPageNum = 1;

  @override
  void initState() {
    super.initState();
    _vacantScrollController.addListener(_handleVacantScroll);
    _rentedScrollController.addListener(_handleRentedScroll);
    _loadVacantRooms(refresh: true);
    _loadRentedRooms(refresh: true);
  }

  @override
  void dispose() {
    _vacantScrollController
      ..removeListener(_handleVacantScroll)
      ..dispose();
    _rentedScrollController
      ..removeListener(_handleRentedScroll)
      ..dispose();
    super.dispose();
  }

  void _handleVacantScroll() {
    if (_shouldLoadMore(_vacantScrollController)) {
      _loadMoreVacantRooms();
    }
  }

  void _handleRentedScroll() {
    if (_shouldLoadMore(_rentedScrollController)) {
      _loadMoreRentedRooms();
    }
  }

  bool _shouldLoadMore(ScrollController controller) {
    if (!controller.hasClients) return false;
    return controller.position.extentAfter < 160;
  }

  void _checkLoadMoreAfterLayout({
    required ScrollController controller,
    required bool hasMore,
    required bool isLoadingMore,
    required Future<void> Function() onLoadMore,
  }) {
    if (!hasMore || isLoadingMore) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_shouldLoadMore(controller)) return;
      onLoadMore();
    });
  }

  Future<void> _loadVacantRooms({bool refresh = false}) {
    return _loadVacantPage(1, append: false);
  }

  Future<void> _loadMoreVacantRooms() {
    if (_isLoadingMoreVacant || !_hasMoreVacant) {
      return Future<void>.value();
    }

    final nextPageNum = _vacantPageNum + 1;
    return _loadVacantPage(nextPageNum, append: true);
  }

  Future<void> _loadVacantPage(int pageNum, {required bool append}) async {
    if (append && mounted) {
      setState(() => _isLoadingMoreVacant = true);
    }

    try {
      final response = await _apiService.queryPublishRooms(
        statusList: ['1', '2', '3', '5'],
        pageNum: pageNum,
        pageSize: _pageSize,
      );
      if (!mounted) return;

      final rooms = response.isSuccess && response.data != null
          ? response.data!
          : <RoomModel>[];

      setState(() {
        if (append) {
          _vacantRooms = [..._vacantRooms, ...rooms];
        } else {
          _vacantRooms = rooms;
        }
        _vacantPageNum = pageNum;
        _hasMoreVacant = rooms.length >= _pageSize;
        _isLoadingVacant = false;
        _isLoadingMoreVacant = false;
      });

      _checkLoadMoreAfterLayout(
        controller: _vacantScrollController,
        hasMore: _hasMoreVacant,
        isLoadingMore: _isLoadingMoreVacant,
        onLoadMore: _loadMoreVacantRooms,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingVacant = false;
        _isLoadingMoreVacant = false;
      });
    }
  }

  Future<void> _loadRentedRooms({bool refresh = false}) {
    return _loadRentedPage(1, append: false);
  }

  Future<void> _loadMoreRentedRooms() {
    if (_isLoadingMoreRented || !_hasMoreRented) {
      return Future<void>.value();
    }

    final nextPageNum = _rentedPageNum + 1;
    return _loadRentedPage(nextPageNum, append: true);
  }

  Future<void> _loadRentedPage(int pageNum, {required bool append}) async {
    if (append && mounted) {
      setState(() => _isLoadingMoreRented = true);
    }

    try {
      final response = await _apiService.queryPublishRooms(
        status: '4',
        pageNum: pageNum,
        pageSize: _pageSize,
      );
      if (!mounted) return;

      final rooms = response.isSuccess && response.data != null
          ? response.data!
          : <RoomModel>[];

      setState(() {
        if (append) {
          _rentedRooms = [..._rentedRooms, ...rooms];
        } else {
          _rentedRooms = rooms;
        }
        _rentedPageNum = pageNum;
        _hasMoreRented = rooms.length >= _pageSize;
        _isLoadingRented = false;
        _isLoadingMoreRented = false;
      });

      _checkLoadMoreAfterLayout(
        controller: _rentedScrollController,
        hasMore: _hasMoreRented,
        isLoadingMore: _isLoadingMoreRented,
        onLoadMore: _loadMoreRentedRooms,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingRented = false;
        _isLoadingMoreRented = false;
      });
    }
  }

  List<RoomListItemData> _toListItemData(List<RoomModel> rooms) {
    return rooms.map((room) {
      final json = room.toListItemJson();
      return RoomListItemData(
        id: json['id'] as String,
        title: json['title'] as String,
        subTitle: json['subTitle'] as String? ?? '',
        imageUrl: (json['imageUrl'] as String?)?.isNotEmpty == true
            ? json['imageUrl'] as String
            : 'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
        tags: List<String>.from(json['tags'] as List),
        price: json['price'] as double,
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
              _loadVacantRooms(refresh: true);
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
              isLoadingMore: _isLoadingMoreVacant,
              hasMore: _hasMoreVacant,
              rooms: _vacantRooms,
              controller: _vacantScrollController,
              onRefresh: () => _loadVacantRooms(refresh: true),
              onLoadMore: _loadMoreVacantRooms,
            ),
            _buildRoomList(
              isLoading: _isLoadingRented,
              isLoadingMore: _isLoadingMoreRented,
              hasMore: _hasMoreRented,
              rooms: _rentedRooms,
              controller: _rentedScrollController,
              onRefresh: () => _loadRentedRooms(refresh: true),
              onLoadMore: _loadMoreRentedRooms,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomList({
    required bool isLoading,
    required bool isLoadingMore,
    required bool hasMore,
    required List<RoomModel> rooms,
    required ScrollController controller,
    required Future<void> Function() onRefresh,
    required Future<void> Function() onLoadMore,
  }) {
    Widget child;

    if (isLoading) {
      child = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.55,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ],
      );
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

      _checkLoadMoreAfterLayout(
        controller: controller,
        hasMore: hasMore,
        isLoadingMore: isLoadingMore,
        onLoadMore: onLoadMore,
      );

      child = ListView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 90, top: 6),
        children: [
          ...items.map((item) => RoomListItemWidget(item)),
          _LoadMoreFooter(isLoadingMore: isLoadingMore, hasMore: hasMore),
        ],
      );
    }

    return CommonRefreshIndicator(onRefresh: onRefresh, child: child);
  }
}

class _LoadMoreFooter extends StatelessWidget {
  final bool isLoadingMore;
  final bool hasMore;

  const _LoadMoreFooter({required this.isLoadingMore, required this.hasMore});

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(0, 12, 0, 20),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (hasMore) {
      return const SizedBox(height: 12);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
      child: Center(
        child: Text(
          '没有更多了',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ),
    );
  }
}
