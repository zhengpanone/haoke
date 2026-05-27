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
  bool _allowSearchByPhone = true;
  bool _friendRecommendation = true;
  bool _dataCollection = true;
  bool _analytics = true;
  bool _adPersonalization = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        actions: [
          TextButton(onPressed: _saveSettings, child: const Text('Save'))
        ],
      ),
      body: ListView(
        children: [
          _buildSectionTitle('Profile Visibility'),
          _buildSwitchTile(
              'Public profile',
              'Others can view your profile',
              _profilePublic,
              (value) => setState(() => _profilePublic = value)),
          if (_profilePublic) ...[
            _buildSwitchTile('Show phone', 'Display your phone on profile',
                _showPhone, (value) => setState(() => _showPhone = value)),
            _buildSwitchTile('Show email', 'Display your email on profile',
                _showEmail, (value) => setState(() => _showEmail = value)),
          ],
          _buildSectionTitle('Search & Discovery'),
          _buildSwitchTile(
              'Search by phone',
              'Allow others search you by phone',
              _allowSearchByPhone,
              (value) => setState(() => _allowSearchByPhone = value)),
          _buildSwitchTile(
              'Friend recommendation',
              'Recommend your account to contacts',
              _friendRecommendation,
              (value) => setState(() => _friendRecommendation = value)),
          _buildSectionTitle('Data Permission'),
          _buildSwitchTile(
              'Data collection',
              'Improve app experience with usage data',
              _dataCollection,
              (value) => setState(() => _dataCollection = value)),
          _buildSwitchTile('Analytics', 'Allow anonymous data analytics',
              _analytics, (value) => setState(() => _analytics = value)),
          _buildSwitchTile(
              'Ad personalization',
              'Show more relevant ads',
              _adPersonalization,
              (value) => setState(() => _adPersonalization = value)),
          _buildSectionTitle('Privacy Actions'),
          _buildActionTile(Icons.delete_outline_rounded, 'Clear search history',
              _clearSearchHistory),
          _buildActionTile(Icons.delete_sweep_outlined, 'Clear chat records',
              _clearChatHistory),
          _buildActionTile(Icons.person_off_outlined, 'Delete account',
              _showDeleteAccountDialog),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.w700, color: Color(0xFF6D7B78))),
    );
  }

  Widget _buildSwitchTile(
      String title, String subTitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subTitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Privacy settings saved')));
  }

  void _clearSearchHistory() {
    _showConfirmDialog(
      title: 'Clear search history',
      content: 'Are you sure to clear all search history?',
      onConfirm: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Search history cleared'))),
    );
  }

  void _clearChatHistory() {
    _showConfirmDialog(
      title: 'Clear chat records',
      content: 'Are you sure to clear all chat records?',
      onConfirm: () => ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Chat records cleared'))),
    );
  }

  void _showDeleteAccountDialog() {
    _showConfirmDialog(
      title: 'Delete account',
      content: 'This action cannot be undone. Continue?',
      onConfirm: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delete request submitted'))),
    );
  }

  void _showConfirmDialog(
      {required String title,
      required String content,
      required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
