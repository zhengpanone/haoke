import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';

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
        title: Text(context.tr('privacy_settings')),
        actions: [
          TextButton(onPressed: _saveSettings, child: Text(context.tr('save')))
        ],
      ),
      body: ListView(
        children: [
          _buildSectionTitle(context.tr('profile_visibility')),
          _buildSwitchTile(
              context.tr('public_profile'),
              context.tr('others_can_view_profile'),
              _profilePublic,
              (value) => setState(() => _profilePublic = value)),
          if (_profilePublic) ...[
            _buildSwitchTile(
                context.tr('show_phone'),
                context.tr('display_phone_profile'),
                _showPhone,
                (value) => setState(() => _showPhone = value)),
            _buildSwitchTile(
                context.tr('show_email'),
                context.tr('display_email_profile'),
                _showEmail,
                (value) => setState(() => _showEmail = value)),
          ],
          _buildSectionTitle(context.tr('search_discovery')),
          _buildSwitchTile(
              context.tr('search_by_phone'),
              context.tr('allow_search_by_phone'),
              _allowSearchByPhone,
              (value) => setState(() => _allowSearchByPhone = value)),
          _buildSwitchTile(
              context.tr('friend_recommendation'),
              context.tr('recommend_to_contacts'),
              _friendRecommendation,
              (value) => setState(() => _friendRecommendation = value)),
          _buildSectionTitle(context.tr('data_permission')),
          _buildSwitchTile(
              context.tr('data_collection'),
              context.tr('improve_with_usage'),
              _dataCollection,
              (value) => setState(() => _dataCollection = value)),
          _buildSwitchTile(
              context.tr('analytics'),
              context.tr('allow_anonymous_analytics'),
              _analytics,
              (value) => setState(() => _analytics = value)),
          _buildSwitchTile(
              context.tr('ad_personalization'),
              context.tr('relevant_ads'),
              _adPersonalization,
              (value) => setState(() => _adPersonalization = value)),
          _buildSectionTitle(context.tr('privacy_actions')),
          _buildActionTile(Icons.delete_outline_rounded,
              context.tr('clear_search_history'), _clearSearchHistory),
          _buildActionTile(Icons.delete_sweep_outlined,
              context.tr('clear_chat_records'), _clearChatHistory),
          _buildActionTile(Icons.person_off_outlined,
              context.tr('delete_account'), _showDeleteAccountDialog),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('privacy_settings_saved'))),
    );
  }

  void _clearSearchHistory() {
    _showConfirmDialog(
      title: context.tr('clear_search_history'),
      content: context.tr('confirm_clear_search_history'),
      onConfirm: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('search_history_cleared')))),
    );
  }

  void _clearChatHistory() {
    _showConfirmDialog(
      title: context.tr('clear_chat_records'),
      content: context.tr('confirm_clear_chat_records'),
      onConfirm: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('chat_records_cleared')))),
    );
  }

  void _showDeleteAccountDialog() {
    _showConfirmDialog(
      title: context.tr('delete_account'),
      content: context.tr('cannot_undo_continue'),
      onConfirm: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('delete_request_submitted')))),
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
              child: Text(context.tr('cancel'))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(context.tr('confirm')),
          ),
        ],
      ),
    );
  }
}
