import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../images.dart';
import '../../../services/app_events.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';
import '../../cart/logic.dart';
import '../logic.dart';

class ProductAddToCartWidget extends StatefulWidget {
  final String mProductId;
  final AppEvents _appEvents;
  final FocusNode phoneNumberFocusNode;

  const ProductAddToCartWidget(
      this.mProductId, this.phoneNumberFocusNode, this._appEvents,
      {Key? key})
      : super(key: key);

  @override
  State<ProductAddToCartWidget> createState() => _ProductAddToCartWidgetState();
}

class _ProductAddToCartWidgetState extends State<ProductAddToCartWidget> {
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    widget.phoneNumberFocusNode.addListener(() {
      bool hasFocus = widget.phoneNumberFocusNode.hasFocus;
      if (hasFocus) {
        showOverlay(context);
      } else {
        log('message');
        removeOverlay();
      }
      setState(() {});
    });
    super.initState();
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return PositionedDirectional(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          start: 0,
          height: 45.h,
          end: 0,
          child: Container(
            width: double.infinity,
            color: Colors.grey.shade100,
            child: Align(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                child: const Text("Done",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
            ),
          ));
    });

    overlayState?.insert(overlayEntry!);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsLogic>(
        init: Get.find<ProductDetailsLogic>(tag: widget.mProductId),
        id: widget.mProductId,
        tag: widget.mProductId,
        builder: (logic) {
          return Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300, blurRadius: 10, spreadRadius: 0.1)
                ],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25.sp), topLeft: Radius.circular(25.sp)),
                color: logic.productModel?.quantity == 0
                    ? Colors.grey.shade200
                    : Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15.h),
            child: logic.productModel?.quantity == 0
                ? buildIsEmpty(widget.mProductId)
                : Padding(
                    padding: EdgeInsets.only(bottom: overlayEntry == null ? 0 : 45.h),
                    child: SizedBox(
                      height: 45.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: GetBuilder<ProductDetailsLogic>(
                                tag: widget.mProductId,
                                id: 'price',
                                init:
                                    Get.find<ProductDetailsLogic>(tag: widget.mProductId),
                                builder: (logic) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (logic.salePriceTotal != 0)
                                              CustomText(
                                                logic.formattedPrice,
                                                color: formattedSalePriceTextColor,
                                                lineThrough: true,
                                                fontSize: 10,
                                                //fontWeight: FontWeight.w800,
                                              ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Flexible(
                                                  child: CustomText(
                                                    logic.salePriceTotal != 0
                                                        ? logic.formattedSalePrice
                                                        : logic.formattedPrice,
                                                    color: logic.salePriceTotal != 0
                                                        ? formattedPriceTextColorWithSale
                                                        : formattedPriceTextColorWithoutSale,
                                                    fontSize: 12,
                                                    maxLines: 1,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20.w,
                                                ),
                                                if (logic.salePriceTotal > 0.0 &&
                                                    logic.priceTotal > 0.0 &&
                                                    AppConfig.showDiscountPercentage)
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            moveColor.withOpacity(0.15),
                                                        borderRadius:
                                                            BorderRadius.circular(3)),
                                                    margin: const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 3, vertical: 1),
                                                    child: CustomText(
                                                      calculateDiscount(
                                                          salePriceTotal:
                                                              logic.salePriceTotal,
                                                          priceTotal: logic.priceTotal),
                                                      color: moveColor,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 150.w,
                            child: GetBuilder<CartLogic>(
                                init: Get.find<CartLogic>(),
                                id: 'addToCart${widget.mProductId}',
                                autoRemove: false,
                                builder: (cartLogic) {
                                  return cartLogic.checkIfExist(logic.getProductId(),
                                          logic.getCustomList(), logic.productModel)
                                      ? Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(25),
                                              color: primaryColor),
                                          height: double.infinity,
                                          padding: EdgeInsets.only(
                                              bottom: 7.h, left: 15, top: 7.h, right: 15),
                                          child: buildQty(cartLogic),
                                        )
                                      : CustomButtonWidget(
                                          title: "أضف للسلة".tr,
                                          textSize: 12,
                                          radius: 25.sp,
                                          icon: Image.asset(
                                            iconAddToCart,
                                            scale: 2,
                                            color: iconAddToCartColor,
                                          ),
                                          height: double.infinity,
                                          loading: cartLogic.isCartLoading,
                                          textColor: textAddToCartColor,
                                          color: AppConfig.showButtonWithBorder
                                              ? Colors.white
                                              : primaryColor,
                                          onClick: () => addToCart(logic, cartLogic),
                                        );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }

  GetBuilder<ProductDetailsLogic> buildQty(CartLogic cartLogic) {
    return GetBuilder<ProductDetailsLogic>(
        id: 'quantity',
        tag: widget.mProductId,
        builder: (logic) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logic.quantityController.text == '1'
                  ? GestureDetector(
                      onTap: () => cartLogic.deleteItemFromProductDetailsPage(
                          cartLogic.getCartItem(logic.getProductId())?.id,
                          widget.mProductId),
                      child: Image.asset(
                        iconRemove,
                        scale: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : GestureDetector(
                      onTap: () => logic.decreaseQuantity(),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
              Expanded(
                  child: TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: logic.quantityController,
                textAlign: TextAlign.center,
                maxLength: 4,
                textDirection: TextDirection.ltr,
                onChanged: (s) {
                  logic.quantityController.text = replaceArabicNumber(s);

                  logic.onChangeAddToCart(s);
                },
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 10.h),
                    counter: const SizedBox.shrink()),
                style: TextStyle(
                    fontSize: (14 + AppConfig.fontDecIncValue).sp, color: Colors.white),
              )),
              GestureDetector(
                  onTap: () => logic.increaseQuantity(),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ))
            ],
          );
        });
  }

  GetBuilder<ProductDetailsLogic> buildIsEmpty(productId) {
    return GetBuilder<ProductDetailsLogic>(
        init: Get.find<ProductDetailsLogic>(tag: productId),
        id: "isEmpty",
        tag: productId,
        builder: (logic) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomText(
                  "المنتج غير متوفر حالياً".tr,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 45.h,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12.sp)),
                        child: TextField(
                          controller: logic.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              hintStyle: const TextStyle(fontSize: 12),
                              hintText:
                                  "أدخل بريدك الإلكتروني ليتم إعلامك عندما يتوفر مرة أخرى"
                                      .tr),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomButtonWidget(
                          title: "ارسل".tr,
                          radius: 12,
                          color: !logic.isEmpty ? primaryColor : Colors.grey.shade300,
                          textColor: !logic.isEmpty ? Colors.white : Colors.grey,
                          //textColor: Colors.grey,
                          loading: logic.isNotifyMeLoading,
                          onClick: /*logic.isEmpty ? null : */ () =>
                              logic.sentNotification()),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  addToCart(ProductDetailsLogic logic, CartLogic cartLogic) async {
    logic.update([widget.mProductId]);
    var minQty = logic.productModel?.purchaseRestrictions?.minQuantityPerCart;
    var maxQty = logic.productModel?.purchaseRestrictions?.maxQuantityPerCart;
    if (minQty != null) {
      if ((int.tryParse(logic.quantityController.text) ?? 0) < minQty) {
        logic.quantityController.text = minQty.toString();
      }
    }
    var productId = logic.getProductId();

    widget._appEvents.logAddToCart(
        logic.productModel?.name, logic.productModel?.id, logic.productModel?.price);

    await cartLogic.addToCart(
      productId,
      context: context,
      quantity: logic.quantityController.text,
      customUserInputFieldRequest: logic.getCustomList(),
      hasOptions: logic.productModel?.hasOptions ?? false,
      hasFields: logic.productModel?.hasFields ?? false,
    );

    logic.update([widget.mProductId]);
  }
}
