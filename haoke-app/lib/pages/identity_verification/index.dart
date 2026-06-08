import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';

class IdentityVerificationPage extends StatelessWidget {
  const IdentityVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('identity_verification'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
        children: [
          const _StatusPanel(
            icon: Icons.verified_user_rounded,
            title: '实名认证未完成',
            subtitle: '完成认证后可签署合同、申请租房订单和使用钱包服务',
            color: Color(0xFF0F8F7A),
          ),
          const SizedBox(height: 12),
          const _StepTile(
            index: 1,
            title: '上传身份证件',
            subtitle: '请准备本人有效身份证正反面照片',
            done: true,
          ),
          const _StepTile(
            index: 2,
            title: '人脸核验',
            subtitle: '确保光线充足，按页面提示完成拍摄',
            done: false,
          ),
          const _StepTile(
            index: 3,
            title: '等待审核',
            subtitle: '通常 1 个工作日内完成审核',
            done: false,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () => _showTip(context, '认证流程即将开放'),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('开始认证'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _StatusPanel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CommonIconBadge(
            icon: icon,
            boxSize: 50,
            iconSize: 26,
            iconColor: color,
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF4C5F5C),
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final bool done;

  const _StepTile({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: done
                ? const Color(0xFFEAF5F2)
                : const Color(0xFFF1F3F3),
            child: done
                ? const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF0F8F7A),
                    size: 20,
                  )
                : Text(
                    '$index',
                    style: const TextStyle(
                      color: Color(0xFF7D8B88),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1F2B2A),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF7D8B88),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showTip(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
