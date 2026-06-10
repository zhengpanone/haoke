import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/models/room/room_model.dart';
import 'package:haoke_app/pages/home/tab_index/index_recommand_date.dart';
import 'package:haoke_app/pages/home/tab_index/index_recommond_item_widget.dart';
import 'package:haoke_app/routes.dart';
import 'package:haoke_app/services/api_service.dart';

class IndexRecommond extends StatefulWidget {
  const IndexRecommond({super.key});

  @override
  State<IndexRecommond> createState() => _IndexRecommondState();
}

class _IndexRecommondState extends State<IndexRecommond> {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  List<IndexRecommandItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadRecommendRooms();
  }

  Future<void> _loadRecommendRooms() async {
    try {
      final response = await _apiService.queryRecommendedRooms(pageSize: 4);
      if (!mounted) return;
      final rooms = response.isSuccess && response.data != null
          ? response.data!
          : <RoomModel>[];
      setState(() {
        _items = rooms.map(IndexRecommandItem.fromRoom).toList();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _items = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7F4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('recommended_homes'),
                style: const TextStyle(
                  color: Color(0xFF1F2B2A),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pushNamed(Routes.search),
                child: Text(
                  context.tr('more'),
                  style: const TextStyle(
                    color: Color(0xFF6D7B78),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_isLoading)
            const SizedBox(
              height: 82,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else if (_items.isEmpty)
            SizedBox(
              height: 82,
              child: Center(
                child: Text(
                  '暂无推荐房源',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _items
                  .map((item) => IndexRecommondItemWidget(data: item))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
