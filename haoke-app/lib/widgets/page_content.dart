// 1. 添加material包

import 'package:flutter/material.dart';
import 'package:haoke_rent/routes.dart';
// 2. 编写无状态组件PageContent

class PageContent extends StatelessWidget {
  // 3. 添加final String text属性

  final String name;
  const PageContent({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    // 4. 使用Scaffold组件
    return Scaffold(
      // 4.1. 添加AppBar组件
      appBar: AppBar(title: Text('当前页面:$name')),
      body: ListView(
        children: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.login);
            },
            child: Text(Routes.login),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.home);
            },
            child: Text(Routes.home),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.notFound);
            },
            child: Text(Routes.notFound),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                // '/roomDetail/1001',
                Routes.roomDetail.replaceFirst(':roomId', '1001'),
              );
            },
            child: Text(Routes.roomDetail),
          ),
        ],
      ),
    );
  }
}
