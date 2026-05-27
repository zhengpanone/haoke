import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/settings/about_us.dart';
import 'package:haoke_rent/pages/settings/change_password.dart';
import 'package:haoke_rent/pages/settings/help_center.dart';
import 'package:haoke_rent/pages/settings/language_setting.dart';
import 'package:haoke_rent/pages/settings/phone_binding.dart';
import 'package:haoke_rent/pages/settings/privacy_settings.dart';
import 'package:haoke_rent/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 22),
        children: [
          _buildSectionTitle('Account & Security'),
          _buildCard([
            _buildSettingItem(
              icon: Icons.lock_outline_rounded,
              title: 'Change password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()),
                );
              },
            ),
            _buildSettingItem(
              icon: Icons.phone_android_rounded,
              title: 'Phone binding',
              subTitle: authProvider.currentUser?.phone ?? 'Not bound',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PhoneBindingPage()),
                );
              },
            ),
          ]),
          _buildSectionTitle('Notification'),
          _buildCard([
            _buildSettingItem(
              icon: Icons.notifications_outlined,
              title: 'Push notifications',
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification updated')),
                  );
                },
              ),
            ),
            _buildSettingItem(
              icon: Icons.email_outlined,
              title: 'Email notifications',
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email notification updated')),
                  );
                },
              ),
            ),
          ]),
          _buildSectionTitle('Privacy'),
          _buildCard([
            _buildSettingItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy options',
              subTitle: 'Only visible to myself',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacySettingsPage()),
                );
              },
            ),
          ]),
          _buildSectionTitle('General'),
          _buildCard([
            _buildSettingItem(
              icon: Icons.language_rounded,
              title: 'Language',
              subTitle: 'Simplified Chinese',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LanguageSettingsPage()),
                );
              },
            ),
            _buildSettingItem(
              icon: Icons.help_outline_rounded,
              title: 'Help center',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HelpCenterPage()),
                );
              },
            ),
            _buildSettingItem(
              icon: Icons.info_outline_rounded,
              title: 'About us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 22),
            child: ElevatedButton(
              onPressed: () {
                _showLogoutConfirmation(context, authProvider);
              },
              child: const Text('Log out'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 14, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF72807D),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subTitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  if (subTitle != null)
                    Text(
                      subTitle,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF83908D)),
                    ),
                ],
              ),
            ),
            trailing ??
                const Icon(Icons.chevron_right_rounded,
                    color: Color(0xFF9BA7A5)),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(
      BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              if (!context.mounted) return;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Log out'),
          )
        ],
      ),
    );
  }
}
