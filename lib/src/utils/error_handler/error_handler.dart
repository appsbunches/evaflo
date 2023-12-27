import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../functions.dart';
import '../../data/remote/api_requests.dart';
import '../../data/shared_preferences/pref_manger.dart';
import '../../modules/cart/logic.dart';
import '../custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorHandler {
  static Future<bool> handleError(
    Object e, {
    bool showToast = true,
    dynamic stacktrace,
  }) async {
    String error1 = 'لم يتم إيجاد منتج السلة المطلوب';
    String error2 = 'لم يتم إيجاد منتج السلة المطلوب';
    String error3 = 'Error in cart session';
    String error4 = 'خطأ في سلة الشراء';

    log('## stacktrace ## ' + stacktrace.toString());
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionTimeout) {
        final ConnectivityResult result = await Connectivity().checkConnectivity();
        if (result == ConnectivityResult.none) {
          showMessage('يرجى التأكد من اتصالك بالإنترنت'.tr, 2);
          return false;
        }
        return false;
      }
      if (e.response != null) {
        if (e.response?.statusCode == HttpStatus.internalServerError) {
          showMessage('نعتذر لك .. يرجى المحاولة مرة أخرى بعد لحظات '.tr, 2);
          return true;
        }
        var description = e.response!.data['message']['description'];
        var code = e.response!.data['message']['code'];
        try {
          if (description.toString().contains(error3) ||
              description.toString().contains(error4)) {
            await generateSession(false);
          } else if (code == 'ERROR_CART_IS_RESERVED') {
            showErrorCartIsReserved(e);
          } else if (code == 'ERROR_CART_NOT_FOUND') {
            await generateSession(false, renewSession: true);
          } else if (description
              .toString()
              .contains('ProductsCustomUserInputFieldNotFoundException')) {
            await generateSession(false, renewSession: true);
          } else if (description == 'Unauthenticated') {
            //refreshToken();
          } else {
            String name = e.response!.data['message']['name'] ?? '';
            String code = e.response!.data['message']['code'] ?? '';
            String description = e.response!.data['message']['description'] ?? '';
            if (code != 'MSG_HIDDEN') {
              if (!(name.contains('cURL error') || description.contains('cURL error'))) {
                if (!(name.contains('500 Internal') ||
                    description.contains('500 Internal'))) {
                  if (!(description.contains(error1) || description.contains(error2))) {
                    if (showToast) {
                      if (e.response!.data['message']['validations'] != null) {
                        var list = e.response!.data['message']['validations'] as List?;
                        var errors = '';
                        list?.forEach((element) {
                          (element['errors'] as List?)?.forEach((element) {
                            errors = errors + (errors == '' ? '' : '\n') + element;
                          });
                        });
                        showMessage(errors, 2, fontSize: 10, seconds: 5);
                      } else {
                        showMessage(description.toString(), 2);
                      }
                    }
                  }
                }
              }
            }
            log("ErrorHandler else ==>  " + description.toString());
          }
        } catch (ee) {
          log("ErrorHandler catch ==>  " + ee.toString());
          //   showMessage(e.response!.data.toString(), 2);
        }
        log("ErrorHandler DioError ==> " + e.response!.data.toString());
      } else {
        final ConnectivityResult result = await Connectivity().checkConnectivity();
        if (result == ConnectivityResult.none) {
          showMessage('يرجى التأكد من اتصالك بالإنترنت'.tr, 2);
          return false;
        }
      }
      return true;
    } else {
      log("ErrorHandler ==> " + e.toString());
      return true;
    }
  }

  static Future<void> generateSession(bool isCancel, {renewSession = false}) async {
    try {
      final ApiRequests _apiRequests = Get.find();
      final PrefManger _prefManger = Get.find();
      final CartLogic _cartLogic = Get.find();
      var response =
          isCancel ? await _apiRequests.cloneCart() : await _apiRequests.createSession();
      log(response.data.toString());
      var session = response.data['payload'][isCancel ? 'session_id' : 'cart_session_id'];
      log("new session => $session");
      await _prefManger.setSession(session);
      await _apiRequests.onInit();
      if (isCancel) {
        _cartLogic.getCartItems(true);
      } else {
        _cartLogic.getCartItems(true);
        if (!renewSession) {
          showMessage('حاول مجدداً'.tr, 2);
        }
      }
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
  }

  static void showErrorCartIsReserved(e) {
    String name = e.response!.data['message']['name'] ?? '';
    String code = e.response!.data['message']['code'] ?? '';
    String description = e.response!.data['message']['description'] ?? '';
    if (code != 'MSG_HIDDEN') {
      if (!(name.contains('cURL error') || description.contains('cURL error'))) {
        if (!(name.contains('500 Internal') || description.contains('500 Internal'))) {
          Get.snackbar(
            '',
            "",
            duration: const Duration(seconds: 5),
            titleText: const SizedBox(),
            messageText: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: CustomText(
                  name.toString().replaceAll('/n', '') + '، ' + description,
                  fontSize: 12,
                  color: Colors.black,
                )),
                InkWell(
                  onTap: () {
                    Get.back();
                    generateSession(true);
                  },
                  child: CustomText(
                    'إلغاء السلة'.tr,
                    fontWeight: FontWeight.w900,
                  ),
                )
              ],
            ),
            snackStyle: SnackStyle.GROUNDED,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            backgroundColor: Colors.yellow.shade700,
          );
        }
      }
    }
  }
}
