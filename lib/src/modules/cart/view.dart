import 'dart:developer';

import 'package:entaj/src/entities/coupon_model.dart';
import 'package:entaj/src/modules/_main/logic.dart';
import 'package:entaj/src/modules/cart/widgets/cart_items_widget.dart';
import 'package:entaj/src/modules/cart/widgets/gift_widget.dart';
import 'package:entaj/src/modules/gift/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../../../main.dart';
import '../../app_config.dart';
import '../../colors.dart';
import '../../images.dart';
import '../../services/app_events.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../_main/widgets/bonat_item.dart';
import 'widgets/item_cart.dart';
import 'logic.dart';

class CartPage extends StatelessWidget {
  final CartLogic logic = Get.find();
  final AppEvents _appEvents = Get.find();

  CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _appEvents.logScreenOpenEvent('CartTab');
    logic.isRequestToCouponLoading = false;
    logic.couponError = null;
    logic.getCartItems(true);
    return Container(
      color: cartBackgroundColor,
      height: double.infinity,
      child: GetBuilder<CartLogic>(
          id: 'cart',
          init: Get.find<CartLogic>(),
          builder: (logic) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                AppBar(
                  backgroundColor: headerBackgroundColor,
                  foregroundColor: headerForegroundColor,
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: isArabicLanguage
                          ? Image.asset(iconMenu, scale: 2, color: headerForegroundColor)
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: Image.asset(iconMenu,
                                  scale: 2, color: headerForegroundColor),
                            ),
                      alignment: AlignmentDirectional.centerStart,
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  title: CustomText(
                    "السلة".tr,
                    fontSize: 16,
                    color: headerForegroundColor,
                  ),
                  actions: [
                    if (AppConfig.showBonatInAppBar &&
                        AppConfig.showBonatFromRemoteConfig &&
                        AppConfig.showBonat)
                      const BonatItem(
                        showText: false,
                      ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 15),
                      child: Image.asset(
                        iconLogoAppBarEnd,
                        alignment: AlignmentDirectional.centerEnd,
                        height: AppConfig.logoSizeInApBarHeight,
                        width: AppConfig.logoSizeInApBarWidth,
                        color: headerLogoColor,
                      ),
                    ),
                  ],
                ),
                logic.isLoading
                    ? const CustomProgressIndicator()
                    : (logic.cartModel?.products?.isNotEmpty == false ||
                            logic.cartModel == null)
                        ? buildEmptyCartWidget()
                        : Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                logic.getCartItems(true);
                              },
                              child: SizedBox(
                                height: Get.height,
                                child: SingleChildScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  child: GetBuilder<CartLogic>(
                                      autoRemove: false,
                                      id: 'cart',
                                      init: Get.find<CartLogic>(),
                                      builder: (logic) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const CartItemsWidget(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const GiftWidget(),
                                            buildCoupon(logic),
                                            if (Get.find<MainLogic>()
                                                        .settingModel
                                                        ?.settings
                                                        ?.isGiftOrderEnabled ==
                                                    true &&
                                                AppConfig.giftCartEnable) ...[
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              CustomButtonWidget(
                                                title: logic.cartModel?.giftCardDetails ==
                                                        null
                                                    ? "أرسلها كهدية".tr
                                                    : 'تم اضافة الطلب كهدية'.tr,
                                                onClick: () => Get.to(GiftPage()),
                                                color: buttonBackgroundCouponColor,
                                                textColor: buttonTextCouponColor,
                                                widthBorder: true,
                                                padding: 10,
                                              ),
                                            ],
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            buildTotalList(logic),
                                            buildDiscounts(logic),
                                            buildBottomTotal(logic)
                                          ],
                                        );
                                      }),
                                ),
                              ),
                            ),
                          )
              ],
            );
          }),
    );
  }

  Container buildBottomTotal(CartLogic logic) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey.shade200,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "الإجمالي".tr,
                  fontSize: 14,
                ),
                if (logic.cartModel?.totals?.isNotEmpty == true)
                  CustomText(
                    logic.getTotal(),
                    fontSize: 16,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  )
              ],
            ),
          ),
          Expanded(
              flex: 3,
              child: GetBuilder<CartLogic>(
                  id: 'checkout',
                  init: Get.find<CartLogic>(),
                  autoRemove: false,
                  builder: (logic) {
                    return CustomButtonWidget(
                      title: "إتمام الدفع".tr,
                      textSize: 14,
                      loading: logic.checkoutLoading,
                      onClick: () => logic.generateCheckoutToken(),
                      color: buttonBackgroundCheckoutColor,
                      textColor: buttonTextCheckoutColor,
                    );
                  }))
        ],
      ),
    );
  }

  GetBuilder buildEmptyCartWidget() {
    return GetBuilder<CartLogic>(
        init: Get.find<CartLogic>(),
        id: 'cart',
        builder: (logic) {
          return Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  logic.hasInternet
                      ? Image.asset(
                          iconCart,
                        )
                      : const Icon(
                          Icons.wifi_off,
                          color: Colors.grey,
                          size: 60,
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomText(
                    logic.hasInternet
                        ? "لم تقم بإضافة أي منتج للسلة".tr
                        : 'يرجى التأكد من اتصالك بالإنترنت'.tr,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          );
        });
  }

  Container buildTotalList(CartLogic logic) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.sp), topRight: Radius.circular(15.sp))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: logic.cartModel?.totals?.length ?? 0,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomText(
                      logic.cartModel!.totals?[index].title,
                      fontWeight: logic.cartModel!.totals![index].code == 'total'
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  CustomText(
                    logic.cartModel!.totals![index].valueString,
                    fontWeight: logic.cartModel!.totals![index].code == 'total'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (AppConfig.showDeliveryCostNote)
            CustomText('* ملاحظة: هذا المجموع لا يشمل تكاليف التوصيل.'.tr, fontSize: 10)
        ],
      ),
    );
  }

  Padding buildCoupon(CartLogic logic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            "كوبون الخصم".tr,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 10,
          ),
          !logic.clickOnAddCoupon
              ? CustomButtonWidget(
                  title: "أضف كوبون".tr,
                  onClick: () => logic.clickToAddCoupon(),
                  color: buttonBackgroundCouponColor,
                  textColor: buttonTextCouponColor,
                )
              : Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.sp),
                      color: Colors.grey.shade100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: TextField(
                              controller: logic.couponController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: logic.isRequestToCouponLoading ||
                                          logic.cartModel?.coupon != null
                                      ? logic.isCouponLoading ||
                                              logic.cartModel?.coupon == null
                                          ? null
                                          : logic.couponError != null
                                              ? InkWell(
                                                  onTap: () => logic.clearCoupon(),
                                                  child: Image.asset(
                                                    iconClose,
                                                    scale: 1.5,
                                                  ),
                                                )
                                              : Image.asset(
                                                  iconCheck,
                                                  color: primaryColor,
                                                  scale: 1.5,
                                                )
                                      : null,
                                  labelText: "أدخل الكوبون".tr),
                            )),
                        Expanded(
                            flex: 3,
                            child: logic.cartModel?.coupon != null
                                ? CustomButtonWidget(
                                    title: "حذف".tr,
                                    onClick: () => logic.removeCoupon(),
                                    color: moveColor,
                                    textColor: buttonTextCouponColor,
                                    loading: logic.isCouponLoading,
                                    textSize: 10,
                                  )
                                : CustomButtonWidget(
                                    title: "تطبيق الكوبون".tr,
                                    onClick: () => logic.redeemCoupon(),
                                    color: buttonBackgroundCouponColor,
                                    loading: logic.isCouponLoading,
                                    textColor: buttonTextCouponColor,
                                    textSize: 10,
                                  ))
                      ],
                    ),
                  ),
                ),
          Visibility(
            visible: logic.cartModel?.coupon != null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(
                getCouponText(logic.cartModel?.coupon),
                color: greenLightColor,
              ),
            ),
          ),
          Visibility(
            visible: logic.couponError != null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(
                logic.couponError?.tr,
                color: moveColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildDiscounts(CartLogic logic) {
    return logic.isDiscountLoading
        ? const Center(
            child: SizedBox(
                width: 15,
                height: 15,
                child: Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 1,
                ))))
        : Column(
            children: [
              if (logic.discountResponseModel != null)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: const EdgeInsets.all(5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: discountBackgroundColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30), color: Colors.white),
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          iconDeliveryMethod,
                          color: discountIconColor,
                          width: 20,
                          height: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: logic.getShippingFreeTarget() == 0
                            ? CustomText(
                                "قيمة الشحن مجانية الآن".tr,
                                fontWeight: FontWeight.bold,
                                color: discountTextColor,
                              )
                            : logic.getShippingFreeTarget() == -1
                                ? CustomText(
                                    isArabicLanguage
                                        ? "الشحن المجاني محصور بين ${logic.discountResponseModel?.conditions!.first.valueString!.elementAtOrNull(0) ?? '0.0'} إلى ${logic.discountResponseModel?.conditions!.first.valueString!.elementAtOrNull(1) ?? '0.0'}"
                                        : 'Free shipping applied for cart total between ${logic.discountResponseModel?.conditions!.first.valueString!.elementAtOrNull(0) ?? '0.0'} and ${logic.discountResponseModel?.conditions!.first.valueString!.elementAtOrNull(1) ?? '0.0'}',
                                    fontWeight: FontWeight.bold,
                                    color: discountTextColor,
                                  )
                                : CustomText(
                                    'متبقي على الشحن المجاني @discount @currency'
                                        .trParams({
                                      'discount': logic
                                          .getShippingFreeTarget()
                                          .toStringAsFixed(2),
                                      'currency':
                                          logic.cartModel?.currency?.cartCurrency?.code ??
                                              '',
                                    }),
                                    fontWeight: FontWeight.bold,
                                    color: discountTextColor,
                                  ),
                      )
                    ],
                  ),
                ),
              if (logic.mobileDiscountResponseModel != null)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: const EdgeInsets.all(5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: discountBackgroundColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
                          child: Icon(
                            Icons.phone_android,
                            size: 20,
                            color: discountIconColor,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomText(
                          !isArabicLanguage
                              ? 'The mobile app ${logic.mobileDiscountResponseModel?.actions?.first.value}% discount will be activated upon payment completion'
                              : 'سيتم تفعيل خصم التطبيق ${logic.mobileDiscountResponseModel?.actions?.first.value}% عند اتمام الدفع',
                          fontWeight: FontWeight.bold,
                          color: discountTextColor,
                        ),
                      )
                    ],
                  ),
                )
            ],
          );
  }

  String? getCouponText(CouponModel? coupon) {
    if (coupon?.freeCod == true && coupon?.discount == 0) {
      return 'سيتم خصم رسوم الدفع عند الاستلام'.tr;
    } else if (coupon?.freeCod == true && coupon?.discount != 0) {
      return "تم خصم ".tr + "${logic.cartModel?.coupon?.discountAmountString}";
    } else if (coupon?.freeShipping == true && coupon?.discount == 0) {
      return 'تم إضافة كوبون شحن مجاني للسلة'.tr;
    } else if (coupon?.freeShipping == true && coupon?.discount != 0) {
      return "تم خصم ".tr + "${logic.cartModel?.coupon?.discountAmountString}";
    } else {
      return "تم خصم ".tr + "${logic.cartModel?.coupon?.discountAmountString}";
    }
  }
}
