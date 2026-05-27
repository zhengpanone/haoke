import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  Future<void> _launchUrl(BuildContext context, String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('链接已复制，请在浏览器中打开')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Haoke Rent')),
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
            'Our Mission',
            const Text(
              'Haoke Rent connects landlords and tenants with transparent listings, efficient communication and safer rental decisions.',
              style: TextStyle(height: 1.55, color: Color(0xFF4C5F5C)),
            ),
          ),
          _section(
            'Contact',
            Column(
              children: [
                _item(context, Icons.language_rounded, 'Website',
                    () => _launchUrl(context, 'https://www.haoke.com')),
                _item(context, Icons.email_outlined, 'Business',
                    () => _launchUrl(context, 'mailto:business@haoke.com')),
                _item(context, Icons.feedback_outlined, 'Feedback',
                    () => _launchUrl(context, 'mailto:feedback@haoke.com')),
              ],
            ),
          ),
          _section(
            'Legal',
            Column(
              children: [
                _item(context, Icons.description_outlined, 'User Agreement',
                    () {}),
                _item(context, Icons.privacy_tip_outlined, 'Privacy Policy',
                    () {}),
                _item(context, Icons.gavel_rounded, 'Disclaimer', () {}),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text('? 2026 Haoke Rent. All rights reserved.',
                style: TextStyle(color: Color(0xFF8D9997), fontSize: 12)),
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
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
