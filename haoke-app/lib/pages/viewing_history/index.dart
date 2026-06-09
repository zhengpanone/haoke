import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/models/profile/profile_models.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/widgets/profile_feature_widgets.dart';

class ViewingHistoryPage extends StatefulWidget {
  const ViewingHistoryPage({super.key});

  @override
  State<ViewingHistoryPage> createState() => _ViewingHistoryPageState();
}

class _ViewingHistoryPageState extends State<ViewingHistoryPage> {
  final ApiService _apiService = ApiService();
  late Future<List<ViewingRecordModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<List<ViewingRecordModel>> _loadData() async {
    final response = await _apiService.queryViewingHistory();
    if (response.isSuccess) {
      return response.data ?? <ViewingRecordModel>[];
    }
    throw Exception(response.message.isEmpty ? '看房记录加载失败' : response.message);
  }

  void _reload() {
    setState(() {
      _future = _loadData();
    });
  }

  Future<void> _refresh() async {
    _reload();
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('viewing_history'))),
      body: FutureBuilder<List<ViewingRecordModel>>(
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
          final items = snapshot.data ?? <ViewingRecordModel>[];
          if (items.isEmpty) {
            return const ProfileEmptyView(
              icon: Icons.history_rounded,
              text: '暂无看房记录',
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _ViewingHistoryCard(item: items[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _ViewingHistoryCard extends StatelessWidget {
  final ViewingRecordModel item;

  const _ViewingHistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final contact = [
      item.contactName,
      item.contactPhone,
    ].where((value) => value.isNotEmpty).join(' ');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: profileCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: Color(0xFF1F2B2A),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ProfileStatusBadge(
                text: item.statusText,
                color: statusColor(item.status),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: '地址',
            value: item.address,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.schedule_rounded,
            label: '预约时间',
            value: formatProfileDate(item.appointmentTime),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.person_outline_rounded,
            label: contact.isEmpty ? '备注' : '联系人',
            value: contact.isEmpty ? item.note : contact,
          ),
          if (contact.isNotEmpty && item.note.isNotEmpty) ...[
            const SizedBox(height: 8),
            _InfoRow(icon: Icons.notes_rounded, label: '备注', value: item.note),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: const Color(0xFF7D8B88)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: Color(0xFF7D8B88), fontSize: 13),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF334845),
              fontSize: 13,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
