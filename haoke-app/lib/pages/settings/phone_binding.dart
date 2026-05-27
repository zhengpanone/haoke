import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
import 'package:haoke_rent/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class PhoneBindingPage extends StatefulWidget {
  const PhoneBindingPage({super.key});

  @override
  State<PhoneBindingPage> createState() => _PhoneBindingPageState();
}

class _PhoneBindingPageState extends State<PhoneBindingPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _codeSent = false;
  int _countdown = 60;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentPhone = authProvider.currentUser?.phone;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('phone_binding_title'))),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: currentPhone != null && currentPhone.isNotEmpty
            ? _buildBoundPhone(currentPhone)
            : _buildBindForm(),
      ),
    );
  }

  Widget _buildBoundPhone(String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr('current_bound_phone'),
            style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(phone,
            style: const TextStyle(
                fontSize: 22,
                color: Color(0xFF0F8F7A),
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Text(context.tr('unbind_phone_tip'),
            style: const TextStyle(color: Color(0xFF7D8C89))),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton(
            onPressed: _isLoading ? null : _unbindPhone,
            child: _isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(context.tr('unbind_phone')),
          ),
        )
      ],
    );
  }

  Widget _buildBindForm() {
    return ListView(
      children: [
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
              labelText: context.tr('phone_number'),
              prefixIcon: const Icon(Icons.phone_rounded)),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _codeController,
          decoration: InputDecoration(
            labelText: context.tr('verification_code'),
            prefixIcon: const Icon(Icons.sms_rounded),
            suffixIcon: TextButton(
              onPressed: _codeSent && _countdown > 0 ? null : _sendCode,
              child: Text(_codeSent && _countdown > 0
                  ? '${_countdown}s'
                  : context.tr('get_code')),
            ),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 46,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _bindPhone,
            child: _isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text(context.tr('bind_phone')),
          ),
        ),
      ],
    );
  }

  Future<void> _sendCode() async {
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(_phoneController.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.tr('invalid_phone'))));
      return;
    }

    setState(() {
      _isLoading = true;
      _codeSent = true;
      _countdown = 60;
    });

    try {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.tr('code_sent'))));
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          if (_countdown <= 1) {
            timer.cancel();
            _codeSent = false;
            _countdown = 60;
          } else {
            _countdown--;
          }
        });
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _bindPhone() async {
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(_phoneController.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.tr('invalid_phone'))));
      return;
    }

    if (_codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('input_verification_code'))));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final success = _codeController.text.trim().isNotEmpty;
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.tr('phone_bind_success'))));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.tr('bind_failed'))));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _unbindPhone() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.unbindPhone();
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.tr('phone_unbind_success'))));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                authProvider.errorMessage ?? context.tr('unbind_failed'))));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
