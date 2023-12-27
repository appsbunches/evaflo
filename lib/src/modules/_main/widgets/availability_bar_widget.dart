import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../colors.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../logic.dart';

class AvailabilityBarWidget extends StatelessWidget {
  const AvailabilityBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(
        init: Get.find<MainLogic>(),
        builder: (logic) {
          return (logic.settingModel?.settings?.availability?.closedNow == true &&
                  logic.settingModel?.settings?.availability?.isStoreClosed == true)
              ? Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: headerBackgroundColor,
                  ),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: CustomText(
                        (logic.settingModel?.settings?.availability?.message?.ar
                                    ?.replaceAll('\n', ' ') ??
                                '') +
                            ' أضف المنتجات التي ترغب بشرائها في السلة واتمم عملية الشراء في وقت لاحق.'.tr,
                        fontWeight: FontWeight.bold,
                        color: headerForegroundColor,
                        fontSize: 11,
                      )),
                    ],
                  ),
                )
              : const SizedBox();
        });
  }
}
