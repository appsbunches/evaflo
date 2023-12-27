import 'package:entaj/src/app_config.dart';
import 'package:entaj/src/modules/order_details/logic.dart';
import 'package:entaj/src/utils/custom_widget/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/functions.dart';

class GiftWidget extends StatelessWidget {
  const GiftWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailsLogic>(builder: (logic) {
      if (logic.orderModel?.giftCardDetails == null || !AppConfig.giftCartEnable) {
        return const SizedBox();
      }
      return Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(bottom: 0, top: 10),
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
                Flexible(
                    child: CustomText(logic.orderModel?.giftCardDetails?.senderName)),
                const SizedBox(
                  width: 10,
                ),
                CustomText('إلى: '.tr),
                Flexible(
                    child: CustomText(logic.orderModel?.giftCardDetails?.receiverName)),
              ],
            ),
            if (logic.orderModel?.giftCardDetails?.mediaLink?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText('اسم الرابط: '.tr),
                    Expanded(
                      child: CustomText(
                        (logic.orderModel?.giftCardDetails?.mediaLink ?? ''),
                        color: Colors.blue,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: logic.orderModel?.giftCardDetails?.mediaLink ?? ''));
                          showMessage('The link has been copied successfully'.tr, 1);
                        },
                        child: const Icon(Icons.copy))
                  ],
                ),
              ),
            if (logic.orderModel?.giftCardDetails?.giftMessage?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: CustomText('الرسالة: '.tr +
                    (logic.orderModel?.giftCardDetails?.giftMessage ?? '')),
              ),
            const SizedBox(
              height: 8,
            ),
            CustomButtonWidget(
              title: 'معاينة'.tr,
              onClick: () {
                Get.dialog(Dialog(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Stack(
                        children: [
                          PositionedDirectional(
                              start: 0,
                              end: 0,
                              top: 0,
                              bottom: 0,
                              child: CustomImage(
                                url: logic.orderModel?.giftCardDetails?.cardDesign
                                    ?.replaceAll('{\"file\": ', '')
                                    .replaceAll('}', ''),
                                fit: BoxFit.cover,
                              )),
                          PositionedDirectional(
                              start: 0,
                              end: 0,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                color: Colors.white24,
                              )),

                          PositionedDirectional(
                              start: 20,
                              end: 20,
                              top: 0,
                              bottom: 0,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      logic.orderModel?.giftCardDetails?.giftMessage,
                                      textAlign: TextAlign.center,
                                    ),
                                    CustomText(
                                      logic.orderModel?.giftCardDetails?.receiverName,
                                      textAlign: TextAlign.center,
                                    ),
                                    CustomText(
                                      logic.orderModel?.giftCardDetails?.senderName,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )),
                          PositionedDirectional(
                              start: 4,
                              top: 4,
                              child: IconButton(
                                icon: const Icon(CupertinoIcons.multiply_circle),
                                onPressed: () => Get.back(),
                              )),
                        ],
                      ),
                    ),
                  ),
                ));
              },
              widthBorder: true,
              height: 30,
            )
          ],
        ),
      );
    });
  }
}
