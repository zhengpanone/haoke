import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haoke_app/config/app_theme.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/models/user/update_user_profile_request.dart';
import 'package:haoke_app/models/user/user_model.dart';
import 'package:haoke_app/providers/auth_provider.dart';
import 'package:haoke_app/utils/image_picker_util.dart';
import 'package:provider/provider.dart';

const _defaultAvatarUrl =
    'https://images.pexels.com/photos/33412303/pexels-photo-33412303.jpeg';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _initialized = false;
  bool _refreshing = false;
  bool _saving = false;
  File? _avatarFile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _fillForm(user);
    }

    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshProfile());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _fillForm(UserModel user) {
    _usernameController.text = user.username;
    _nicknameController.text = user.nickname ?? '';
    _emailController.text = user.email ?? '';
    _phoneController.text = user.phone ?? '';
    _avatarFile = null;
  }

  Future<void> _refreshProfile() async {
    if (!mounted || _refreshing) return;

    setState(() => _refreshing = true);
    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.syncUserInfo(forceRefresh: true);
      final user = authProvider.currentUser;
      if (!mounted) return;

      if (success && user != null) {
        _fillForm(user);
      } else {
        _showMessage(context.tr('profile_refresh_failed'), isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _refreshing = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);
    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.updateUserInfo(
        UpdateUserProfileRequest(
          username: _usernameController.text.trim(),
          nickname: _nullableTrim(_nicknameController.text),
          email: _nullableTrim(_emailController.text),
          phone: _nullableTrim(_phoneController.text),
          avatar: authProvider.currentUser?.avatar,
        ),
        avatarFile: _avatarFile,
      );

      if (!mounted) return;

      if (success) {
        final user = authProvider.currentUser;
        if (user != null) {
          _fillForm(user);
        }
        _showMessage(context.tr('profile_save_success'));
      } else {
        _showMessage(
          authProvider.errorMessage ?? context.tr('profile_save_failed'),
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  String? _nullableTrim(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : AppTheme.brandPrimary,
      ),
    );
  }

  String? _validateUsername(String? value) {
    final username = value?.trim() ?? '';
    if (username.isEmpty) {
      return context.tr('profile_username_required');
    }
    if (!RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(username)) {
      return context.tr('profile_username_invalid');
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return null;
    if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(email)) {
      return context.tr('profile_email_invalid');
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return null;
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(phone)) {
      return context.tr('profile_phone_invalid');
    }
    return null;
  }

  Future<void> _pickAvatar() async {
    final image = await ImagePickerUtil.pickImage();
    if (!mounted) return;

    if (image == null) {
      if (ImagePickerUtil.lastError != null) {
        _showMessage(context.tr('profile_pick_avatar_error'), isError: true);
      }
      return;
    }

    setState(() {
      _avatarFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    if (!authProvider.isLoggedIn || user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.tr('profile_edit_title'))),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 48,
                  color: AppTheme.brandPrimary,
                ),
                const SizedBox(height: 12),
                Text(
                  context.tr('profile_login_required'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4D5F5C),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: 160,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: Text(context.tr('login')),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('profile_edit_title')),
        actions: [
          IconButton(
            tooltip: context.tr('retry'),
            onPressed: _refreshing || _saving ? null : _refreshProfile,
            icon: _refreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
            children: [
              _buildProfileHeader(user),
              const SizedBox(height: 14),
              _buildSectionTitle(context.tr('profile_basic_info')),
              _buildCard(
                children: [
                  _buildTextField(
                    controller: _usernameController,
                    label: context.tr('username'),
                    icon: Icons.person_outline_rounded,
                    validator: _validateUsername,
                    textInputAction: TextInputAction.next,
                  ),
                  _buildTextField(
                    controller: _nicknameController,
                    label: context.tr('profile_nickname'),
                    icon: Icons.badge_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                  _buildTextField(
                    controller: _emailController,
                    label: context.tr('email'),
                    icon: Icons.email_outlined,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  _buildTextField(
                    controller: _phoneController,
                    label: context.tr('phone_number'),
                    icon: Icons.phone_iphone_rounded,
                    validator: _validatePhone,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildSectionTitle(context.tr('profile_account_info')),
              _buildCard(
                children: [
                  _buildReadonlyItem(
                    context.tr('profile_user_id'),
                    user.id,
                    Icons.fingerprint_rounded,
                  ),
                  _buildReadonlyItem(
                    context.tr('profile_created_at'),
                    _formatDateTime(user.createTime),
                    Icons.event_available_rounded,
                  ),
                  _buildReadonlyItem(
                    context.tr('profile_updated_at'),
                    _formatDateTime(user.updateTime),
                    Icons.update_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _saving || _refreshing ? null : _saveProfile,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(
                    _saving ? context.tr('saving') : context.tr('save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    final avatarUrl = user.avatarUrl;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          GestureDetector(
            onTap: _saving || _refreshing ? null : _pickAvatar,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(0xFFE7F5F1),
                  backgroundImage: _avatarFile != null
                      ? FileImage(_avatarFile!)
                      : NetworkImage(avatarUrl ?? _defaultAvatarUrl)
                            as ImageProvider,
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppTheme.brandPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user.email?.isNotEmpty == true
                      ? user.email!
                      : context.tr('profile_email_unset'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF71807D),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _saving || _refreshing ? null : _pickAvatar,
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 2,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: AppTheme.brandPrimary,
                  ),
                  icon: const Icon(Icons.photo_library_rounded, size: 16),
                  label: Text(context.tr('profile_change_avatar')),
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
      padding: const EdgeInsets.only(left: 4, bottom: 8),
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

  Widget _buildCard({required List<Widget> children}) {
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildReadonlyItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.brandPrimary, size: 20),
          const SizedBox(width: 12),
          SizedBox(
            width: 94,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF5A6966),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Color(0xFF2B3836)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime value) {
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    return '${value.year}-${twoDigits(value.month)}-${twoDigits(value.day)} '
        '${twoDigits(value.hour)}:${twoDigits(value.minute)}';
  }
}
