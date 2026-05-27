import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
import 'package:haoke_rent/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('change_password_title'))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            TextFormField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: context.tr('current_password'),
                  prefixIcon: const Icon(Icons.lock_outline_rounded)),
              validator: (value) => value == null || value.isEmpty
                  ? context.tr('input_current_password')
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: context.tr('new_password'),
                  prefixIcon: const Icon(Icons.key_rounded)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.tr('input_new_password');
                }
                if (value.length < 6) {
                  return context.tr('password_min_6');
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: context.tr('confirm_new_password'),
                  prefixIcon: const Icon(Icons.verified_user_outlined)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.tr('input_confirm_password');
                }
                if (value != _newPasswordController.text) {
                  return context.tr('password_mismatch');
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(context.tr('update_password')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final success = await Provider.of<AuthProvider>(context, listen: false)
          .changePassword(
        _oldPasswordController.text,
        _newPasswordController.text,
      );

      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.tr('password_updated'))));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(Provider.of<AuthProvider>(context, listen: false)
                      .errorMessage ??
                  context.tr('update_failed'))),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${context.tr('error')}: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
