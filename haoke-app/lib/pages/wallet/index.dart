import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  static const List<_WalletRecord> _records = [
    _WalletRecord(
      icon: Icons.keyboard_return_rounded,
      title: '押金退款',
      date: '2026-06-06 18:20',
      amount: '+¥1,200.00',
      isIncome: true,
    ),
    _WalletRecord(
      icon: Icons.home_repair_service_rounded,
      title: '看房服务费',
      date: '2026-06-01 10:12',
      amount: '-¥80.00',
      isIncome: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('wallet'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0F8F7A),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '账户余额',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '¥ 2,680.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  '押金、租金和退款都会记录在这里',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showTip(context, '提现功能即将开放'),
                  child: const Text('提现'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showTip(context, '充值功能即将开放'),
                  child: const Text('充值'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._records.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _WalletRecordCard(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletRecordCard extends StatelessWidget {
  final _WalletRecord item;

  const _WalletRecordCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
        children: [
          CommonIconBadge(icon: item.icon, boxSize: 42, iconSize: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Color(0xFF1F2B2A),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.date,
                  style: const TextStyle(
                    color: Color(0xFF7D8B88),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.amount,
            style: TextStyle(
              color: item.isIncome
                  ? const Color(0xFF0F8F7A)
                  : const Color(0xFF1F2B2A),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletRecord {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final bool isIncome;

  const _WalletRecord({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
  });
}

void _showTip(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
