import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _profilePublic = false;
  bool _showPhone = false;
  bool _showEmail = false;
  bool _showRealName = false;
  bool _allowSearchByPhone = true;
  bool _allowFriendRecommendation = true;
  bool _dataCollection = true;
  bool _analytics = true;
  bool _adPersonalization = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('隐私设置'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text(
              '保存',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // 个人资料可见性
          _buildSectionTitle('个人资料可见性'),
          SwitchListTile(
            title: const Text('公开个人资料'),
            subtitle: const Text('其他用户可以查看您的个人资料'),
            value: _profilePublic,
            onChanged: (value) {
              setState(() {
                _profilePublic = value;
              });
            },
            activeColor: Colors.red,
          ),

          if (_profilePublic) ...[
            SwitchListTile(
              title: const Text('公开手机号'),
              subtitle: const Text('向其他用户显示您的手机号'),
              value: _showPhone,
              onChanged: (value) {
                setState(() {
                  _showPhone = value;
                });
              },
              activeColor: Colors.red,
            ),
            SwitchListTile(
              title: const Text('公开邮箱'),
              subtitle: const Text('向其他用户显示您的邮箱地址'),
              value: _showEmail,
              onChanged: (value) {
                setState(() {
                  _showEmail = value;
                });
              },
              activeColor: Colors.red,
            ),
            SwitchListTile(
              title: const Text('公开真实姓名'),
              subtitle: const Text('向其他用户显示您的真实姓名'),
              value: _showRealName,
              onChanged: (value) {
                setState(() {
                  _showRealName = value;
                });
              },
              activeColor: Colors.red,
            ),
          ],

          // 搜索与发现
          _buildSectionTitle('搜索与发现'),
          SwitchListTile(
            title: const Text('允许通过手机号搜索'),
            subtitle: const Text('其他用户可以通过手机号搜索到您'),
            value: _allowSearchByPhone,
            onChanged: (value) {
              setState(() {
                _allowSearchByPhone = value;
              });
            },
            activeColor: Colors.red,
          ),
          SwitchListTile(
            title: const Text('朋友推荐'),
            subtitle: const Text('向通讯录好友推荐您的账号'),
            value: _allowFriendRecommendation,
            onChanged: (value) {
              setState(() {
                _allowFriendRecommendation = value;
              });
            },
            activeColor: Colors.red,
          ),

          // 数据与权限
          _buildSectionTitle('数据与权限'),
          SwitchListTile(
            title: const Text('数据收集'),
            subtitle: const Text('允许收集使用数据以改进产品'),
            value: _dataCollection,
            onChanged: (value) {
              setState(() {
                _dataCollection = value;
              });
            },
            activeColor: Colors.red,
          ),
          SwitchListTile(
            title: const Text('数据分析'),
            subtitle: const Text('允许进行匿名数据分析'),
            value: _analytics,
            onChanged: (value) {
              setState(() {
                _analytics = value;
              });
            },
            activeColor: Colors.red,
          ),
          SwitchListTile(
            title: const Text('个性化广告'),
            subtitle: const Text('根据您的兴趣展示相关广告'),
            value: _adPersonalization,
            onChanged: (value) {
              setState(() {
                _adPersonalization = value;
              });
            },
            activeColor: Colors.red,
          ),

          // 隐私操作
          _buildSectionTitle('隐私操作'),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('清除搜索历史'),
            onTap: _clearSearchHistory,
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep, color: Colors.red),
            title: const Text('清除聊天记录'),
            onTap: _clearChatHistory,
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('注销账号'),
            onTap: _showDeleteAccountDialog,
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),

          // 隐私政策链接
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // 查看隐私政策
                      },
                      child: const Text('隐私政策'),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      onPressed: () {
                        // 查看用户协议
                      },
                      child: const Text('用户协议'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 24.0,
        bottom: 8.0,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _saveSettings() {
    // TODO: 保存隐私设置到服务器
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('隐私设置已保存'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearSearchHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清除'),
        content: const Text('确定要清除所有搜索历史记录吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 实现清除搜索历史逻辑
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('搜索历史已清除'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('确定', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _clearChatHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清除'),
        content: const Text('确定要清除所有聊天记录吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 实现清除聊天记录逻辑
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('聊天记录已清除'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('确定', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('注销账号'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('注销账号前请注意：'),
            SizedBox(height: 8),
            Text('• 您的所有数据将被永久删除'),
            Text('• 您将无法登录当前账号'),
            Text('• 此操作不可撤销'),
            SizedBox(height: 16),
            Text('确认要注销账号吗？'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text('确认注销', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    // TODO: 实现账号注销逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('账号注销申请已提交，处理结果将通过邮件通知'),
        backgroundColor: Colors.green,
      ),
    );
  }
}