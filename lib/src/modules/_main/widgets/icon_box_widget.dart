import 'package:entaj/src/app_config.dart';
import 'package:entaj/src/utils/custom_widget/custom_image.dart';
import 'package:entaj/src/utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';

import '../../../entities/home_screen_model.dart';

class IconBoxWidget extends StatelessWidget {
  final Items infos;

  const IconBoxWidget({Key? key, required this.infos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      margin: const EdgeInsets.symmetric(horizontal: 30,vertical: AppConfig.paddingBetweenWidget),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CustomImage(
            url: infos.icon,
            height: 70,
          ),
          const SizedBox(
            height: 12,
          ),
          CustomText(
            infos.title,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
          CustomText(
            infos.description,
            textAlign: TextAlign.center,
            fontSize: 11,
          ),
        ],
      ),
    );
  }
}
