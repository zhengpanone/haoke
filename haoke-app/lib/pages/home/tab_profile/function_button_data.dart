import 'package:flutter/widgets.dart';

class FunctionButtonItem {
  final String imageUri;
  final String titleKey;
  final Function? onTapHandle;

  FunctionButtonItem(this.imageUri, this.titleKey, [this.onTapHandle]);
}

void defaultTapHandler(context) {}

final List<FunctionButtonItem> list = [
  FunctionButtonItem('statics/images/profile_identity.png', 'viewing_history'),
  FunctionButtonItem('statics/images/profile_identity.png', 'my_orders'),
  FunctionButtonItem('statics/images/profile_identity.png', 'my_favorites'),
  FunctionButtonItem(
      'statics/images/profile_identity.png', 'identity_verification'),
  FunctionButtonItem('statics/images/profile_message.png', 'contact_us'),
  FunctionButtonItem('statics/images/profile_contract.png', 'e_contract'),
  FunctionButtonItem('statics/images/profile_house.png', 'house_management',
      (context) {
    Navigator.of(context).pushNamed('roomManage');
  }),
  FunctionButtonItem('statics/images/profile_wallet.png', 'wallet'),
];
