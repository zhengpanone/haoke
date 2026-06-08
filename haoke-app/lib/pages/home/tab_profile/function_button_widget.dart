import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/pages/home/tab_profile/function_button_data.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';

class FunctionButtonWidget extends StatelessWidget {
  final FunctionButtonItem data;

  const FunctionButtonWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: data.onTapHandle == null
          ? null
          : () {
              data.onTapHandle!(context);
            },
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonIconBadge(
              icon: data.icon,
              boxSize: 52,
              iconSize: 28,
              radius: 14,
            ),
            const SizedBox(height: 8),
            Text(
              context.tr(data.titleKey),
              style: const TextStyle(
                color: Color(0xFF334845),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
