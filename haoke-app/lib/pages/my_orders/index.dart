import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  static const List<_OrderItem> _orders = [
    _OrderItem(
      title: '阳光花园租房订单',
      address: '朝阳区望京西路 18 号',
      date: '下单时间 2026-06-08 14:20',
      status: '待签约',
      action: '去签约',
      color: Color(0xFFF5A623),
    ),
    _OrderItem(
      title: '滨江雅苑看房服务',
      address: '浦东新区张杨路 889 号',
      date: '下单时间 2026-06-01 10:12',
      status: '已完成',
      action: '评价',
      color: Color(0xFF0F8F7A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('my_orders'))),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
        itemCount: _orders.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _OrderCard(item: _orders[index]),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final _OrderItem item;

  const _OrderCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonIconBadge(
                icon: Icons.receipt_long_rounded,
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
                      '${item.address}\n${item.date}',
                      style: const TextStyle(
                        color: Color(0xFF7D8B88),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _StatusBadge(text: item.status, color: item.color),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showTip(context, '订单详情即将开放'),
                  child: const Text('查看详情'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showTip(context, '${item.action}功能即将开放'),
                  child: Text(item.action),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OrderItem {
  final String title;
  final String address;
  final String date;
  final String status;
  final String action;
  final Color color;

  const _OrderItem({
    required this.title,
    required this.address,
    required this.date,
    required this.status,
    required this.action,
    required this.color,
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

void _showTip(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
