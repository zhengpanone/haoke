import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
import 'package:haoke_rent/pages/settings/about_us.dart';
import 'package:haoke_rent/pages/settings/change_password.dart';
import 'package:haoke_rent/pages/settings/help_center.dart';
import 'package:haoke_rent/pages/settings/language_setting.dart';
import 'package:haoke_rent/pages/settings/phone_binding.dart';
import 'package:haoke_rent/pages/settings/privacy_settings.dart';
import 'package:haoke_rent/providers/auth_provider.dart';
import 'package:haoke_rent/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final localeCode = context.watch<LocaleProvider>().localeCode;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('settings'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 22),
        children: [
          _buildSectionTitle(context, context.tr('section_account_security')),
          _buildCard([
            _buildSettingItem(
              icon: Icons.lock_outline_rounded,
              title: context.tr('change_password'),
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
              title: context.tr('phone_binding'),
              subTitle:
                  authProvider.currentUser?.phone ?? context.tr('not_bound'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PhoneBindingPage()),
                );
              },
            ),
          ]),
          _buildSectionTitle(context, context.tr('section_notification')),
          _buildCard([
            _buildSettingItem(
              icon: Icons.notifications_outlined,
              title: context.tr('push_notifications'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.tr('notification_updated'))),
                  );
                },
              ),
            ),
            _buildSettingItem(
              icon: Icons.email_outlined,
              title: context.tr('email_notifications'),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(context.tr('email_notification_updated'))),
                  );
                },
              ),
            ),
          ]),
          _buildSectionTitle(context, context.tr('section_privacy')),
          _buildCard([
            _buildSettingItem(
              icon: Icons.privacy_tip_outlined,
              title: context.tr('privacy_options'),
              subTitle: context.tr('visible_only_me'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacySettingsPage()),
                );
              },
            ),
          ]),
          _buildSectionTitle(context, context.tr('section_general')),
          _buildCard([
            _buildSettingItem(
              icon: Icons.language_rounded,
              title: context.tr('language'),
              subTitle: _languageNameByCode(context, localeCode),
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
              title: context.tr('help_center'),
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
              title: context.tr('about_us'),
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
              child: Text(context.tr('logout')),
            ),
          ),
        ],
      ),
    );
  }

  String _languageNameByCode(BuildContext context, String code) {
    switch (code) {
      case 'zh':
        return context.tr('lang_zh');
      case 'en':
      default:
        return context.tr('lang_en');
    }
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

  Widget _buildSectionTitle(BuildContext context, String title) {
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
        title: Text(context.tr('confirm_logout')),
        content: Text(context.tr('confirm_logout_content')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              if (!context.mounted) return;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: Text(context.tr('logout')),
          )
        ],
      ),
    );
  }
}
