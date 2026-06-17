import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/models/profile/profile_models.dart';
import 'package:haoke_app/pages/e_contract/index.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/utils/ui_utils.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';
import 'package:haoke_app/widgets/profile_feature_widgets.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final ApiService _apiService = ApiService();
  late Future<List<HouseOrderModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<List<HouseOrderModel>> _loadData() async {
    final response = await _apiService.queryMyOrders();
    if (response.isSuccess) {
      return response.data ?? <HouseOrderModel>[];
    }
    throw Exception(response.message.isEmpty ? '订单加载失败' : response.message);
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

  Future<void> _signOrderContract(HouseOrderModel item) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      // TODO: 后端应提供 /api/contract/by-order/{orderId} 接口避免拉取全量列表
      final contractsResponse = await _apiService.queryContracts(pageSize: 100);
      if (!mounted) return;
      if (!contractsResponse.isSuccess) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              contractsResponse.message.isEmpty
                  ? '合同加载失败'
                  : contractsResponse.message,
            ),
          ),
        );
        return;
      }

      final contract = (contractsResponse.data ?? <HouseContractModel>[])
          .where((contract) => contract.orderId == item.id)
          .cast<HouseContractModel?>()
          .firstWhere((contract) => contract != null, orElse: () => null);
      if (contract == null) {
        messenger.showSnackBar(const SnackBar(content: Text('未找到待签署合同')));
        return;
      }

      final signResponse = await _apiService.signContract(contract.id);
      if (!mounted) return;
      if (signResponse.isSuccess) {
        messenger.showSnackBar(const SnackBar(content: Text('合同签署成功')));
        _reload();
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              signResponse.message.isEmpty ? '签署失败' : signResponse.message,
            ),
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
      appBar: AppBar(title: Text(context.tr('my_orders'))),
      body: FutureBuilder<List<HouseOrderModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('加载中'));
          }
          if (snapshot.hasError) {
            return ProfileErrorView(
              text: '${snapshot.error}',
              onRetry: _reload,
            );
          }
          final orders = snapshot.data ?? <HouseOrderModel>[];
          if (orders.isEmpty) {
            return const ProfileEmptyView(
              icon: Icons.receipt_long_rounded,
              text: '暂无订单',
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _OrderCard(item: orders[index], onSign: _signOrderContract),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final HouseOrderModel item;
  final Future<void> Function(HouseOrderModel item) onSign;

  const _OrderCard({required this.item, required this.onSign});

  @override
  Widget build(BuildContext context) {
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
                icon: Icons.receipt_long_rounded,
                boxSize: 48,
                iconSize: 24,
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
                        if (item.orderNo.isNotEmpty) '订单号 ${item.orderNo}',
                        if (item.address.isNotEmpty) item.address,
                        if (item.orderTime != null)
                          '下单时间 ${formatProfileDate(item.orderTime)}',
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
                  onPressed: () => _showOrderDetail(context, item),
                  child: const Text('查看详情'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: pendingSign
                      ? () => onSign(item)
                      : () => showSnackBarTip(context, '${item.actionText}已提交'),
                  child: Text(item.actionText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showOrderDetail(BuildContext context, HouseOrderModel item) {
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
              _OrderInfoRow(label: '订单号', value: item.orderNo),
              _OrderInfoRow(label: '订单状态', value: item.statusText),
              _OrderInfoRow(label: '订单金额', value: '¥${item.amount}'),
              if (item.address.isNotEmpty)
                _OrderInfoRow(label: '地址', value: item.address),
              if (item.orderTime != null)
                _OrderInfoRow(
                  label: '下单时间',
                  value: formatProfileDate(item.orderTime),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const EContractPage()),
                    );
                  },
                  child: const Text('查看电子合同'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _OrderInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _OrderInfoRow({required this.label, required this.value});

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
