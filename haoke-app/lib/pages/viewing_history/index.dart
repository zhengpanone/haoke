import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';

class ViewingHistoryPage extends StatelessWidget {
  const ViewingHistoryPage({super.key});

  static const List<_ViewingHistoryItem> _items = [
    _ViewingHistoryItem(
      title: '阳光花园 2 室 1 厅',
      address: '朝阳区望京西路 18 号',
      appointmentTime: '2026-06-10 10:30',
      statusKey: 'viewing_status_pending',
      statusColor: Color(0xFFF5A623),
      noteKey: 'viewing_note_pending',
      note: '李经理 138****8821',
    ),
    _ViewingHistoryItem(
      title: '滨江雅苑整租一居室',
      address: '浦东新区张杨路 889 号',
      appointmentTime: '2026-06-03 15:00',
      statusKey: 'viewing_status_completed',
      statusColor: Color(0xFF0F8F7A),
      noteKey: 'viewing_note_completed',
      note: '采光不错，已收藏房源',
    ),
    _ViewingHistoryItem(
      title: '星河湾南向三居',
      address: '海淀区中关村南大街 6 号',
      appointmentTime: '2026-05-28 09:30',
      statusKey: 'viewing_status_cancelled',
      statusColor: Color(0xFF8A9593),
      noteKey: 'viewing_note_cancelled',
      note: '行程冲突，已取消预约',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('viewing_history'))),
      body: _items.isEmpty
          ? const _ViewingHistoryEmpty()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _ViewingHistoryCard(item: _items[index]);
              },
            ),
    );
  }
}

class _ViewingHistoryCard extends StatelessWidget {
  final _ViewingHistoryItem item;

  const _ViewingHistoryCard({required this.item});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: Color(0xFF1F2B2A),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _StatusChip(
                label: context.tr(item.statusKey),
                color: item.statusColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: context.tr('viewing_address'),
            value: item.address,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.schedule_rounded,
            label: context.tr('viewing_appointment_time'),
            value: item.appointmentTime,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.person_outline_rounded,
            label: context.tr(item.noteKey),
            value: item.note,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: const Color(0xFF7D8B88)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: Color(0xFF7D8B88), fontSize: 13),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF334845),
              fontSize: 13,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ViewingHistoryEmpty extends StatelessWidget {
  const _ViewingHistoryEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history_rounded, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            context.tr('viewing_history_empty'),
            style: TextStyle(fontSize: 15, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class _ViewingHistoryItem {
  final String title;
  final String address;
  final String appointmentTime;
  final String statusKey;
  final Color statusColor;
  final String noteKey;
  final String note;

  const _ViewingHistoryItem({
    required this.title,
    required this.address,
    required this.appointmentTime,
    required this.statusKey,
    required this.statusColor,
    required this.noteKey,
    required this.note,
  });
}
