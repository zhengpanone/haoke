import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/info/info.dart';
import 'package:haoke_rent/pages/home/tab_profile/advertisement.dart';
import 'package:haoke_rent/pages/home/tab_profile/function_button.dart';
import 'package:haoke_rent/pages/home/tab_profile/header.dart';

class TabProfile extends StatelessWidget {
  const TabProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('settings');
            },
            icon: Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: ListView(
        children: [
          Header(),
          FunctionButton(),
          Advertisement(),
          Info(showTitle: true),
        ],
      ),
    );
  }
}
