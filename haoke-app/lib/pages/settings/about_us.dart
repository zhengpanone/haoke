import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
import 'package:haoke_rent/widgets/common_icon_badge.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  Future<void> _launchUrl(BuildContext context, String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('link_copied_open_browser'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('about_haoke_rent'))),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: Color(0xFFE8F6F2),
                  child: Icon(Icons.home_rounded,
                      size: 38, color: Color(0xFF0F8F7A)),
                ),
                SizedBox(height: 12),
                Text(
                  'Haoke Rent',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                ),
                SizedBox(height: 4),
                Text('Version 1.0.0',
                    style: TextStyle(color: Color(0xFF7B8885))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _section(
            context.tr('our_mission'),
            Text(
              context.tr('mission_content'),
              style: const TextStyle(height: 1.55, color: Color(0xFF4C5F5C)),
            ),
          ),
          _section(
            context.tr('contact'),
            Column(
              children: [
                _item(context, Icons.public_rounded, context.tr('website'),
                    () => _launchUrl(context, 'https://www.haoke.com')),
                _item(
                    context,
                    Icons.business_center_rounded,
                    context.tr('business'),
                    () => _launchUrl(context, 'mailto:business@haoke.com')),
                _item(context, Icons.feedback_rounded, context.tr('feedback'),
                    () => _launchUrl(context, 'mailto:feedback@haoke.com')),
              ],
            ),
          ),
          _section(
            context.tr('legal'),
            Column(
              children: [
                _item(context, Icons.description_rounded,
                    context.tr('user_agreement'), () {}),
                _item(context, Icons.privacy_tip_rounded,
                    context.tr('privacy_policy'), () {}),
                _item(context, Icons.gavel_rounded, context.tr('disclaimer'),
                    () {}),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
                '(c) 2026 Haoke Rent. ${context.tr('all_rights_reserved')}',
                style: const TextStyle(color: Color(0xFF8D9997), fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _item(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CommonIconBadge(icon: icon, boxSize: 34, iconSize: 17),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
