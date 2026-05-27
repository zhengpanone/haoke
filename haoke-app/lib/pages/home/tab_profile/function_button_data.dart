import 'package:flutter/material.dart';

class FunctionButtonItem {
  final IconData icon;
  final String titleKey;
  final Function? onTapHandle;

  FunctionButtonItem(this.icon, this.titleKey, [this.onTapHandle]);
}

void defaultTapHandler(context) {}

final List<FunctionButtonItem> list = [
  FunctionButtonItem(Icons.history_rounded, 'viewing_history'),
  FunctionButtonItem(Icons.receipt_long_rounded, 'my_orders'),
  FunctionButtonItem(Icons.favorite_rounded, 'my_favorites'),
  FunctionButtonItem(Icons.verified_user_rounded, 'identity_verification'),
  FunctionButtonItem(Icons.support_agent_rounded, 'contact_us'),
  FunctionButtonItem(Icons.description_rounded, 'e_contract'),
  FunctionButtonItem(Icons.home_work_rounded, 'house_management', (context) {
    Navigator.of(context).pushNamed('roomManage');
  }),
  FunctionButtonItem(Icons.account_balance_wallet_rounded, 'wallet'),
];
