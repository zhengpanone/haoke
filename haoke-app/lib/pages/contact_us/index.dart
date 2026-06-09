import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/models/profile/profile_models.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';
import 'package:haoke_app/widgets/profile_feature_widgets.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final ApiService _apiService = ApiService();
  late Future<List<ContactChannelModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<List<ContactChannelModel>> _loadData() async {
    final response = await _apiService.queryContactChannels();
    if (response.isSuccess) {
      return response.data ?? <ContactChannelModel>[];
    }
    throw Exception(response.message.isEmpty ? '联系方式加载失败' : response.message);
  }

  void _reload() {
    setState(() {
      _future = _loadData();
    });
  }

  Future<void> _copy(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已复制联系方式')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('contact_us'))),
      body: FutureBuilder<List<ContactChannelModel>>(
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
          final channels = snapshot.data ?? <ContactChannelModel>[];
          return ListView(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5F2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    CommonIconBadge(
                      icon: Icons.support_agent_rounded,
                      boxSize: 50,
                      iconSize: 26,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '好客客服中心',
                            style: TextStyle(
                              color: Color(0xFF0F8F7A),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '为你处理看房、订单、合同与钱包问题',
                            style: TextStyle(
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
              ),
              const SizedBox(height: 12),
              if (channels.isEmpty)
                const ProfileEmptyView(
                  icon: Icons.support_agent_rounded,
                  text: '暂无联系方式',
                )
              else
                ...channels.map(
                  (item) => _ContactTile(
                    icon: _iconFor(item.type),
                    title: item.title,
                    value: item.value,
                    description: item.description,
                    onTap: () => _copy(context, item.value),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'phone':
        return Icons.phone_rounded;
      case 'email':
        return Icons.email_rounded;
      case 'address':
        return Icons.location_on_rounded;
      default:
        return Icons.support_agent_rounded;
    }
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String description;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CommonIconBadge(icon: icon, boxSize: 38, iconSize: 19),
        title: Text(title),
        subtitle: Text(description.isEmpty ? value : '$value\n$description'),
        trailing: const Icon(Icons.copy_rounded, size: 20),
        onTap: onTap,
      ),
    );
  }
}
