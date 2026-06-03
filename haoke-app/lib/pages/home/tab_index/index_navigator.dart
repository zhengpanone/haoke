import 'package:flutter/material.dart';
import 'package:haoke_app/pages/home/tab_index/index_navigator_item.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';

class IndexNavigator extends StatelessWidget {
  const IndexNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: indexNavigatorItemList
            .map(
              (item) => InkWell(
                onTap: () => item.onTap(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      CommonIconBadge(
                        icon: item.icon,
                        boxSize: 52,
                        iconSize: 26,
                        radius: 14,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF304744),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
