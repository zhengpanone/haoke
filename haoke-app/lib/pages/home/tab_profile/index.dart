import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
import 'package:haoke_rent/pages/home/info/info.dart';
import 'package:haoke_rent/pages/home/tab_profile/advertisement.dart';
import 'package:haoke_rent/pages/home/tab_profile/function_button.dart';
import 'package:haoke_rent/pages/home/tab_profile/header.dart';
import 'package:haoke_rent/pages/settings/index.dart';

class TabProfile extends StatelessWidget {
  const TabProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('mine')),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1ECE9)),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
              icon:
                  const Icon(Icons.settings_outlined, color: Color(0xFF355553)),
            ),
          ),
        ],
      ),
      body: ListView(
        children: const [
          Header(),
          SizedBox(height: 8),
          FunctionButton(),
          Advertisement(),
          SizedBox(height: 8),
          Info(showTitle: true),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
