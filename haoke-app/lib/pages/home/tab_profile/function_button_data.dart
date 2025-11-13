import 'package:flutter/widgets.dart';

class FunctionButtonItem {
  final String imageUri;
  final String title;
  final Function? onTapHandle;

  FunctionButtonItem(this.imageUri, this.title, [this.onTapHandle]);
}

void defaultTapHandler(context) {}

final List<FunctionButtonItem> list = [
  FunctionButtonItem('statics/images/profile_identity.png', '看房记录'),
  FunctionButtonItem('statics/images/profile_identity.png', '我的订单'),
  FunctionButtonItem('statics/images/profile_identity.png', '我的收藏'),
  FunctionButtonItem('statics/images/profile_identity.png', '身份认证'),
  FunctionButtonItem('statics/images/profile_message.png', '联系我们'),
  FunctionButtonItem('statics/images/profile_contract.png', '电子合同'),
  FunctionButtonItem('statics/images/profile_house.png', '房屋管理', (context) {
    bool isLogin = true;
    if (isLogin) {
      Navigator.of(context).pushNamed('roomManage');
      return;
    }
    Navigator.pushNamed(context, 'login');
  }),
  FunctionButtonItem('statics/images/profile_wallet.png', '钱包'),
];
