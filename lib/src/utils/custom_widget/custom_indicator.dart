import 'package:entaj/src/.env.dart';
import 'package:entaj/src/app_config.dart';
import 'package:flutter/material.dart';

import '../../colors.dart';

class CustomIndicator extends StatelessWidget {
  final bool isActive;

  const CustomIndicator(this.isActive, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (AppConfig.currentThemeId == asayelThemeId) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: 12,
        width: isActive ? 24 : 12,
        decoration: BoxDecoration(
          color: isActive ? greenLightColor : primaryColor.withOpacity(0.4),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
      );
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 7,
      width: isActive ? 30 : 7,
      decoration: BoxDecoration(
        color: isActive ? greenLightColor : Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
