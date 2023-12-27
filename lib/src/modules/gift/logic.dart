import 'dart:convert';
import 'dart:developer';

import 'package:entaj/src/data/remote/api_requests.dart';
import 'package:entaj/src/data/shared_preferences/pref_manger.dart';
import 'package:entaj/src/entities/GiftCardDetailsModel.dart';
import 'package:entaj/src/modules/_main/logic.dart';
import 'package:entaj/src/modules/cart/logic.dart';
import 'package:entaj/src/utils/error_handler/error_handler.dart';
import 'package:entaj/src/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../_auth/login/view.dart';

class GiftLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final PrefManger _prefManger = Get.find();
  final nameController = TextEditingController();
  final receiverNameController = TextEditingController();
  final urlController = TextEditingController();
  final messageController = TextEditingController();
  String? selectedFile;
  bool isLoading = false;
  List? list;

  @override
  onInit() {
    list = jsonDecode((Get.find<MainLogic>()
            .settingModel
            ?.settings
            ?.giftOrderSettingsModel
            ?.giftOrderCardCustomTemplateDesign) ??
        '') as List?;
    super.onInit();
  }

  onChangeFile(String? file) {
    selectedFile = file;
    update(['files']);
  }

  handleFields(GiftCardDetailsModel? giftCardDetails) async {
    nameController.text = giftCardDetails?.senderName ?? '';
    receiverNameController.text = giftCardDetails?.receiverName ?? '';
    urlController.text = giftCardDetails?.mediaLink ?? '';
    messageController.text = giftCardDetails?.giftMessage ?? '';
    selectedFile =
        giftCardDetails?.cardDesign?.replaceAll('{\"file\": ', '').replaceAll('}', '') ??
            list?.firstOrNull?['file'];
  }

  saveGift() async {
    if (!await _prefManger.getIsLogin()) {
      Get.to(LoginPage());
      return;
    }
    isLoading = true;
    update(['save']);
    try {
      var res = await _apiRequests.addCartGift(
        senderName: nameController.text,
        receiverName: receiverNameController.text,
        mediaLink: urlController.text,
        giftMessage: messageController.text,
        cardDesign: selectedFile,
      );
      await Get.find<CartLogic>().getCartItems(true);
      Get.back();
      showMessage(res.data['message'], 1);

      log(res.data.toString());
    } catch (e, s) {
      ErrorHandler.handleError(e, stacktrace: s);
    }
    isLoading = false;
    update(['save']);
  }
}
