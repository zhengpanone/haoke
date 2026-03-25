import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haoke_rent/providers/auth_provider.dart';
import 'package:provider/provider.dart';
/// 手机号绑定页面
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

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentPhone = authProvider.currentUser?.phone;
    return Scaffold(
      appBar: AppBar(
        title: const Text('手机号绑定'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentPhone != null && currentPhone.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '当前绑定手机号',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    currentPhone,
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    '如需更换手机号,请先解绑当前手机号',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _unbindPhone,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.red,
                            )
                          : const Text(
                              '解绑手机号',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  )
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: '手机号码',
                      prefixIcon: Icon(Icons.phone, color: Colors.red),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入手机号码';
                      }
                      if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
                        return '请输入有效的手机号码';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            labelText: '验证码',
                            prefixIcon:
                                const Icon(Icons.sms, color: Colors.red),
                            suffixIcon: _codeSent
                                ? TextButton(
                                    onPressed:
                                        _countdown > 0 ? null : _sendCode,
                                    child: Text(
                                      _countdown > 0 ? '$_countdown秒' : '获取验证码',
                                      style: TextStyle(
                                        color: _countdown > 0
                                            ? Colors.grey
                                            : Colors.red,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入验证码';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _bindPhone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('绑定手机号', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Future<void> _sendCode() async {
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(_phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的手机号码')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _codeSent = true;
    });

    try {
      // 这里应该调用API发送验证码
      // await Provider.of<AuthProvider>(context, listen: false).sendSmsCode(_phoneController.text);

      // 模拟发送成功
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('验证码已发送')),
      );

      // 开始倒计时
      _startCountdown();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送失败: $e')),
      );
      setState(() {
        _codeSent = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startCountdown() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_countdown < 1) {
          timer.cancel();
          _countdown = 60;
          _codeSent = false;
        } else {
          _countdown--;
        }
      });
    });
  }

  Future<void> _bindPhone() async {
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(_phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的手机号码')),
      );
      return;
    }

    if (_codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入验证码')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 这里应该调用API绑定手机号
      // final success = await Provider.of<AuthProvider>(context, listen: false)
      //     .bindPhone(_phoneController.text, _codeController.text);

      // 模拟绑定成功
      final success = true;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('手机号绑定成功')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(Provider.of<AuthProvider>(context, listen: false)
                      .errorMessage ??
                  '绑定失败')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发生错误: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _unbindPhone() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.unbindPhone();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('手机号解绑成功')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authProvider.errorMessage ?? '解绑失败')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('发生错误：$e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
