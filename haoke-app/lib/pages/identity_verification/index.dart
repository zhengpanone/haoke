import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/models/profile/profile_models.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';
import 'package:haoke_app/widgets/profile_feature_widgets.dart';

class IdentityVerificationPage extends StatefulWidget {
  const IdentityVerificationPage({super.key});

  @override
  State<IdentityVerificationPage> createState() =>
      _IdentityVerificationPageState();
}

class _IdentityVerificationPageState extends State<IdentityVerificationPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  late Future<IdentityVerificationModel> _future;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idCardController.dispose();
    super.dispose();
  }

  Future<IdentityVerificationModel> _loadData() async {
    final response = await _apiService.getIdentityVerification();
    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    throw Exception(response.message.isEmpty ? '认证状态加载失败' : response.message);
  }

  void _reload() {
    setState(() {
      _future = _loadData();
    });
  }

  Future<void> _submit() async {
    final realName = _nameController.text.trim();
    final idCardNo = _idCardController.text.trim();
    if (realName.isEmpty || idCardNo.length < 8) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入姓名和有效证件号')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final response = await _apiService.submitIdentityVerification(
        realName: realName,
        idCardNo: idCardNo,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.isSuccess ? '认证资料已提交' : '提交失败')),
      );
      _reload();
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('identity_verification'))),
      body: FutureBuilder<IdentityVerificationModel>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ProfileErrorView(
              text: '${snapshot.error}',
              onRetry: _reload,
            );
          }
          final data = snapshot.data!;
          if (_nameController.text.isEmpty && data.realName.isNotEmpty) {
            _nameController.text = data.realName;
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
            children: [
              _StatusPanel(data: data),
              const SizedBox(height: 12),
              const _StepTile(
                index: 1,
                title: '填写实名信息',
                subtitle: '请填写本人真实姓名和有效身份证件号码',
                done: true,
              ),
              _StepTile(
                index: 2,
                title: '平台审核',
                subtitle: '提交后通常 1 个工作日内完成审核',
                done: data.status == 'REVIEWING' || data.status == 'VERIFIED',
              ),
              _StepTile(
                index: 3,
                title: '认证完成',
                subtitle: '通过后可签署合同、申请订单和使用钱包服务',
                done: data.status == 'VERIFIED',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '真实姓名'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _idCardController,
                decoration: const InputDecoration(labelText: '身份证号'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.verified_user_rounded),
                  label: Text(_isSubmitting ? '提交中' : '提交认证'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  final IdentityVerificationModel data;

  const _StatusPanel({required this.data});

  @override
  Widget build(BuildContext context) {
    final color = statusColor(data.status);
    final subtitle = data.idCardNo.isEmpty
        ? '完成认证后可签署合同、申请租房订单和使用钱包服务'
        : '证件号 ${data.idCardNo}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CommonIconBadge(
            icon: Icons.verified_user_rounded,
            boxSize: 50,
            iconSize: 26,
            iconColor: color,
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.statusText,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF4C5F5C),
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final bool done;

  const _StepTile({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: done
                ? const Color(0xFFEAF5F2)
                : const Color(0xFFF1F3F3),
            child: done
                ? const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF0F8F7A),
                    size: 20,
                  )
                : Text(
                    '$index',
                    style: const TextStyle(
                      color: Color(0xFF7D8B88),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1F2B2A),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF7D8B88),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
