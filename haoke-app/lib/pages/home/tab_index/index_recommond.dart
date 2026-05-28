import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
import 'package:haoke_rent/pages/home/tab_index/index_recommand_date.dart';
import 'package:haoke_rent/pages/home/tab_index/index_recommond_item_widget.dart';

class IndexRecommond extends StatelessWidget {
  const IndexRecommond({super.key});

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
              Text(
                context.tr('more'),
                style: const TextStyle(color: Color(0xFF6D7B78), fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: indexRecommandItemList
                .map((item) => IndexRecommondItemWidget(data: item))
                .toList(),
          ),
        ],
      ),
    );
  }
}
