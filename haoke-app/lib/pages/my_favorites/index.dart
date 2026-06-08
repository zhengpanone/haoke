import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';

class MyFavoritesPage extends StatelessWidget {
  const MyFavoritesPage({super.key});

  static const List<_FavoriteItem> _favorites = [
    _FavoriteItem(
      title: '阳光花园 2 室 1 厅',
      address: '近地铁 14 号线，南向采光',
      price: '¥5800/月',
      tags: ['整租', '近地铁', '精装'],
    ),
    _FavoriteItem(
      title: '星河湾南向三居',
      address: '海淀区中关村南大街 6 号',
      price: '¥8600/月',
      tags: ['三居', '可短租', '随时看房'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('my_favorites'))),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
        itemCount: _favorites.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _favorites[index];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: _cardDecoration(),
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
                        children: item.tags
                            .map((tag) => _SoftTag(tag))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  item.price,
                  style: const TextStyle(
                    color: Color(0xFFFF7A45),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          );
        },
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

class _FavoriteItem {
  final String title;
  final String address;
  final String price;
  final List<String> tags;

  const _FavoriteItem({
    required this.title,
    required this.address,
    required this.price,
    required this.tags,
  });
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
