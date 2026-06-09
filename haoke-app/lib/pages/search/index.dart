import 'package:flutter/material.dart' hide SearchBar;
import 'package:haoke_app/models/room/room_model.dart';
import 'package:haoke_app/pages/home/tab_search/data_list.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/services/storage_service.dart';
import 'package:haoke_app/widgets/common_refresh_indicator.dart';
import 'package:haoke_app/widgets/room_list_item_widget.dart';
import 'package:haoke_app/widgets/search_bar/index.dart' show SearchBar;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const int _pageSize = 10;

  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService.instance;
  final ScrollController _scrollController = ScrollController();

  String _keyword = '';
  List<String> _history = [];
  List<RoomModel> _rooms = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _pageNum = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _loadHistory();
    _search('');
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
      _search(_keyword, pageNum: _pageNum + 1, append: true);
    }
  }

  Future<void> _loadHistory() async {
    final history = await _storageService.getStringList('search_history');
    if (!mounted) return;
    setState(() => _history = history);
  }

  Future<void> _saveKeyword(String keyword) async {
    if (keyword.isEmpty) return;
    final next = [
      keyword,
      ..._history.where((item) => item != keyword),
    ].take(8).toList();
    await _storageService.setStringList('search_history', next);
    if (!mounted) return;
    setState(() => _history = next);
  }

  Future<void> _search(
    String value, {
    int pageNum = 1,
    bool append = false,
  }) async {
    final keyword = value.trim();
    if (append) {
      setState(() => _isLoadingMore = true);
    } else {
      setState(() {
        _keyword = keyword;
        _isLoading = true;
      });
    }

    try {
      final response = keyword.isEmpty
          ? await _apiService.queryHotRooms(
              pageNum: pageNum,
              pageSize: _pageSize,
            )
          : await _apiService.queryRooms(
              keyword: keyword,
              statusList: const ['2'],
              pageNum: pageNum,
              pageSize: _pageSize,
            );
      if (!mounted) return;

      final rooms = response.isSuccess && response.data != null
          ? response.data!
          : <RoomModel>[];
      if (keyword.isNotEmpty && !append) {
        await _saveKeyword(keyword);
      }

      setState(() {
        _rooms = append ? [..._rooms, ...rooms] : rooms;
        _pageNum = pageNum;
        _hasMore = rooms.length >= _pageSize;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _rooms = append ? _rooms : [];
        _isLoading = false;
        _isLoadingMore = false;
        _hasMore = false;
      });
    }
  }

  Future<void> _clearHistory() async {
    await _storageService.deleteString('search_history');
    if (!mounted) return;
    setState(() => _history = []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        titleSpacing: 12,
        title: SearchBar(
          goBackCallback: () => Navigator.pop(context),
          onCancel: () => Navigator.pop(context),
          onSearchSubmit: _search,
          defaultInputValue: '搜索小区、区域、户型',
        ),
      ),
      body: CommonRefreshIndicator(
        onRefresh: () => _search(_keyword),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }

    return ListView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      children: [
        if (_keyword.isEmpty && _history.isNotEmpty) _buildHistory(),
        if (_rooms.isEmpty)
          SizedBox(
            height: 260,
            child: Center(
              child: Text(
                _keyword.isEmpty ? '暂无热门房源' : '没有找到相关房源',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ..._rooms
              .map(RoomListItemData.fromRoom)
              .map((item) => RoomListItemWidget(item)),
        _LoadMoreFooter(isLoadingMore: _isLoadingMore, hasMore: _hasMore),
      ],
    );
  }

  Widget _buildHistory() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '搜索历史',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              TextButton(onPressed: _clearHistory, child: const Text('清空')),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _history
                .map(
                  (item) => ActionChip(
                    label: Text(item),
                    onPressed: () => _search(item),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
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
