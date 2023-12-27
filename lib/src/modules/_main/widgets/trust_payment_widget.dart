import 'package:entaj/src/modules/delivery_option/view.dart';
import 'package:entaj/src/utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../../colors.dart';
import '../../../images.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../logic.dart';

class TrustPayment extends StatefulWidget {
  const TrustPayment({Key? key}) : super(key: key);

  @override
  State<TrustPayment> createState() => _TrustPaymentState();
}

class _TrustPaymentState extends State<TrustPayment> {
  final MainLogic _mainLogic = Get.find();

  @override
  void initState() {
    _mainLogic.checkInternetConnection();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<MainLogic>(
        init: Get.find<MainLogic>(),
        builder: (logic) {
          return GestureDetector(
            onTap: () {
              Get.to(DeliveryOptionPage());
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: primaryColor, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Stack(
                    children: [
                      Opacity(
                          opacity: 0.1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: CustomImage(
                              url: iconTrust,
                              color: primaryColor,
                              height: 70,
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: CustomText(
                          'طرق دفع متعددة\n وأمنة',
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, childAspectRatio: 1.5),
                            shrinkWrap: true,
                            itemCount:
                                logic.settingModel?.footer?.paymentMethods?.length ?? 0,
                            itemBuilder: (context, index) => Container(
                                  height: 40.h,
                                  width: 40.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  child: CustomImage(
                                      url: logic.settingModel?.footer
                                          ?.paymentMethods?[index].icon,
                                      fit: BoxFit.contain,
                                      size: 10),
                                ))),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
