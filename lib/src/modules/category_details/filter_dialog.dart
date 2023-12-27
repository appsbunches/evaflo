import '../../app_config.dart';
import '../../data/hive/wishlist/hive_controller.dart';

import '../../colors.dart';
import 'logic.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_sized_box.dart';
import '../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/functions.dart';

class FilterDialog extends StatelessWidget {
  final String? categoryId;

  const FilterDialog({this.categoryId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
      backgroundColor: Colors.grey.shade100,
      child: SizedBox(
        height: 280.sp,
        width: 300.sp,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.sp),
          child: GetBuilder<CategoryDetailsLogic>(
              tag: categoryId,
              init: Get.find<CategoryDetailsLogic>(tag: categoryId),
              builder: (logic) {
                return Column(
                  children: [
                    Container(
                      color: Colors.grey.shade200,
                      padding: EdgeInsets.all(15.sp),
                      child: Row(
                        children: [
                          CustomText("السعر".tr, fontWeight: FontWeight.bold),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => logic.restPrice(),
                            child: CustomText(
                              "إعادة ضبط".tr,
                              color: secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CustomSizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText("من".tr),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
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
                                        hintText:
                                            HiveController.generalBox.get('currency') ??
                                                'SAR',
                                        contentPadding: EdgeInsets.zero,
                                        border: const OutlineInputBorder()),
                                    style: TextStyle(
                                        fontSize: (14 + AppConfig.fontDecIncValue).sp),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText("إلى".tr),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: logic.endPriceController,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    textDirection: TextDirection.rtl,
                                    onChanged: (s) {
                                      logic.endPriceController.text =
                                          replaceArabicNumber(s);
                                      logic.endPriceController.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(offset: s.length));
                                    },
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        counter: const SizedBox.shrink(),
                                        hintText:
                                            HiveController.generalBox.get('currency') ??
                                                'SAR',
                                        contentPadding: EdgeInsets.zero,
                                        border: const OutlineInputBorder()),
                                    style: TextStyle(
                                        fontSize: (14 + AppConfig.fontDecIncValue).sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: logic.showJustDiscount,
                            onChanged: (val) => logic.onChangeDiscountSelected()),
                        CustomText('عرض التخفيضات فقط'.tr),
                      ],
                    ),
                    const CustomSizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CustomButtonWidget(
                        title: "تصفية".tr,
                        onClick: () => logic.filterPrices(),
                        color: Colors.white,
                        textColor: secondaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
