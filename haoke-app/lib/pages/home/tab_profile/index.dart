import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/info/info.dart';
import 'package:haoke_rent/pages/home/tab_profile/advertisement.dart';
import 'package:haoke_rent/pages/home/tab_profile/function_button.dart';
import 'package:haoke_rent/pages/home/tab_profile/header.dart';

import '../../settings/index.dart';

class TabProfile extends StatelessWidget {
  const TabProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: ListView(
        children: const [
          Header(),
          FunctionButton(),
          Advertisement(),
          Info(showTitle: true),
        ],
      ),
    );
  }
}
