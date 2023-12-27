import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../images.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../logic.dart';

class ProductWhatsWidget extends StatefulWidget {
  const ProductWhatsWidget({Key? key}) : super(key: key);

  @override
  State<ProductWhatsWidget> createState() => _ProductWhatsWidgetState();
}

class _ProductWhatsWidgetState extends State<ProductWhatsWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var productId = Get.parameters['productId'] ?? 'unknown';

    return GetBuilder<ProductDetailsLogic>(
        init: Get.find<ProductDetailsLogic>(tag: productId),
        tag: productId,
        id: productId,
        builder: (logic) {
          return !AppConfig.showWhatsAppIconInProductPage || logic.isLoading
              ? const SizedBox()
              : logic.productModel?.quantity == 0
                  ? SizedBox()
                  : GetBuilder<ProductDetailsLogic>(
                      tag: productId,
                      init: Get.find<ProductDetailsLogic>(tag: productId),
                      id: 'Whats',
                      builder: (logic) {
                        return GestureDetector(
                          onTap: () => logic.goToWhatsApp(
                              message:
                                  'احتاج معلومات اكثر عن المنتج ${logic.productModel?.htmlUrl}'),
                          child: Container(
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            height: 50.sp,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  iconWhatsapp,
                                  scale: 3,
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                CustomText('استفسر عن المنتج'.tr,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.sp,
                                    color: authTextButtonColor)
                              ],
                            ),
                          ),
                        );
                      });
        });
  }
}
