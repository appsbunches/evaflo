import 'dart:async';

import 'package:dio/dio.dart';

import '../../../app_config.dart';
import '../../../data/remote/api_requests.dart';
import '../../../entities/success_api_response.dart';
import '../../../utils/error_handler/error_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../utils/functions.dart';
import '../../_main/logic.dart';
import '../../page_details/view.dart';
import '../otp/view.dart';
import '../register/view.dart';

class LoginLogic extends GetxController with WidgetsBindingObserver {
  final ApiRequests _apiRequests = Get.find();

  final TextEditingController phoneController = TextEditingController();
  bool isEmail = false;
  bool isLoading = false;
  bool isButtonEnable = true;
  String? selectedCode;
  Timer? timer;

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

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  changeCodeSelected(String? newCode) {
    selectedCode = newCode;
    update();
  }

  void login() async {
    isLoading = true;
    update();
    try {
      var ip = await getCustomerIP();
      var response = await _apiRequests.login(
          selectedCode ?? AppConfig.countriesCodes.first, phoneController.text,
          customerIPCountry: getCountyIP(selectedCode ?? AppConfig.countriesCodes.first),
          customerIP: ip,
          isEmail: isEmail);
      isLoading = false;
      isButtonEnable = false;
      update();
      Timer.periodic(const Duration(seconds: 60), (timer) {
        isButtonEnable = true;
        update();
      });
      SuccessApiResponse successApiResponse = SuccessApiResponse.fromJson(response.data);
      if (successApiResponse.payload?.status == 'registration_needed') {
        Get.to(RegisterPage(isEmail: isEmail));
      } else {
        Get.to(OtpPage(
          isEmail: isEmail,
          isForRegistration: false,
        ));
      }
    } catch (e, stacktrace) {
      if (e is DioError) {
        if (e.response?.data.toString().contains('Too Many Attempts') == true) {
          showMessage('عذراً، حاول مجدداً بعد دقيقة'.tr, 2, seconds: 7);
          isButtonEnable = false;
          update();
          timer?.cancel();
          timer = Timer.periodic(const Duration(seconds: 60), (timer) {
            isButtonEnable = true;
            update();
          });
        }
      }
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }

    isLoading = false;
    update();
  }

  changeEmailPhone(context) {
    isEmail = !isEmail;
    phoneController.text = '';
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      Future.delayed(const Duration(milliseconds: 100))
          .then((value) => currentFocus.requestFocus());
    }
    update();
  }

  goToPrivacyPolices() {
    Get.to(PageDetailsPage(
      type: 1,
      title: null,
      pageModel: Get.find<MainLogic>().pageModelPrivacy,
    ));
  }
}
