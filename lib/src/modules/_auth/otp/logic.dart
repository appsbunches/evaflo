import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import '../../../app_config.dart';
import '../../../data/remote/api_requests.dart';
import '../../../data/shared_preferences/pref_manger.dart';
import '../../../entities/success_api_response.dart';
import '../../../utils/functions.dart';
import '../../_main/logic.dart';
import '../../cart/logic.dart';
import '../../../utils/error_handler/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../login/logic.dart';

class OtpLogic extends GetxController with WidgetsBindingObserver {
  final ApiRequests _apiRequests = Get.find();
  final PrefManger _prefManger = Get.find();
  final CartLogic _cartLogic = Get.find();
  final TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
  StreamController<ErrorAnimationType>();

  bool isLoading = false;
  bool isResendLoading = false;
  bool isFull = false;
  bool isEmail = false;
  bool isForRegistration = false;
  String errorText = "";
  int counter = 60;

  LoginLogic loginLogic = Get.find();

  @override
  void onInit() {
    startCounter();
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        FocusScopeNode currentFocus = FocusScope.of(Get.context!);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void confirmPhone() async {
    isLoading = true;
    update();

    await getSession();

    otpController.text = replaceArabicNumber(otpController.text);
    try {
      log(isEmail.toString());
      var response = await _apiRequests.confirmAccount(
          otpController.text,
          (isEmail ? '' : loginLogic.selectedCode ?? AppConfig.countriesCodes.first) +
              loginLogic.phoneController.text,
          isEmail: isEmail);
      log(response.data.toString());
      if (response.data['message'] != null) {
        errorController.add(ErrorAnimationType.shake);
        try {
          errorText = response.data['message']['description'].toString();
          showMessage(errorText, 2);
        } catch (ee) {}
      } else {
        SuccessApiResponse successApiResponse =
        SuccessApiResponse.fromJson(response.data);

        await _prefManger.setToken(successApiResponse.payload?.customerAccessToken);
        await _prefManger.setSession(successApiResponse.payload?.cartSessionId);
        await _prefManger.setIsLogin(true);
        await _apiRequests.onInit();

        _cartLogic.getCartItems(true);

        if (isForRegistration) Get.back(result: 'success');
        Get.back(result: 'success');
        Get.back(result: 'success');
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          errorController.add(ErrorAnimationType.shake);
          try {
            errorText = e.response!.data['message']['description'].toString();
          } catch (ee) {}
        }
      }
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  Future<void> getSession() async {
    if (await _prefManger.getSession() == '') {
      try {
        var response = await _apiRequests.createSession();
        var session = response.data['payload']['cart_session_id'];
        log("new session => $session");
        await _prefManger.setSession(session);
        await _apiRequests.onInit();
      } catch (e) {
        ErrorHandler.handleError(e);
      }
    }
  }

  Future<void> resendCode() async {
    isResendLoading = true;
    update(['resend']);
    try {
      var ip = await getCustomerIP();
      var response = await _apiRequests.login(
          loginLogic.selectedCode ?? AppConfig.countriesCodes.first,
          loginLogic.phoneController.text,
          customerIPCountry:
          getCountyIP(loginLogic.selectedCode ?? AppConfig.countriesCodes.first),
          customerIP: ip,
          isEmail: isEmail);

      startCounter();
      log(response.data.toString());
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }

    isResendLoading = false;
    update(['resend']);
  }

  void startCounter() async {
    counter = 60;
    while (counter > 0) {
      counter--;
      update(['resend']);
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
