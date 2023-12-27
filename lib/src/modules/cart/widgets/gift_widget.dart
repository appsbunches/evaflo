import 'package:entaj/src/app_config.dart';
import 'package:entaj/src/utils/custom_widget/custom_image.dart';
import 'package:entaj/src/utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../logic.dart';

class GiftWidget extends StatelessWidget {
  const GiftWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartLogic>(builder: (logic) {
      if (logic.cartModel?.giftCardDetails == null || !AppConfig.giftCartEnable) {
        return const SizedBox();
      }
      return Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.wallet_giftcard,
                  size: 20,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                    child: CustomText(
                  'سيتم ارسال هذه المنتجات كهدية'.tr,
                  fontWeight: FontWeight.bold,
                ))
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText('من: '.tr),
                Flexible(child: CustomText(logic.cartModel?.giftCardDetails?.senderName)),
                const SizedBox(
                  width: 10,
                ),
                CustomText('إلى: '.tr),
                Flexible(
                    child: CustomText(logic.cartModel?.giftCardDetails?.receiverName)),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            CustomText(
                'الرسالة: '.tr + (logic.cartModel?.giftCardDetails?.giftMessage ?? '')),
          ],
        ),
      );
    });
  }
}
