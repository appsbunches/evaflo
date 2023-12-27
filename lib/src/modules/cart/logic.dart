import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:entaj/src/entities/product_details_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import '../../../../../main.dart';
import '../../.env.dart';
import '../../data/remote/api_requests.dart';
import '../../data/shared_preferences/pref_manger.dart';
import '../../entities/cart_model.dart';
import '../../entities/discount_response_model.dart';
import '../../services/app_events.dart';
import '../../utils/error_handler/error_handler.dart';
import '../../utils/functions.dart';
import '../_auth/login/view.dart';
import '../_main/logic.dart';
import '../payment/view.dart';

class CartLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final PrefManger _prefManger = Get.find();
  final AppEvents _appEvents = Get.find();
  final MainLogic _mainLogic = Get.find();
  final TextEditingController couponController = TextEditingController();

  bool hasInternet = true;
  bool isCartLoading = false;
  bool isCartItemLoading = false;
  bool checkoutLoading = false;
  bool isCouponLoading = false;
  bool isRequestToCouponLoading = false;
  bool isLoading = false;
  bool isDiscountLoading = false;
  bool clickOnAddCoupon = false;
  CartModel? cartModel;
  String? couponError;
  DiscountResponseModel? discountResponseModel;
  DiscountResponseModel? mobileDiscountResponseModel;

  @override
  void onInit() {
    super.onInit();
    getCartItems(true);
  }

  Future<bool> checkInternetConnection() async {
    var connection =
        (await Connectivity().checkConnectivity() != ConnectivityResult.none);
    hasInternet = connection;
    update(['cart']);
    return connection;
  }

  String? total;

  double getShippingFreeTarget() {
    try {
      cartModel?.totals?.forEach((element) {
        if (element.code == 'total') {
          total = element.valueString?.replaceAll('SAR', '');
          log('total: $total');
        }
      });

      var firstTarget = discountResponseModel!.conditions!.first.value!.elementAt(0);
      var secondTarget =
      discountResponseModel!.conditions!.first.value!.elementAtOrNull(1);

      var discount = (firstTarget - (total != null ? double.parse(total!) : 0));

      if (discount < 0) {
        if (secondTarget != null) {
          var secondDiscount = (secondTarget - (total != null ? double.parse(total!) : 0));
          if (secondDiscount > 0) {
            return 0;
          } else {
            return -1;
          }
        }

        return 0;
      }
      return discount;
    } catch (e) {
      log('message: ${e.toString()}');
      return 0.0;
    }
  }

  void clickToAddCoupon() {
    clickOnAddCoupon = true;
    update(['cart']);
  }

  void goToCheckout() {
    generateCheckoutToken();
    // Get.to(SuccessOrderPage());
  }

  Future<void> getCartItems(bool withLoading) async {
    if (!await checkInternetConnection()) return;
    if (withLoading) {
      isLoading = true;
      // update(['cart']);
    }
    couponError = null;

    try {
      isCartItemLoading = false;
      var response = await _apiRequests.getCart();
      log(json.encode(response.data));
      cartModel = CartModel.fromJson(response.data['payload']);
      if (cartModel?.products?.isEmpty == true) {
        await notificationHelper.cancelAll();
        if (cartModel?.giftCardDetails != null) {
          removeCartGift();
        }
      }
      clickOnAddCoupon = cartModel?.coupon != null;
      couponController.text = cartModel?.coupon?.code ?? '';
      getDiscountRules();
    } catch (e) {
      hasInternet = await ErrorHandler.handleError(e);
    }

    isLoading = false;
    update(['cart1', 'cart']);
  }

  Future<void> getDiscountRules() async {
/*
    discountResponseModel = null;
    isDiscountLoading = true;
    update(['cart']);
*/

    try {
      var response = await _apiRequests.getDiscountRules();

      var list = (response.data['payload'] as List);
      for (var element in list) {
        if (element['code'] == 'free_shipping') {
          discountResponseModel = DiscountResponseModel.fromJson(element);
        }
        if (element['code'] == 'mobile_app') {
          mobileDiscountResponseModel = DiscountResponseModel.fromJson(element);
        }
      }
    } catch (e) {
      await ErrorHandler.handleError(e);
    }

    isDiscountLoading = false;
    update(['cart']);
  }

  Future<void> deleteItem(int? id) async {
    if (id == null) return;
    if (isCartItemLoading) return;
    isCartItemLoading = true;

    try {
      var response = await _apiRequests.deleteCartItem(id);
      cartModel?.products?.removeWhere((element) => element.id == id);
      getCartItems(false);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isCartItemLoading = false;
  }

  Future<void> removeCartGift() async {
    try {
      var response = await _apiRequests.removeCartGift();
      await getCartItems(true);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future<void> deleteItemFromProductDetailsPage(int? id, String? productId) async {
    if (id == null) return;

    try {
      var response = await _apiRequests.deleteCartItem(id);
      cartModel?.products?.removeWhere((element) => element.id == id);
      getCartItems(false);
    } catch (e) {
      //ErrorHandler.handleError(e);
    }

    update(['addToCart$productId']);
  }

  void redeemCoupon() async {
    couponError = null;
    if (couponController.text.isEmpty) {
      showMessage("يرجى ادخال رمز الكوبون".tr, 2);
      return;
    }
    isCouponLoading = true;
    update(['cart']);

    try {
      var response = await _apiRequests.redeemCoupon(couponController.text);
      await getCartItems(false);
      if (cartModel?.coupon == null) {
        couponError = 'لديك خصم في السلة أكبر من قيمة الكوبون';
      }
    } catch (e) {
      try {
        if (e is DioError) {
          couponError = e.response?.data['message']['description'];
        }
      } catch (e) {
        ErrorHandler.handleError(e);
      }
    }

    isCouponLoading = false;
    isRequestToCouponLoading = true;
    update(['cart']);
  }

  void removeCoupon() async {
    isCouponLoading = true;
    update(['cart']);

    try {
      var response = await _apiRequests.removeCoupon();
      await getCartItems(false);
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }

    isCouponLoading = false;
    update(['cart']);
  }

  Future<void> addToCart(String? productId,
      {required bool hasOptions,
      required String quantity,
      required bool hasFields,
      BuildContext? context,
      List? customUserInputFieldRequest}) async {
    if (productId == null) {
      showMessage("يرجى اختيار جميع الخيارات".tr, 2);
      return;
    }
    if (quantity == '' || quantity == '0') {
      showMessage("يرجى ادخال الكمية".tr, 2);
      return;
    }
    if (context != null) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    isCartLoading = true;
    update(['addToCart$productId']);

    try {
      var response = await _apiRequests.addCartItem(
          productId: productId,
          quantity: quantity.toString(),
          hasFields: hasFields,
          customFieldsList: customUserInputFieldRequest);
      await getCartItems(false);
      showMessage("تم اضافة المنتج إلى السلة".tr, 1);
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate(duration: 200);
      }
      await notificationHelper.cancelAll();
      notificationHelper.scheduledNotification();
    } catch (e) {
      await ErrorHandler.handleError(e);
    }

    isCartLoading = false;
    update(['addToCart$productId']);
  }

  void updateCartItem(int id, int quantity, {int? index}) async {
    if (isCartItemLoading) return;
    isCartItemLoading = true;
    //   update([id]);

    try {
      var response =
          await _apiRequests.updateCartItem(id.toString(), quantity.toString());
      await getCartItems(false);
    } catch (e) {
      await getCartItems(false);
      ErrorHandler.handleError(e);
    }

    isCartItemLoading = false;
//    update([id]);
  }

  clearCoupon() {
    couponController.text = '';
    couponError = null;
    isRequestToCouponLoading = false;
    update(['cart']);
  }

  decreaseQuantity(Products? product, {int? newQty1}) {
    if (product == null) return;
    if (isCartItemLoading) return;
    if (product.quantity == 1) {
      return;
    }

    late int newQty;
    if (newQty1 == null) {
      newQty = product.quantity! - 1;
    } else {
      newQty = newQty1;
    }

    if (product.purchaseRestrictions?.minQuantityPerCart != null) {
      if ((product.purchaseRestrictions!.minQuantityPerCart! - 1) >= newQty) return;
    }
    product.quantity = newQty;
    update([product.id!]);
    startCount(product, newQty);
  }

  increaseQuantity(Products? product, {int? newQty1}) {
    if (product == null) return;
    late int newQty;
    if (newQty1 == null) {
      newQty = product.quantity! + 1;
    } else {
      newQty = newQty1;
    }
    if (product.purchaseRestrictions?.maxQuantityPerCart != null) {
      if ((product.purchaseRestrictions!.maxQuantityPerCart! + 1) <= newQty) return;
    } else {
      if ((product.quantity ?? 0) > 9999) return;
    }
    if (product.originalProductQuantity != null) {
      if ((product.originalProductQuantity! + 1) <= newQty) return;
    }
    if (isCartItemLoading) return;
    product.quantity = newQty;
    update([product.id!]);
    startCount(product, newQty);
  }

  Timer? _timer;

  void startCount(Products product, newQty) async {
    if (_timer != null) _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () {
      updateCartItem(product.id!, newQty);
    });
  }

  void generateCheckoutToken() async {
    if (_mainLogic.settingModel?.settings?.availability?.closedNow == true &&
        _mainLogic.settingModel?.settings?.availability?.isStoreClosed == true) {
      showMessage(
          isArabicLanguage
              ? _mainLogic.settingModel?.settings?.availability?.message?.ar ?? ''
              : _mainLogic.settingModel?.settings?.availability?.message?.en ?? '',
          2);
      return;
    }
    if (!await _prefManger.getIsLogin()) {
      Get.to(LoginPage())?.then((value) async {
        isLoading = true;
        //   update(['cart1']);
        await Future.delayed(const Duration(seconds: 3));
        getCartItems(true);
      });
      return;
    }

    checkoutLoading = true;
    update(['checkout']);

    try {
      var response = await _apiRequests.verifyCart();
    } catch (e) {
      if (e is DioError) {
        if (e.response.toString().contains('ERROR_CART_IS_RESERVED')) {
          ErrorHandler.handleError(e);

          checkoutLoading = false;
          update(['checkout']);
          return;
        }
      }
    }
    try {
      var response = await _apiRequests.generateCheckoutToken();

      String checkoutToken = response.data['payload']['checkout_token'].toString();
      String permalink =
          Get.find<MainLogic>().settingModel?.settings?.permalink ?? (storeUrl + '/');
      var doubleSlashIndex = permalink.indexOf('//', 8);
      if (doubleSlashIndex != -1) {
        permalink = permalink.replaceRange(doubleSlashIndex, doubleSlashIndex + 1, '');
      }

      String checkoutUrl =
          '${permalink}checkout/from-token?hide-header-footer=false&source=mobile_app&lang=${isArabicLanguage ? 'ar' : 'en'}&checkout-token=$checkoutToken';

      _appEvents.logCheckout(
          coupon: cartModel?.coupon?.code,
          value: cartModel?.productsSubtotal,
          items: cartModel?.products
              ?.map((e) => AnalyticsEventItem(
                  itemId: e.productId, itemName: e.name, price: e.total))
              .toList());

      Get.to(PaymentScreen(url: checkoutUrl),
              transition: Transition.downToUp, fullscreenDialog: true)
          ?.then((value) async {
        isLoading = true;
        update(['cart']);
        await Future.delayed(const Duration(seconds: 3));
        await getCartItems(true);
      });
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }

    checkoutLoading = false;
    update(['checkout']);
  }

  String? getTotal() {
    String? total;
    try {
      total =
          cartModel?.totals?.firstWhere((element) => element.code == 'total').valueString;
    } catch (e) {}
    return total;
  }

  bool checkIfExist(
      String? mProductId, List customFiled, ProductDetailsModel? productModel) {
    bool exist = false;
    cartModel?.products?.forEach((elementCart) {
      if (elementCart.productId == mProductId?.replaceAll('-', '')) {
        bool hasDropdown = false;
        productModel?.customOptionFields?.forEach((element) {
          if (element.type == 'DROPDOWN') hasDropdown = true;
        });
        if (hasDropdown) {
          elementCart.customFields?.forEach((elementCartItem) {
            for (var elementCustom in customFiled) {
              if (elementCustom['group_name'] == elementCartItem.groupName) {
                if (elementCustom['name'] == elementCartItem.realName) {
                  exist = true;
                }
              }
            }
          });
        } else {
          exist = true;
        }
      }
    });

    return exist;
  }

  Products? getCartItem(String? mProductId) {
    Products? product;
    cartModel?.products?.forEach((element) {
      if (element.productId == mProductId?.replaceAll('-', '')) product = element;
    });

    return product;
  }

  void goToHome() {
    showMessage(
        "المنتج الذي حاولت عرضه غير صحيح أو غير موجود حاليا تم إعادة توجيهك للصفحة الرئيسية للمتجر"
            .tr,
        2);
    _mainLogic.changeSelectedValue(0, true, backCount: 0);
  }
}
