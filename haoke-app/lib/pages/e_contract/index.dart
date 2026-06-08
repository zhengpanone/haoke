import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';

class EContractPage extends StatelessWidget {
  const EContractPage({super.key});

  static const List<_ContractItem> _contracts = [
    _ContractItem(
      title: '阳光花园租赁合同',
      period: '2026-06-15 至 2027-06-14',
      status: '待签署',
      color: Color(0xFFF5A623),
    ),
    _ContractItem(
      title: '滨江雅苑服务协议',
      period: '2026-06-01 至 2026-06-30',
      status: '已归档',
      color: Color(0xFF8A9593),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('e_contract'))),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
        itemCount: _contracts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _ContractCard(item: _contracts[index]),
      ),
    );
  }
}

class _ContractCard extends StatelessWidget {
  final _ContractItem item;

  const _ContractCard({required this.item});

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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonIconBadge(
                icon: Icons.description_rounded,
                boxSize: 48,
                iconSize: 24,
                backgroundColor: Color(0xFFFFF3E8),
                iconColor: Color(0xFFE26A2C),
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
                      item.period,
                      style: const TextStyle(
                        color: Color(0xFF7D8B88),
                        fontSize: 13,
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
                  onPressed: () => _showTip(context, '合同下载即将开放'),
                  child: const Text('下载 PDF'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showTip(context, '合同详情即将开放'),
                  child: const Text('查看合同'),
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

class _ContractItem {
  final String title;
  final String period;
  final String status;
  final Color color;

  const _ContractItem({
    required this.title,
    required this.period,
    required this.status,
    required this.color,
  });
}

void _showTip(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
