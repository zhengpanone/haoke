import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/models/profile/profile_models.dart';
import 'package:haoke_app/services/api_service.dart';
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
              itemBuilder: (context, index) => _OrderCard(item: orders[index]),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final HouseOrderModel item;

  const _OrderCard({required this.item});

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => _showTip(context, '订单金额 ¥${item.amount}'),
                  child: const Text('查看详情'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showTip(context, '${item.actionText}已提交'),
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

void _showTip(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
