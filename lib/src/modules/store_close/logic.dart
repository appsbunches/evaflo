import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/remote/api_requests.dart';

import '../../utils/error_handler/error_handler.dart';
import '../../utils/functions.dart';

class StoreCloseLogic extends GetxController {
  final TextEditingController closeEmailController = TextEditingController();
  bool isLoading = false;

  addAvailability() async {
    isLoading = true;
    update();
    try {
      var response = await Get.find<ApiRequests>().notifyMeStore(closeEmailController.text);
      log(response.data.toString());
      closeEmailController.text = '';
      showMessage("تمت العملية بنجاح".tr, 1);

    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
    isLoading = false;
    update();
  }
}
