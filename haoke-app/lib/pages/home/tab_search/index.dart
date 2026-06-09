import 'package:flutter/material.dart' hide SearchBar;
import 'package:haoke_app/models/filter_model.dart';
import 'package:haoke_app/models/room/room_model.dart';
import 'package:haoke_app/pages/home/tab_search/data_list.dart';
import 'package:haoke_app/pages/home/tab_search/filter_bar/filter_drawer.dart';
import 'package:haoke_app/pages/home/tab_search/filter_bar/index.dart';
import 'package:haoke_app/routes.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/widgets/common_refresh_indicator.dart';
import 'package:haoke_app/widgets/room_list_item_widget.dart';
import 'package:haoke_app/widgets/search_bar/index.dart' show SearchBar;
import 'package:provider/provider.dart';

class TableSearch extends StatefulWidget {
  const TableSearch({super.key});

  @override
  State<TableSearch> createState() => _TableSearchState();
}

class _TableSearchState extends State<TableSearch> {
  static const int _pageSize = 10;

  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  List<RoomModel> _rooms = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _pageNum = 1;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRooms(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients || _isLoadingMore || !_hasMore) return;
    if (_scrollController.position.extentAfter < 180) {
      _loadRooms(pageNum: _pageNum + 1, append: true);
    }
  }

  Future<void> _refreshRooms() => _loadRooms(refresh: true);

  Future<void> _loadRooms({
    bool refresh = false,
    int pageNum = 1,
    bool append = false,
  }) async {
    if (!mounted) return;
    if (append) {
      setState(() => _isLoadingMore = true);
    } else {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final query = _buildQueryFromFilters();
      final response = await _apiService.queryRooms(
        keyword: query.keyword,
        rentMethod: query.rentMethod,
        minRent: query.minRent,
        maxRent: query.maxRent,
        houseTypes: query.houseTypes,
        floorKeywords: query.floorKeywords,
        orientations: query.orientations,
        statusList: const ['2'],
        pageNum: refresh ? 1 : pageNum,
        pageSize: _pageSize,
      );
      if (!mounted) return;

      final rooms = response.isSuccess && response.data != null
          ? response.data!
          : <RoomModel>[];

      setState(() {
        _rooms = append ? [..._rooms, ...rooms] : rooms;
        _pageNum = refresh ? 1 : pageNum;
        _hasMore = rooms.length >= _pageSize;
        _isLoading = false;
        _isLoadingMore = false;
        _errorMessage = response.isSuccess ? null : response.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _errorMessage = e.toString();
      });
    }
  }

  _RoomQuery _buildQueryFromFilters() {
    final filters = context.read<FilterModel>().filters;
    final area = _first(filters['area']);
    final rentMethod = int.tryParse(_first(filters['rentalType']) ?? '');
    final priceRange = _parsePriceRange(_first(filters['rental']));
    final orientations = filters['oriented']?.ids
        .map(int.tryParse)
        .whereType<int>()
        .toList();

    return _RoomQuery(
      keyword: area,
      rentMethod: rentMethod,
      minRent: priceRange.$1,
      maxRent: priceRange.$2,
      houseTypes: filters['roomType']?.ids,
      floorKeywords: filters['floor']?.ids,
      orientations: orientations,
    );
  }

  String? _first(FilterItem? item) {
    if (item == null || item.ids.isEmpty) return null;
    return item.ids.first.isEmpty ? null : item.ids.first;
  }

  (int?, int?) _parsePriceRange(String? value) {
    if (value == null || value.isEmpty) return (null, null);
    final parts = value.split('-');
    final min = parts.isNotEmpty && parts[0].isNotEmpty
        ? int.tryParse(parts[0])
        : null;
    final max = parts.length > 1 && parts[1].isNotEmpty
        ? int.tryParse(parts[1])
        : null;
    return (min, max);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      endDrawer: FilterDrawer(onConfirm: () => _loadRooms(refresh: true)),
      appBar: AppBar(
        toolbarHeight: 68,
        titleSpacing: 12,
        actions: [Container()],
        title: SearchBar(
          showLocation: true,
          showMap: true,
          onSearch: () => Navigator.of(context).pushNamed(Routes.search),
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
            child: FilterBar(
              onChange: (_) => _loadRooms(refresh: true),
              scaffoldKey: scaffoldKey,
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    Widget child;
    if (_isLoading) {
      child = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 260,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    } else if (_errorMessage != null && _rooms.isEmpty) {
      child = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 300,
            child: Center(
              child: Text(
                '加载失败，稍后重试',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      );
    } else if (_rooms.isEmpty) {
      child = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 300,
            child: Center(
              child: Text('暂无匹配房源', style: TextStyle(color: Colors.grey[600])),
            ),
          ),
        ],
      );
    } else {
      child = ListView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 18),
        children: [
          ..._rooms
              .map(RoomListItemData.fromRoom)
              .map((item) => RoomListItemWidget(item)),
          _LoadMoreFooter(isLoadingMore: _isLoadingMore, hasMore: _hasMore),
        ],
      );
    }

    return CommonRefreshIndicator(onRefresh: _refreshRooms, child: child);
  }
}

class _RoomQuery {
  final String? keyword;
  final int? rentMethod;
  final int? minRent;
  final int? maxRent;
  final List<String>? houseTypes;
  final List<String>? floorKeywords;
  final List<int>? orientations;

  const _RoomQuery({
    this.keyword,
    this.rentMethod,
    this.minRent,
    this.maxRent,
    this.houseTypes,
    this.floorKeywords,
    this.orientations,
  });
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
      child: Center(
        child: Text(
          hasMore ? '' : '没有更多了',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ),
    );
  }
}
