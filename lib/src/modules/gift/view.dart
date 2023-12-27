import 'dart:convert';
import 'dart:developer';

import 'package:entaj/src/modules/_main/logic.dart';
import 'package:entaj/src/modules/cart/logic.dart';
import 'package:entaj/src/utils/custom_widget/custom_button_widget.dart';
import 'package:entaj/src/utils/custom_widget/custom_image.dart';
import 'package:entaj/src/utils/custom_widget/custom_text.dart';
import 'package:entaj/src/utils/validation/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../colors.dart';
import 'logic.dart';

class GiftPage extends StatelessWidget {
  GiftPage({Key? key}) : super(key: key);

  final logic = Get.put(GiftLogic());
  final cartLogic = Get.find<CartLogic>();
  final mainLogic = Get.find<MainLogic>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    logic.handleFields(cartLogic.cartModel?.giftCardDetails);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText(
          cartLogic.cartModel?.giftCardDetails == null
              ? "أرسلها كهدية".tr
              : 'تم اضافة الطلب كهدية'.tr,
          fontSize: 16,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: CustomText(
                        'المنتجات سيتم تغليفها كهدية مع بطاقة اهداء'.tr,
                        height: 1,
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: CustomText(
                              'ستصلك الفاتورة على البريد الإلكتروني ولن ترفق مع الطلب'.tr,
                              height: 1)),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: logic.nameController,
                    //validator: Validation.fieldValidate,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'اسم مرسل الهدية'.tr,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: logic.receiverNameController,
                    //validator: Validation.fieldValidate,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'اسم مستلم الهدية'.tr,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                  ),
                  if (mainLogic.settingModel?.settings?.giftOrderSettingsModel
                          ?.isGiftOrderCardSenderCustomMediaLinkEnabled ==
                      '1')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextFormField(
                        controller: logic.urlController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'ارفاق رابط (صورة أو فيديو)'.tr,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                      ),
                    ),
                  if (mainLogic.settingModel?.settings?.giftOrderSettingsModel
                          ?.isGiftOrderCardSenderCustomMessageEnabled ==
                      '1')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextFormField(
                        controller: logic.messageController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'ارفاق رسالة'.tr,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                        maxLines: 6,
                      ),
                    ),
                  GetBuilder<GiftLogic>(
                      id: 'files',
                      builder: (logic) {
                        if (!(logic.list?.isNotEmpty == true)) return const SizedBox();
                        if (mainLogic.settingModel?.settings?.giftOrderSettingsModel
                                ?.isGiftOrderCardCustomTemplateEnabled !=
                            '1') return const SizedBox();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            CustomText(
                              'تصميم البطاقة'.tr,
                              fontWeight: FontWeight.bold,
                              height: 1,
                              fontSize: 14,
                            ),
                            Wrap(
                              children: logic.list
                                      ?.map((e) => GestureDetector(
                                            onTap: () => logic.onChangeFile(e['file']),
                                            child: Container(
                                              child: CustomText(
                                                e['name'],
                                                color: logic.selectedFile == e['file']
                                                    ? Colors.white
                                                    : primaryColor,
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 2),
                                              margin: const EdgeInsetsDirectional.only(
                                                  top: 10, end: 10),
                                              decoration: BoxDecoration(
                                                  color: logic.selectedFile == e['file']
                                                      ? primaryColor
                                                      : Colors.white,
                                                  border: Border.all(color: primaryColor),
                                                  borderRadius: BorderRadius.circular(8)),
                                            ),
                                          ))
                                      .toList() ??
                                  [],
                            ),
                          ],
                        );
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButtonWidget(
                      title: 'معاينة'.tr,
                      onClick: () {
                        /*  if (!_formKey.currentState!.validate()) {
                          return;
                        }*/
                        Get.dialog(buildDialog());
                      },
                      widthBorder: true,
                      height: 30.h,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: GetBuilder<GiftLogic>(
                          id: 'save',
                          builder: (logic) {
                            return CustomButtonWidget(
                              title: cartLogic.cartModel?.giftCardDetails == null
                                  ? 'حفظ'.tr
                                  : 'تعديل'.tr,
                              loading: logic.isLoading,
                              onClick: () {
                               /* if (!_formKey.currentState!.validate()) {
                                  return;
                                }*/
                                logic.saveGift();
                              },
                              height: 30.h,
                            );
                          })),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Dialog buildDialog() {
    return Dialog(
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
                    url: logic.selectedFile,
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
                  start: 4,
                  top: 4,
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.multiply_circle),
                    onPressed: () => Get.back(),
                  )),
              PositionedDirectional(
                  start: 20,
                  end: 20,
                  top: 0,
                  bottom: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        logic.messageController.text,
                        textAlign: TextAlign.center,
                      ),
                      CustomText(
                        logic.receiverNameController.text,
                        textAlign: TextAlign.center,
                      ),
                      CustomText(
                        logic.nameController.text,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
