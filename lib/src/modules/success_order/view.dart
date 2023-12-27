import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../../main.dart';
import '../../app_config.dart';
import '../../colors.dart';
import '../../images.dart';
import '../../services/app_events.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_sized_box.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import '../_main/logic.dart';
import '../order_details/logic.dart';
import '../order_details/view.dart';
import '../upload_transfer/view.dart';

class SuccessOrderPage extends StatefulWidget {
  final String orderId;

  const SuccessOrderPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<SuccessOrderPage> createState() => _SuccessOrderPageState();
}

enum Availability { loading, available, unavailable }

class _SuccessOrderPageState extends State<SuccessOrderPage> {
  final OrderDetailsLogic logic = Get.put(OrderDetailsLogic());

  final MainLogic _mainLogic = Get.find();

  final InAppReview inAppReview = InAppReview.instance;

  Availability _availability = Availability.loading;

  @override
  initState() {
    if (AppConfig.showStoreRating) rateApp();
    notificationHelper.cancelAll();
    super.initState();
  }

  void rateApp() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final isAvailable = await inAppReview.isAvailable();

        setState(() {
          _availability = isAvailable && !Platform.isAndroid
              ? Availability.available
              : Availability.unavailable;
        });
      } catch (e) {
        setState(() => _availability = Availability.unavailable);
      }
    });
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton:
          AppConfig.showGBAllApp ? const GlobalFloatingWhatsApp() : null,
      appBar: AppBar(
        leading: IconButton(
          icon: RotationTransition(
              turns: AlwaysStoppedAnimation((isArabicLanguage ? 0 : 180) / 360),
              child: Image.asset(
                iconBack,
                scale: 2,
                color: primaryColor,
              )),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: GetBuilder<OrderDetailsLogic>(
          initState: (s){
            logic
                .getOrdersDetails(widget.orderId, true)
                .then((value) => Get.find<AppEvents>().logPurchase(logic.orderModel));
          },
          builder: (logic) {
        return SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: logic.isLoading
                ? SizedBox(
                    height: Get.height, child: const CustomProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          iconLogo,
                          height: 60.h,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              iconBg,
                              color: primaryColor,
                              scale: 3,
                            ),
                            const CustomSizedBox(
                              width: 25,
                            )
                          ],
                        ),
                        const CustomSizedBox(
                          height: 30,
                        ),
                        CustomText("تم إرسال طلبك بنجاح".tr),
                        const CustomSizedBox(
                          height: 30,
                        ),
                        CustomText("رقم الطلب: #".tr +
                            (logic.orderModel?.id ?? widget.orderId)
                                .toString()),
                        const CustomSizedBox(
                          height: 30,
                        ),
                        CustomButtonWidget(
                          title: "عرض تفاصيل الطلب".tr,
                          color: greenLightColor,
                          width: 300.w,
                          onClick: () => Get.to(OrderDetailsPage(widget.orderId,
                              fromSuccessOrder: true)),
                        ),
                        const CustomSizedBox(
                          height: 30,
                        ),
                        if (logic.orderModel?.needTransfer == true)
                          Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                color: blueLightColor,
                                borderRadius: BorderRadius.circular(15.sp)),
                            child: Column(
                              children: [
                                CustomText(
                                  "بإنتظار إتمام الدفع لتجهيز طلبك، لإتمام الدفع ومعرفة معلومات الحساب البنكي"
                                      .tr,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomButtonWidget(
                                  title: "إضغط هنا".tr,
                                  onClick: () => Get.to(UploadTransferPage(
                                    code: widget.orderId,
                                    fromSuccessOrder: true,
                                    total: logic.orderModel?.orderTotalString,
                                  ))?.then((value) => logic.getOrdersDetails(
                                      widget.orderId, true)),
                                  width: 200.w,
                                  textSize: 12,
                                  height: 42.h,
                                  textColor: Colors.black,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        const CustomSizedBox(
                          height: 30,
                        ),
                        if (_mainLogic.settingModel?.settings?.vatSettings
                                ?.vatNumber !=
                            null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                imageTax,
                                scale: 2,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    "الرقم الضريبي".tr,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  CustomText(
                                    _mainLogic.settingModel?.settings
                                        ?.vatSettings?.vatNumber,
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              )
                            ],
                          )
                      ],
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
