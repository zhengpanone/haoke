import 'package:flutter/material.dart';
import 'package:haoke_app/routes.dart';

typedef FunctionButtonTapHandler = void Function(BuildContext context);

class FunctionButtonItem {
  final IconData icon;
  final String titleKey;
  final FunctionButtonTapHandler? onTapHandle;

  FunctionButtonItem(this.icon, this.titleKey, [this.onTapHandle]);
}

void defaultTapHandler(BuildContext context) {}

final List<FunctionButtonItem> list = [
  FunctionButtonItem(Icons.history_rounded, 'viewing_history', (context) {
    Navigator.of(context).pushNamed(Routes.viewingHistory);
  }),
  FunctionButtonItem(Icons.receipt_long_rounded, 'my_orders', (context) {
    Navigator.of(context).pushNamed(Routes.myOrders);
  }),
  FunctionButtonItem(Icons.favorite_rounded, 'my_favorites', (context) {
    Navigator.of(context).pushNamed(Routes.myFavorites);
  }),
  FunctionButtonItem(Icons.verified_user_rounded, 'identity_verification', (
    context,
  ) {
    Navigator.of(context).pushNamed(Routes.identityVerification);
  }),
  FunctionButtonItem(Icons.support_agent_rounded, 'contact_us', (context) {
    Navigator.of(context).pushNamed(Routes.contactUs);
  }),
  FunctionButtonItem(Icons.description_rounded, 'e_contract', (context) {
    Navigator.of(context).pushNamed(Routes.eContract);
  }),
  FunctionButtonItem(Icons.home_work_rounded, 'house_management', (context) {
    Navigator.of(context).pushNamed(Routes.roomManage);
  }),
  FunctionButtonItem(Icons.account_balance_wallet_rounded, 'wallet', (context) {
    Navigator.of(context).pushNamed(Routes.wallet);
  }),
];
