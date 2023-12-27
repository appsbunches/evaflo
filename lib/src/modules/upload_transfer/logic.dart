import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/remote/api_requests.dart';
import '../../entities/bank_response_model.dart';
import '../../utils/error_handler/error_handler.dart';
import '../../utils/functions.dart';

class UploadTransferLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final TextEditingController nameController = TextEditingController();
  bool isBanksLoading = false;
  bool isLoading = false;
  XFile? image;
  final scrollController = ScrollController();
  final isVisible = true.obs;

  BankResponseModel? selected;
  List<BankResponseModel> banksList = [];

  @override
  void onInit() {
    getStoreBanks();
    scrollController.addListener(() {
      double maxScrollExtent = scrollController.position.maxScrollExtent;
      double currentScrollPosition = scrollController.position.pixels;
      double screenHeight = Get.height;
      double screenVisibleHeight = screenHeight - kToolbarHeight;

      if (currentScrollPosition == maxScrollExtent - screenVisibleHeight) {
        isVisible.value = false;
      } else {
        isVisible.value = scrollController.position.userScrollDirection ==
            ScrollDirection.forward;
      }
    });
    super.onInit();
  }

  void setSelected(dynamic value) async {
    selected = value;
    update();
  }

  void pickPhoto({required bool isPhoto}) async {
    final ImagePicker _picker = ImagePicker();
//    if(await checkAndRequestCameraPermissions())
    image = await _picker.pickImage(
        source: isPhoto ? ImageSource.camera : ImageSource.gallery);
    update();
  }

  getStoreBanks() async {
    isBanksLoading = true;
    update();
    try {
      var response = await _apiRequests.getStoreBanks();
      banksList = (response.data['payload'] as List)
          .map((e) => BankResponseModel.fromJson(e))
          .toList();
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
    isBanksLoading = false;
    update();
  }

  uploadTransfer(String? orderCode) async {
    if (selected == null) {
      showMessage("يرجى اختيار البنك أولاً".tr, 2);
      return;
    }
    if (nameController.text.isEmpty) {
      showMessage("يرجى ادخال اسم المحول منه أولاً".tr, 2);
      return;
    }
    if (image == null) {
      showMessage("يرجى ارفاق صورة الحوالة أولاً".tr, 2);
      return;
    }
    isLoading = true;
    update();
    try {
      var response = await _apiRequests.uploadTransfer(
          image: image,
          storeBankId: selected?.id.toString(),
          senderName: nameController.text,
          orderCode: orderCode);
      Get.back();
      showMessage("تم ارسال الحوالة بنجاح".tr, 1);
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
    isLoading = false;
    update();
  }
}
