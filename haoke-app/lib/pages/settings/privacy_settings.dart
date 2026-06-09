import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/services/storage_service.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  static const String _keyPrefix = 'privacy_';

  bool _profilePublic = false;
  bool _showPhone = false;
  bool _showEmail = false;
  bool _allowSearchByPhone = true;
  bool _friendRecommendation = true;
  bool _dataCollection = true;
  bool _analytics = true;
  bool _adPersonalization = false;
  bool _isLoading = true;

  final StorageService _storageService = StorageService.instance;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('privacy_settings')),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveSettings,
            child: Text(_isLoading ? context.tr('saving') : context.tr('save')),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildSectionTitle(context.tr('profile_visibility')),
                _buildSwitchTile(
                  context.tr('public_profile'),
                  context.tr('others_can_view_profile'),
                  _profilePublic,
                  (value) => setState(() => _profilePublic = value),
                ),
                if (_profilePublic) ...[
                  _buildSwitchTile(
                    context.tr('show_phone'),
                    context.tr('display_phone_profile'),
                    _showPhone,
                    (value) => setState(() => _showPhone = value),
                  ),
                  _buildSwitchTile(
                    context.tr('show_email'),
                    context.tr('display_email_profile'),
                    _showEmail,
                    (value) => setState(() => _showEmail = value),
                  ),
                ],
                _buildSectionTitle(context.tr('search_discovery')),
                _buildSwitchTile(
                  context.tr('search_by_phone'),
                  context.tr('allow_search_by_phone'),
                  _allowSearchByPhone,
                  (value) => setState(() => _allowSearchByPhone = value),
                ),
                _buildSwitchTile(
                  context.tr('friend_recommendation'),
                  context.tr('recommend_to_contacts'),
                  _friendRecommendation,
                  (value) => setState(() => _friendRecommendation = value),
                ),
                _buildSectionTitle(context.tr('data_permission')),
                _buildSwitchTile(
                  context.tr('data_collection'),
                  context.tr('improve_with_usage'),
                  _dataCollection,
                  (value) => setState(() => _dataCollection = value),
                ),
                _buildSwitchTile(
                  context.tr('analytics'),
                  context.tr('allow_anonymous_analytics'),
                  _analytics,
                  (value) => setState(() => _analytics = value),
                ),
                _buildSwitchTile(
                  context.tr('ad_personalization'),
                  context.tr('relevant_ads'),
                  _adPersonalization,
                  (value) => setState(() => _adPersonalization = value),
                ),
                _buildSectionTitle(context.tr('privacy_actions')),
                _buildActionTile(
                  Icons.history_rounded,
                  context.tr('clear_search_history'),
                  _clearSearchHistory,
                ),
                _buildActionTile(
                  Icons.forum_rounded,
                  context.tr('clear_chat_records'),
                  _clearChatHistory,
                ),
                _buildActionTile(
                  Icons.person_remove_rounded,
                  context.tr('delete_account'),
                  _showDeleteAccountDialog,
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  Future<void> _loadSettings() async {
    final values = await Future.wait([
      _getBool('profile_public', _profilePublic),
      _getBool('show_phone', _showPhone),
      _getBool('show_email', _showEmail),
      _getBool('allow_search_by_phone', _allowSearchByPhone),
      _getBool('friend_recommendation', _friendRecommendation),
      _getBool('data_collection', _dataCollection),
      _getBool('analytics', _analytics),
      _getBool('ad_personalization', _adPersonalization),
    ]);
    if (!mounted) return;
    setState(() {
      _profilePublic = values[0];
      _showPhone = values[1];
      _showEmail = values[2];
      _allowSearchByPhone = values[3];
      _friendRecommendation = values[4];
      _dataCollection = values[5];
      _analytics = values[6];
      _adPersonalization = values[7];
      _isLoading = false;
    });
  }

  Future<bool> _getBool(String key, bool fallback) async {
    return await _storageService.getBool('$_keyPrefix$key') ?? fallback;
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF6D7B78),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subTitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: CommonIconBadge(icon: icon, boxSize: 34, iconSize: 17),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _storageService.setBool('${_keyPrefix}profile_public', _profilePublic),
      _storageService.setBool('${_keyPrefix}show_phone', _showPhone),
      _storageService.setBool('${_keyPrefix}show_email', _showEmail),
      _storageService.setBool(
        '${_keyPrefix}allow_search_by_phone',
        _allowSearchByPhone,
      ),
      _storageService.setBool(
        '${_keyPrefix}friend_recommendation',
        _friendRecommendation,
      ),
      _storageService.setBool('${_keyPrefix}data_collection', _dataCollection),
      _storageService.setBool('${_keyPrefix}analytics', _analytics),
      _storageService.setBool(
        '${_keyPrefix}ad_personalization',
        _adPersonalization,
      ),
    ]);
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('privacy_settings_saved'))),
    );
  }

  void _clearSearchHistory() {
    _showConfirmDialog(
      title: context.tr('clear_search_history'),
      content: context.tr('confirm_clear_search_history'),
      onConfirm: () async {
        await _storageService.deleteString('search_history');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('search_history_cleared'))),
        );
      },
    );
  }

  void _clearChatHistory() {
    _showConfirmDialog(
      title: context.tr('clear_chat_records'),
      content: context.tr('confirm_clear_chat_records'),
      onConfirm: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('chat_records_cleared'))),
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    _showConfirmDialog(
      title: context.tr('delete_account'),
      content: context.tr('cannot_undo_continue'),
      onConfirm: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('delete_request_submitted'))),
        );
      },
    );
  }

  void _showConfirmDialog({
    required String title,
    required String content,
    required Future<void> Function() onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await onConfirm();
            },
            child: Text(context.tr('confirm')),
          ),
        ],
      ),
    );
  }
}
