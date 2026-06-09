import 'package:flutter/material.dart';

String formatProfileDate(DateTime? value, {bool dateOnly = false}) {
  if (value == null) return '';
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  if (dateOnly) {
    return '${value.year}-$month-$day';
  }
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '${value.year}-$month-$day $hour:$minute';
}

Color statusColor(String status) {
  switch (status) {
    case 'COMPLETED':
    case 'VERIFIED':
    case 'SIGNED':
    case 'SUCCESS':
    case 'PAID':
      return const Color(0xFF0F8F7A);
    case 'PENDING':
    case 'PENDING_SIGN':
    case 'REVIEWING':
      return const Color(0xFFF5A623);
    case 'CANCELLED':
    case 'REJECTED':
    case 'TERMINATED':
      return const Color(0xFFE05A47);
    default:
      return const Color(0xFF8A9593);
  }
}

BoxDecoration profileCardDecoration() {
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

class ProfileStatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const ProfileStatusBadge({
    super.key,
    required this.text,
    required this.color,
  });

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

class ProfileEmptyView extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileEmptyView({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(text, style: TextStyle(fontSize: 15, color: Colors.grey[500])),
        ],
      ),
    );
  }
}

class ProfileErrorView extends StatelessWidget {
  final String text;
  final VoidCallback onRetry;

  const ProfileErrorView({
    super.key,
    required this.text,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 52,
              color: Color(0xFF9AA8A5),
            ),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF5A6966)),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 44,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('重试'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
