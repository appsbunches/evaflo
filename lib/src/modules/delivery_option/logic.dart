import '../../app_config.dart';
import 'package:flutter/material.dart';

import '../../colors.dart';
import '../../data/remote/api_requests.dart';
import '../../entities/shipping_method_model.dart';
import '../../utils/error_handler/error_handler.dart';
import 'package:get/get.dart';

class DeliveryOptionLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  bool loading = false;
  List<ShippingMethodModel> listShippingMethods = [];
  List list = ['الخيار 1', 'الخيار 2', 'الخيار 3'];
  String? selected;

  @override
  void onInit() {
    super.onInit();
    getShippingMethods(false);
  }

  void setSelected(dynamic value) {
    selected = value;
    update();
  }

  void getShippingMethods(bool forceLoading) async {
    if (listShippingMethods.isNotEmpty && !forceLoading) {
      return;
    }
    loading = true;
    update();
    try {
      var response = await _apiRequests.getShippingMethods();
      listShippingMethods =
          (response.data['payload']['store_shipping_methods'] as List)
              .map((e) => ShippingMethodModel.fromJson(e))
              .toList();
      if (listShippingMethods.isEmpty) {
        AppConfig.showDeliveryOptions = false;
      }
    } catch (e,stacktrace) {
      ErrorHandler.handleError(e,stacktrace:stacktrace);
    }
    loading = false;
    update();
  }

  List<TextSpan> getSelectedCities(List<City> selectCities) {
    List<TextSpan> textSpanList = [];
    var cities = '';
    int count = 0;

    if (selectCities.length > 2) {
      for (int i = 0; i < 3; i++) {
        (count == 0)
            ? cities = cities + (selectCities[i].name ?? '')
            : cities = cities + " , " + (selectCities[i].name ?? '');
        count += 1;
      }

      if (selectCities.length - 3 == 0) {
        return [
          TextSpan(
              style: const TextStyle(
                  color: textColor ?? Colors.black,
                  fontWeight: AppConfig.showTextAsNormal
                      ? FontWeight.normal
                      : FontWeight.bold,
                  fontFamily: AppConfig.fontName,
                  fontSize: 14 + AppConfig.fontDecIncValue),
              text: cities)
        ];
      } else {
        return [
          TextSpan(
              style: const TextStyle(
                  color: textColor ?? Colors.black,
                  fontWeight: AppConfig.showTextAsNormal
                      ? FontWeight.normal
                      : FontWeight.bold,
                  fontFamily: AppConfig.fontName,
                  fontSize: 14 + AppConfig.fontDecIncValue),
              text: cities + " , "),
          TextSpan(
              style: const TextStyle(
                  color: textColor ?? Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConfig.fontName,
                  fontSize: 14 + AppConfig.fontDecIncValue),
              text: " مدن".tr + "${selectCities.length - 3}")
        ];
      }
    } else {
      for (var element in selectCities) {
        (count == 0)
            ? cities = cities + (element.name ?? '')
            : cities = cities + " , " + (element.name ?? '');
        count += 1;
      }
      return [
        TextSpan(
            style: const TextStyle(
                color: textColor ?? Colors.black,
                fontWeight: AppConfig.showTextAsNormal
                    ? FontWeight.normal
                    : FontWeight.bold,
                fontFamily: AppConfig.fontName,
                fontSize: 14 + AppConfig.fontDecIncValue),
            text: cities)
      ];
    }
  }
}
