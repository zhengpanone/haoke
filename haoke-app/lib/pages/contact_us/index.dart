import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  Future<void> _copy(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已复制联系方式')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('contact_us'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5F2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                CommonIconBadge(
                  icon: Icons.support_agent_rounded,
                  boxSize: 50,
                  iconSize: 26,
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '好客客服中心',
                        style: TextStyle(
                          color: Color(0xFF0F8F7A),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '工作日 09:00-21:00 为你处理看房、订单、合同与钱包问题',
                        style: TextStyle(
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
          ),
          const SizedBox(height: 12),
          _ContactTile(
            icon: Icons.phone_rounded,
            title: context.tr('support_hotline'),
            value: '400-800-8888',
            onTap: () => _copy(context, '400-800-8888'),
          ),
          _ContactTile(
            icon: Icons.email_rounded,
            title: context.tr('support_email'),
            value: 'service@haoke.com',
            onTap: () => _copy(context, 'service@haoke.com'),
          ),
          _ContactTile(
            icon: Icons.location_on_rounded,
            title: '办公地址',
            value: '北京市朝阳区望京科技园 18 号',
            onTap: () => _copy(context, '北京市朝阳区望京科技园 18 号'),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CommonIconBadge(icon: icon, boxSize: 38, iconSize: 19),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.copy_rounded, size: 20),
        onTap: onTap,
      ),
    );
  }
}
