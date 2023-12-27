import 'package:entaj/src/entities/FilterModel.dart';
import 'package:entaj/src/entities/product_details_model.dart';
import 'package:entaj/src/images.dart';
import 'package:entaj/src/utils/custom_widget/custom_image.dart';

import '../../app_config.dart';

import '../../colors.dart';
import 'logic.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_sized_box.dart';
import '../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/functions.dart';

class NewFiltrationDialog extends StatelessWidget {
  final String? categoryId;

  const NewFiltrationDialog({this.categoryId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
      backgroundColor: Colors.grey.shade100,
      onClosing: () {},
      builder: (context) => SizedBox(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.sp),
          child: GetBuilder<CategoryDetailsLogic>(
              tag: categoryId,
              init: Get.find<CategoryDetailsLogic>(tag: categoryId),
              builder: (logic) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15.sp),
                        child: Row(
                          children: [
                            CustomText("تصفية النتائج".tr,
                                fontSize: 16, fontWeight: FontWeight.w900),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(30)),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.close,
                                    size: 17,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                      ),
                      const CustomSizedBox(
                        height: 10,
                      ),
                      ...logic.filterModel?.attributes
                              ?.map((e) => Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          e.name,
                                          fontWeight: FontWeight.w900,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              ...e.data
                                                      ?.map(
                                                          (e) => buildContainer(logic, e))
                                                      .toList() ??
                                                  []
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                              .toList() ??
                          [],
                      Container(
                        padding: EdgeInsets.all(15.sp),
                        child: Row(
                          children: [
                            CustomText("السعر".tr, fontWeight: FontWeight.w900),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: GestureDetector(
                                onTap: () => logic.restPrice(),
                                child: CustomText(
                                  "مسح الفلترة".tr,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: logic.startPriceController,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                textDirection: TextDirection.ltr,
                                onChanged: (s) {
                                  logic.startPriceController.text =
                                      replaceArabicNumber(s);
                                  logic.startPriceController.selection =
                                      TextSelection.fromPosition(
                                          TextPosition(offset: s.length));
                                },
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    counter: const SizedBox.shrink(),
                                    // hintText: HiveController.generalBox.get('currency') ?? 'SAR',
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 10, start: 16),
                                      child: CustomText("من".tr,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsetsDirectional.only(top: 10),
                                      child: CustomText(
                                        '0.0'.tr,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8))),
                                style: TextStyle(
                                    fontSize: (14 + AppConfig.fontDecIncValue).sp),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                controller: logic.endPriceController,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                textDirection: TextDirection.rtl,
                                onChanged: (s) {
                                  logic.endPriceController.text = replaceArabicNumber(s);
                                  logic.endPriceController.selection =
                                      TextSelection.fromPosition(
                                          TextPosition(offset: s.length));
                                },
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    counter: const SizedBox.shrink(),
                                    // hintText: HiveController.generalBox.get('currency') ?? 'SAR',
                                    prefixIcon: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 16, top: 10),
                                      child: CustomText(
                                        "إلى".tr,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsetsDirectional.only(top: 10),
                                      child: CustomText(
                                        "0.0".tr,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8))),
                                style: TextStyle(
                                    fontSize: (14 + AppConfig.fontDecIncValue).sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => logic.onChangeDiscountSelected(),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: logic.showJustDiscount
                                          ? primaryColor
                                          : Colors.grey)),
                              padding: const EdgeInsets.all(3.5),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: logic.showJustDiscount ? primaryColor : null),
                                width: 10,
                                height: 10,
                              ),
                              width: 20,
                              height: 20,
                            ),
                            CustomText(
                              'عرض التخفيضات فقط'.tr,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                      const CustomSizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CustomButtonWidget(
                          title: "تصفية".tr,
                          onClick: () => logic.filterPrices(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Container buildContainer(CategoryDetailsLogic logic, Data e) {
    return Container(
      decoration: BoxDecoration(
          color: logic.attributeValues.contains(e.value ?? '') == true
              ? primaryColor.withOpacity(0.1)
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsetsDirectional.only(end: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GestureDetector(
          onTap: () {
            if (logic.attributeValues.contains(e.value ?? '') == true) {
              logic.attributeValues.remove(e.value);
            } else {
              logic.attributeValues.add(e.value);
            }
            logic.update();
            //   logic.clearAndFetch();
          },
          child: Row(
            children: [
              if (e.type == 'icon')
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomImage(
                        url: e.typeValue is String
                            ? e.typeValue
                            : Image2.fromJson(e.typeValue).small,
                        width: 16,
                      )),
                ),
              if (e.type == 'color')
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor.fromHex(e.typeValue.toString())),
                    width: 16,
                    height: 16,
                  ),
                ),
              CustomText(e.value,
                  fontWeight: FontWeight.w500,
                  color: logic.attributeValues.contains(e.value ?? '') == true
                      ? primaryColor
                      : Colors.black),
            ],
          )),
    );
  }
}
