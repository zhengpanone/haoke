import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/models/profile/profile_models.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';
import 'package:haoke_app/widgets/profile_feature_widgets.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final ApiService _apiService = ApiService();
  late Future<WalletOverviewModel> _future;
  bool _isTrading = false;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<WalletOverviewModel> _loadData() async {
    final response = await _apiService.queryWallet();
    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    throw Exception(response.message.isEmpty ? '钱包加载失败' : response.message);
  }

  void _reload() {
    setState(() {
      _future = _loadData();
    });
  }

  Future<void> _trade(Future<void> Function() action) async {
    setState(() => _isTrading = true);
    try {
      await action();
      _reload();
    } finally {
      if (mounted) {
        setState(() => _isTrading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('wallet'))),
      body: FutureBuilder<WalletOverviewModel>(
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
          final wallet = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              _reload();
              await _future;
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F8F7A),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '账户余额',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '¥ ${wallet.balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '冻结金额 ¥ ${wallet.frozenAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isTrading
                            ? null
                            : () => _trade(() async {
                                final response = await _apiService
                                    .withdrawWallet(100);
                                if (!context.mounted) return;
                                _showTip(
                                  context,
                                  response.isSuccess ? '提现成功' : '提现失败',
                                );
                              }),
                        child: const Text('提现 ¥100'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isTrading
                            ? null
                            : () => _trade(() async {
                                final response = await _apiService
                                    .rechargeWallet(100);
                                if (!context.mounted) return;
                                _showTip(
                                  context,
                                  response.isSuccess ? '充值成功' : '充值失败',
                                );
                              }),
                        child: const Text('充值 ¥100'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (wallet.records.isEmpty)
                  const ProfileEmptyView(
                    icon: Icons.account_balance_wallet_rounded,
                    text: '暂无钱包流水',
                  )
                else
                  ...wallet.records.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _WalletRecordCard(item: item),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WalletRecordCard extends StatelessWidget {
  final WalletRecordModel item;

  const _WalletRecordCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: profileCardDecoration(),
      child: Row(
        children: [
          CommonIconBadge(
            icon: item.income
                ? Icons.keyboard_return_rounded
                : Icons.home_repair_service_rounded,
            boxSize: 42,
            iconSize: 21,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formatProfileDate(item.recordTime),
                  style: const TextStyle(
                    color: Color(0xFF7D8B88),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${item.income ? '+' : '-'}¥${item.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: item.income
                  ? const Color(0xFF0F8F7A)
                  : const Color(0xFF1F2B2A),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

void _showTip(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
