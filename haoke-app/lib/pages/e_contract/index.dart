import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/models/profile/profile_models.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';
import 'package:haoke_app/widgets/profile_feature_widgets.dart';

class EContractPage extends StatefulWidget {
  const EContractPage({super.key});

  @override
  State<EContractPage> createState() => _EContractPageState();
}

class _EContractPageState extends State<EContractPage> {
  final ApiService _apiService = ApiService();
  late Future<List<HouseContractModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<List<HouseContractModel>> _loadData() async {
    final response = await _apiService.queryContracts();
    if (response.isSuccess) {
      return response.data ?? <HouseContractModel>[];
    }
    throw Exception(response.message.isEmpty ? '合同加载失败' : response.message);
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

  Future<void> _signContract(HouseContractModel item) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final response = await _apiService.signContract(item.id);
      if (!mounted) return;
      if (response.isSuccess) {
        messenger.showSnackBar(const SnackBar(content: Text('合同签署成功')));
        _reload();
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text(response.message.isEmpty ? '签署失败' : response.message),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('签署失败：$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('e_contract'))),
      body: FutureBuilder<List<HouseContractModel>>(
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
          final contracts = snapshot.data ?? <HouseContractModel>[];
          if (contracts.isEmpty) {
            return const ProfileEmptyView(
              icon: Icons.description_rounded,
              text: '暂无电子合同',
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
              itemCount: contracts.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _ContractCard(item: contracts[index], onSign: _signContract),
            ),
          );
        },
      ),
    );
  }
}

class _ContractCard extends StatelessWidget {
  final HouseContractModel item;
  final Future<void> Function(HouseContractModel item) onSign;

  const _ContractCard({required this.item, required this.onSign});

  @override
  Widget build(BuildContext context) {
    final period =
        '${formatProfileDate(item.periodStart, dateOnly: true)} 至 ${formatProfileDate(item.periodEnd, dateOnly: true)}';
    final pendingSign = item.status == 'PENDING_SIGN';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: profileCardDecoration(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonIconBadge(
                icon: Icons.description_rounded,
                boxSize: 48,
                iconSize: 24,
                backgroundColor: Color(0xFFFFF3E8),
                iconColor: Color(0xFFE26A2C),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Color(0xFF1F2B2A),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      [
                        if (item.contractNo.isNotEmpty)
                          '合同编号 ${item.contractNo}',
                        period,
                      ].join('\n'),
                      style: const TextStyle(
                        color: Color(0xFF7D8B88),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
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
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => item.pdfUrl.isEmpty
                      ? _showTip(context, '合同 PDF 暂未生成')
                      : _openLink(context, item.pdfUrl),
                  child: const Text('下载 PDF'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: pendingSign
                      ? () => onSign(item)
                      : () => _viewContract(context, item),
                  child: Text(pendingSign ? '立即签署' : '查看合同'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showTip(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

Future<void> _openLink(BuildContext context, String url) async {
  await Clipboard.setData(ClipboardData(text: url));
  if (!context.mounted) return;
  _showTip(context, '链接已复制，请在浏览器中打开');
}

void _viewContract(BuildContext context, HouseContractModel item) {
  showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2B2A),
                ),
              ),
              const SizedBox(height: 12),
              _ContractInfoRow(label: '合同编号', value: item.contractNo),
              _ContractInfoRow(label: '合同状态', value: item.statusText),
              _ContractInfoRow(
                label: '租期',
                value:
                    '${formatProfileDate(item.periodStart, dateOnly: true)} 至 ${formatProfileDate(item.periodEnd, dateOnly: true)}',
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: item.signUrl.isEmpty
                      ? null
                      : () {
                          Navigator.of(sheetContext).pop();
                          _openLink(context, item.signUrl);
                        },
                  child: Text(item.signUrl.isEmpty ? '签署文件待生成' : '查看签署文件'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ContractInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _ContractInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF7D8B88), fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(color: Color(0xFF1F2B2A), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
