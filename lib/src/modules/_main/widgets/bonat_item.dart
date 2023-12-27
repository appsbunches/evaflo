import 'package:entaj/src/data/shared_preferences/pref_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../colors.dart';
import '../../../images.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../_auth/login/view.dart';
import '../logic.dart';

class BonatItem extends StatelessWidget {
  final bool showText;

  const BonatItem({
    this.showText = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          if (!await Get.find<PrefManger>().getIsLogin()) {
            Get.to(LoginPage())?.then((value) {
              if (value == 'success') {
                Future.delayed(const Duration(seconds: 1), () async {
                  Get.find<MainLogic>().bonatUrl = null;
                  Get.find<MainLogic>().loadBonat();
                  Get.find<MainLogic>().openBonat();
                });
              }
            });
            return;
          }
          Get.find<MainLogic>().openBonat();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: yalowColor, borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Image.asset(iconBonat, scale: 2.3, color: headerForegroundColor),
                  if (showText) const SizedBox(width: 4),
                  if (showText)
                    CustomText(
                      'نقاطي'.tr,
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )
                ],
              ),
            ),
          ],
        ));
  }
}
