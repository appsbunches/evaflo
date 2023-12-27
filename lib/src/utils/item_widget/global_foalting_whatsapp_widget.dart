import 'package:entaj/src/modules/_main/logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../app_config.dart';
import '../../images.dart';

class GlobalFloatingWhatsApp extends StatelessWidget {
  const GlobalFloatingWhatsApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(builder: (logic) {
      if (AppConfig.showWhatsAppRemoteConfig) {
        return FloatingActionButton(
          onPressed: () => logic.goToWhatsApp(),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(70.sp)),
            height: 50.sp,
            width: 50.sp,
            child: Image.asset(
              iconWhatsapp,
              scale: 2,
            ),
          ),
          backgroundColor: Colors.green,
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
