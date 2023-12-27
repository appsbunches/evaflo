import 'package:entaj/src/colors.dart';
import 'package:entaj/src/modules/order_details/logic.dart';
import 'package:entaj/src/utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackingWidget extends StatelessWidget {
  const TrackingWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailsLogic>(builder: (logic) {
      var tracking = logic.orderModel?.shipping?.method?.tracking;
      if (tracking?.url == null && tracking?.status != 'N/A') {
        return const SizedBox();
      }
      return GestureDetector(
        onTap: tracking?.url != null ? () => logic.trackShipping() : null,
        child: Container(
            decoration: BoxDecoration(
                color: tracking?.url != null ? primaryColor : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(15)),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: CustomText(
              'تتبع الطلب'.tr,
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )),
      );
    });
  }
}
