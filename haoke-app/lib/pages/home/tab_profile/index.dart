import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
import 'package:haoke_rent/pages/home/info/info.dart';
import 'package:haoke_rent/pages/home/tab_profile/advertisement.dart';
import 'package:haoke_rent/pages/home/tab_profile/function_button.dart';
import 'package:haoke_rent/pages/home/tab_profile/header.dart';
import 'package:haoke_rent/pages/settings/index.dart';
import 'package:haoke_rent/widgets/common_icon_badge.dart';
import 'package:haoke_rent/widgets/common_refresh_indicator.dart';

class TabProfile extends StatelessWidget {
  const TabProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('mine')),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: const CommonIconBadge(
                icon: Icons.settings_rounded,
                boxSize: 38,
                iconSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: CommonRefreshIndicator(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }
}
