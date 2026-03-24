import 'package:flutter/material.dart';
import 'package:haoke_rent/utils/common_toast.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          const Padding(padding: EdgeInsets.only(top: 20, left: 10, right: 10)),
          ElevatedButton(
            onPressed: () {
              CommonToast.showToast('已退出登录！');
            },
            child: const Text('退出登录', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
