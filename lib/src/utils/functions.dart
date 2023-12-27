import 'dart:developer';
import 'dart:io';

import 'package:entaj/src/.env.dart';
import 'package:entaj/src/app_config.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../binding.dart';
import '../modules/_main/logic.dart';
import '../modules/_main/tabs/home/logic.dart';
import '../modules/delivery_option/view.dart';
import '../modules/faq/view.dart';
import '../modules/store_close/view.dart';
import '../colors.dart';
import '../modules/_main/view.dart';
import '../modules/page_details/view.dart';
import '../modules/search/view.dart';
import '/main.dart';
import '/src/entities/product_details_model.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_widget/custom_text.dart';

double checkDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return 0.0;
  if (value is List<int>) return value.isEmpty ? 0.0 : value.first.toDouble();
  if (value is List<double>) return value.isEmpty ? 0.0 : value.first;
  return 0.0;
}

String? getLabelInString(dynamic value) {
  if (value is String) return value;
  if (value is Label) {
    return (isArabicLanguage ? value.ar : value.en) ?? value.ar ?? value.en;
  }
  return null;
}

goToLink(String? link, {bool withoutBack = false, bool whenLaunchApp = false}) async {
  log(link.toString());
  if (link == null || link == '') return;
  if (link.contains('store_closed')) {
    Get.to(const StoreClosePage());
    return;
  }
  if (link.contains('privacy-policy') && !link.contains('blogs')) {
    final MainLogic _mainLogic = Get.find();
    Get.to(PageDetailsPage(
      type: 1,
      title: "سياسة الخصوصية والاستخدام".tr,
      pageModel: _mainLogic.pageModelPrivacy,
    ));
    return;
  }
  if (link.contains('refund-exchange-policy') && !link.contains('blogs')) {
    final MainLogic _mainLogic = Get.find();
    Get.to(PageDetailsPage(
      type: 2,
      title: "سياسة الإستبدال والاسترجاع".tr,
      pageModel: _mainLogic.pageModelRefund,
    ));
    return;
  }
  if (link.contains('terms-and-conditions') && !link.contains('blogs')) {
    final MainLogic _mainLogic = Get.find();
    Get.to(PageDetailsPage(
      type: 3,
      title: "الشروط والأحكام".tr,
      pageModel: _mainLogic.pageModelTerms,
    ));
    return;
  }
  if (link.contains('complaints-and-suggestions') && !link.contains('blogs')) {
    final MainLogic _mainLogic = Get.find();
    Get.to(PageDetailsPage(
      type: 6,
      title: "الشكاوى والاقتراحات".tr,
      pageModel: _mainLogic.pageModelSuggestions,
    ));
    return;
  }
  if (link.contains('/license') && !link.contains('blogs')) {
    final MainLogic _mainLogic = Get.find();
    Get.to(PageDetailsPage(
      type: 7,
      title: "التراخيص".tr,
      pageModel: _mainLogic.pageModelLicense,
    ));
    return;
  }
  if (link.contains('/faqs')) {
    Get.to(const FaqPage());
    return;
  }
  if (link.contains('/shipping-and-payment')) {
    Get.to(DeliveryOptionPage());
    return;
  }
  if (link.contains('/cart')) {
    if (whenLaunchApp) Get.off(const MainPage(), binding: Binding());
    final MainLogic _mainLogic = Get.find();
    _mainLogic.changeSelectedValue(2, true, backCount: 0);
    return;
  }
  if (link.contains('/blogs/') || link.contains('/pages/')) {
    Get.to(
        PageDetailsPage(
          type: 5,
          title: null,
          url: link,
        ),
        preventDuplicates: false);
    return;
  }
  if (link.contains('search')) {
    int indexOfSearch = link.indexOf('search');
    var searchQ = link.substring(indexOfSearch + 7);
    Get.to(SearchPage(searchQ: Uri.decodeFull(searchQ)));
    return;
  }
  if (link.contains('categories')) {
    try {
      var categoryId = link.substring(
          link.indexOf('categories') + 11, link.indexOf('categories') + 21);
      categoryId = categoryId.replaceAll(RegExp(r'[^0-9]'), '');
      log(categoryId.toString());
      if (withoutBack) Get.offAll(const MainPage(), binding: Binding());
      if (withoutBack) Get.put(HomeLogic());
      Get.toNamed("/category-details/$categoryId");
      return;
    } catch (e) {
      try {
        var categoryId = link.substring(
            link.indexOf('categories') + 11, link.indexOf('categories') + 20);
        categoryId = categoryId.replaceAll(RegExp(r'[^0-9]'), '');
        log(categoryId.toString());
        if (withoutBack) Get.offAll(const MainPage(), binding: Binding());
        if (withoutBack) Get.put(HomeLogic());
        Get.toNamed("/category-details/$categoryId");
        return;
      } catch (e) {
        if (whenLaunchApp) Get.off(const MainPage(), binding: Binding());
        Get.find<MainLogic>().changeSelectedValue(1, true, backCount: 0);
      }
      return;
    }
  } else if (link.contains('products')) {
    try {
      var productId = link.substring(link.indexOf('products') + 9, link.length);
      var url = Uri.encodeComponent(productId);
      if (withoutBack) Get.offAll(const MainPage(), binding: Binding());
      if (withoutBack) Get.put(HomeLogic());
      if (url == 'sale') {
        Get.toNamed('/category-details/arguments', arguments: {'filter': 'sale'});
      } else if (url == 'recent_products') {
        Get.toNamed('/category-details/arguments',
            arguments: {'filter': 'recent_products'});
      } else {
        Get.toNamed("/product-details/$url", arguments: {'backCount': '1'});
      }
      return;
    } catch (e) {
      Get.toNamed("/category-details/*");
      return;
    }
  } else if (whenLaunchApp && link.contains(storeUrl)) {
    Get.off(const MainPage(), binding: Binding());
    return;
  }
  if (Platform.isAndroid) {
    if (await canLaunch(link)) {
      await launch(link);
    }
  } else {
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link));
    }
  }
}

Future<bool> checkInternet() async {
  final ConnectivityResult result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    showMessage('يرجى التأكد من اتصالك بالإنترنت'.tr, 2);
    return false;
  }
  return true;
}

String calculateDiscount({required double salePriceTotal, required double priceTotal}) {
  if (salePriceTotal == 0 && priceTotal == 0) {
    return isArabicLanguage ? '0%-' : '-0%';
  }
  if (AppConfig.currentThemeId == asayelThemeId ||
      AppConfig.currentThemeId == zeyadaThemeId ||
      AppConfig.currentThemeId == softThemeId ||
      AppConfig.currentThemeId == perfectThemeId) {
    var discount = ((1 - (salePriceTotal / priceTotal)) * 100).ceil().toString();
    return isArabicLanguage ? '$discount%-' : '-$discount%';
  }
  var discount = ((1 - (salePriceTotal / priceTotal)) * 100).round().toString();
  return isArabicLanguage ? '$discount%-' : '-$discount%';
}

String replaceArabicNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(arabic[i], english[i]);
  }
  return input;
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}

int getMaxLength(String selectedCode) {
  var num = 9;
  if (selectedCode.contains('966')) num = 9;
  if (selectedCode.contains('971')) num = 9;
  if (selectedCode.contains('965')) num = 8;
  if (selectedCode.contains('968')) num = 8;
  if (selectedCode.contains('973')) num = 8;
  if (selectedCode.contains('974')) num = 8;
  if (selectedCode.contains('962')) num = 10;
  if (selectedCode.contains('20')) num = 10;

  return num;
}

String getCountyIP(String selectedCode) {
  String code = 'sa';
  if (selectedCode.contains('966')) code = 'sa';
  if (selectedCode.contains('971')) code = 'ae';
  if (selectedCode.contains('965')) code = 'kw';
  if (selectedCode.contains('968')) code = 'om';
  if (selectedCode.contains('973')) code = 'bh';
  if (selectedCode.contains('974')) code = 'qa';
  if (selectedCode.contains('962')) code = 'jo';
  if (selectedCode.contains('962')) code = 'jo';
  if (selectedCode.contains('20')) code = 'eg';

  return code;
}

Future<String?> getCustomerIP() async {
  for (var interface in await NetworkInterface.list()) {
    for (var address in interface.addresses) {
      return address.address;
    }
  }
  return null;
}

showMessage(String? text, int type, {int seconds = 3, double fontSize = 12}) {
  if ((text?.length ?? 0) == 0) return;
  Get.snackbar(
    '',
    "",
    duration: Duration(seconds: seconds),
    titleText: const SizedBox(),
    messageText: Row(
      children: [
        Expanded(
            child: CustomText(
          text,
          fontSize: fontSize,
          color: type == 1 ? Colors.white : Colors.black,
        )),
        Icon(
          type == 1 ? Icons.check_circle : Icons.error,
          color: type == 1 ? Colors.white : Colors.black,
        )
      ],
    ),
    snackStyle: SnackStyle.GROUNDED,
    margin: EdgeInsets.zero,
    backgroundColor: type == 1 ? successMessageColor : Colors.yellow.shade700,
  );
}

Map<String, Map<String, String>> cssToJSON(String css) {
  final styles = <String, Map<String, String>>{};

  // Split the CSS code into individual rules
  final rules = css.split('}');

  // Loop through each rule
  for (final rule in rules) {
    // Split the rule into a selector and a declaration block
    final parts = rule.split('{');
    if (parts.length < 2) continue; // Skip rules without a declaration block

    final selector = parts[0];
    final declaration = parts[1];

    // Split the selector into individual selectors
    final selectors = selector.split(',');

    // Loop through each selector
    for (final sel in selectors) {
      // Split the declaration block into individual declarations
      final declarations = declaration.split(';');

      // Loop through each declaration
      for (final decl in declarations) {
        // Split the declaration into a property and a value
        final propertyValue = decl.split(':');
        final property = propertyValue[0];
        final value = propertyValue[1];

        // If the property or value is not empty, add it to the styles map
        if (property.isNotEmpty && value.isNotEmpty) {
          styles.putIfAbsent(sel.trim(), () => <String, String>{});
          styles[sel.trim()]?[property.trim()] = value.trim();
        }
      }
    }
  }

  return styles;
}

launchWhatsapp(String whatsAppUrlString) async {
  log(whatsAppUrlString);
  Uri finalUrl = Uri.parse('');
  String? finalPhoneNumber;
  String? finalDescription;
  var settingPhone =
      Get.find<MainLogic>().settingModel?.footer?.socialMedia?.items?.phone ?? '';
  if (whatsAppUrlString.contains('https://wa.me')) {
    int startIndex = whatsAppUrlString.toString().indexOf('/', 10) + 1;
    int endIndex = whatsAppUrlString.toString().indexOf('?');
    finalPhoneNumber = whatsAppUrlString
        .substring(startIndex, endIndex)
        .replaceAll('966532331339', settingPhone);
    finalDescription = Uri.parse(whatsAppUrlString).queryParameters['text'];
    finalUrl = Uri.parse('whatsapp://send?phone=$finalPhoneNumber&text=$finalDescription'
        .replaceAll('+', ''));
    log(finalUrl.toString());
  } else {
    try {
      finalPhoneNumber = Uri.parse(whatsAppUrlString)
          .queryParameters['phone']
          ?.replaceAll('966532331339', settingPhone);
      finalDescription = Uri.parse(whatsAppUrlString).queryParameters['text'];
      finalUrl = Uri.parse(
          'whatsapp://send?phone=$finalPhoneNumber&text=$finalDescription'
              .replaceAll('+', ''));
      log(finalUrl.toString());
    } catch (e) {}
  }
  if (await canLaunchUrl(finalUrl)) {
    await launchUrl(finalUrl);
  } else {
    var uri = Uri.parse(whatsAppUrlString.replaceAll('966532331339', settingPhone));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await launchUrl(Uri.parse(
          'https://api.whatsapp.com/send/?phone=${finalPhoneNumber?.replaceAll('966532331339', settingPhone)}&text=$finalDescription'));
    }
  }
}
