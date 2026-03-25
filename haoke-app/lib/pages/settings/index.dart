import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/settings/about_us.dart';
import 'package:haoke_rent/pages/settings/change_password.dart';
import 'package:haoke_rent/pages/settings/help_center.dart';
import 'package:haoke_rent/pages/settings/language_setting.dart';
import 'package:haoke_rent/pages/settings/phone_binding.dart';
import 'package:haoke_rent/pages/settings/privacy_settings.dart';
import 'package:haoke_rent/providers/auth_provider.dart';
import 'package:haoke_rent/utils/common_toast.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // 帐号安全组
          _buildSectionTitle('账户与安全'),
          _buildSettingItem(
              icon: Icons.lock,
              title: '修改密码',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()),
                );
              }),
          _buildSettingItem(
            icon: Icons.security,
            title: '手机号绑定',
            subTitle: authProvider.currentUser?.phone ?? '未绑定',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PhoneBindingPage()),
              );
            },
          ),
          // 通知设置组
          _buildSectionTitle('通知设置'),
          _buildSettingItem(
            icon: Icons.notifications,
            title: '消息通知',
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // 保存通知设置
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('通知设置已更新')),
                );
              },
              activeColor: Colors.red,
            ),
          ),
          _buildSettingItem(
            icon: Icons.email,
            title: '邮件通知',
            trailing: Switch(
              value: false,
              onChanged: (value) {
                // 保存邮件设置
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('邮件通知设置已更新')),
                );
              },
              activeColor: Colors.red,
            ),
          ),
          // 隐私设置组
          _buildSectionTitle('隐私设置'),
          _buildSettingItem(
            icon: Icons.privacy_tip,
            title: '个人资料可见性',
            subTitle: '仅自己可见',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PrivacySettingsPage()),
              );
            },
          ),
          // 其他设置组
          _buildSectionTitle('其他'),
          _buildSettingItem(
            icon: Icons.language,
            title: '语言设置',
            subTitle: '简体中文',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LanguageSettingsPage()),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.help_outline,
            title: '帮助中心',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpCenterPage()),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: '关于我们',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),
          // 退出登录按钮
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutConfirmation(context, authProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('退出登录',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              )),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.red,
              size: 24,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  if (subTitle != null)
                    Text(
                      subTitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
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
              title: const Text('确认退出登录'),
              content: const Text('你确定要退出登录吗？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await authProvider.logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  child:
                      const Text('退出登录', style: TextStyle(color: Colors.red)),
                )
              ],
            ));
  }
}
