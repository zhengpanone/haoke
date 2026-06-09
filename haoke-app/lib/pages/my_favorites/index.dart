import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/models/profile/profile_models.dart';
import 'package:haoke_app/routes.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';
import 'package:haoke_app/widgets/profile_feature_widgets.dart';

class MyFavoritesPage extends StatefulWidget {
  const MyFavoritesPage({super.key});

  @override
  State<MyFavoritesPage> createState() => _MyFavoritesPageState();
}

class _MyFavoritesPageState extends State<MyFavoritesPage> {
  final ApiService _apiService = ApiService();
  late Future<List<HouseFavoriteModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<List<HouseFavoriteModel>> _loadData() async {
    final response = await _apiService.queryMyFavorites();
    if (response.isSuccess) {
      return response.data ?? <HouseFavoriteModel>[];
    }
    throw Exception(response.message.isEmpty ? '收藏加载失败' : response.message);
  }

  void _reload() {
    setState(() {
      _future = _loadData();
    });
  }

  Future<void> _refresh() async {
    _reload();
    await _future;
  }

  Future<void> _removeFavorite(HouseFavoriteModel item) async {
    final response = await _apiService.removeFavorite(item.houseId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.isSuccess ? '已取消收藏' : '取消收藏失败')),
    );
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('my_favorites'))),
      body: FutureBuilder<List<HouseFavoriteModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ProfileErrorView(
              text: '${snapshot.error}',
              onRetry: _reload,
            );
          }
          final favorites = snapshot.data ?? <HouseFavoriteModel>[];
          if (favorites.isEmpty) {
            return const ProfileEmptyView(
              icon: Icons.favorite_rounded,
              text: '暂无收藏',
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
              itemCount: favorites.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = favorites[index];
                return _FavoriteCard(
                  item: item,
                  onRemove: () => _removeFavorite(item),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final HouseFavoriteModel item;
  final VoidCallback onRemove;

  const _FavoriteCard({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: item.houseId.isEmpty
          ? null
          : () {
              Navigator.of(context).pushNamed(
                Routes.roomDetail.replaceFirst(':roomId', item.houseId),
              );
            },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: profileCardDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonIconBadge(
              icon: Icons.apartment_rounded,
              boxSize: 48,
              iconSize: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Color(0xFF1F2B2A),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.address,
                    style: const TextStyle(
                      color: Color(0xFF7D8B88),
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.tags.map((tag) => _SoftTag(tag)).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '¥${item.price.toStringAsFixed(0)}/月',
                  style: const TextStyle(
                    color: Color(0xFFFF7A45),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  tooltip: '取消收藏',
                  onPressed: onRemove,
                  icon: const Icon(Icons.favorite_rounded, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftTag extends StatelessWidget {
  final String text;

  const _SoftTag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF0F8F7A),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
