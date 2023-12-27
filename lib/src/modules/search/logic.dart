import 'dart:async';

import 'package:dio/dio.dart' as di;

import '../../data/remote/api_requests.dart';
import '../../entities/product_details_model.dart';
import '../../services/app_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../entities/offer_response_model.dart';
import '../../utils/functions.dart';

class SearchLogic extends GetxController with WidgetsBindingObserver {
  final ApiRequests _apiRequests = Get.find();
  final AppEvents _appEvents = Get.find();
  final TextEditingController searchController = TextEditingController();
  List<ProductDetailsModel> productsList = [];
  bool isProductsLoading = false;
  bool isUnderLoading = false;
  bool isCanceled = false;
  String? lastValue;
  String? next;
  int mPage = 1;

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (searchController.text.isEmpty) {
          isProductsLoading = false;
          isCanceled = true;
          clearResult();
          return;
        }
        isCanceled = false;
        if (searchController.text[searchController.text.length - 1] == ' ' ||
            lastValue == searchController.text) {
          return;
        }
        mPage = 1;
        getProductsList(q: searchController.text, page: mPage, forPagination: false);
      });
    });
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<di.Response>? response;

  Future<void> getProductsList(
      {String? q, required int page, required bool forPagination}) async {
    if (lastValue == q && !forPagination) return;
    if (forPagination) isUnderLoading = true;
    lastValue = q;
    if (!forPagination) productsList = [];
    if (q?.isEmpty == true) {
      try {
        if (!forPagination) update(['products']);
        return;
      } catch (e) {}
    }

    if (!await checkInternet()) return;

    _appEvents.logSearchEvent(q ?? '');
    if (productsList.isEmpty) isProductsLoading = true;
    try {
      update(['products']);
    } catch (e) {}

    response?.ignore();
    response =
    await _apiRequests.getProductsList(q: lastValue, page: page).then((value) async {
      if (isCanceled) return;
      next = value.data['next'];

      var newList = (value.data['results'] as List)
          .map((element) => ProductDetailsModel.fromJson(element))
          .toList();

      if (forPagination) {
        productsList.addAll(newList);
      } else {
        productsList = newList;
      }

      List<String> productsIds = [];
      for (var element in productsList) {
        if (element.id != null) {
          productsIds.add(element.id!);
        }
      }

      var res = await _apiRequests.getSimpleBundleOffer(productsIds);
      List<OfferResponseModel> offerList = (res.data['payload'] as List)
          .map((e) => OfferResponseModel.fromJson(e))
          .toList();

      for (var elementProduct in productsList) {
        for (var elementOffer in offerList) {
          if (elementOffer.productIds?.contains(elementProduct.id) == true) {
            elementProduct.offerLabel = elementOffer.name;
          }
        }
      }
    }).onError((error, stackTrace) {
      next = null;
    });

    isUnderLoading = false;
    isProductsLoading = false;
    update(['products']);
  }

  clearResult() {
    searchController.text = '';
    productsList = [];
    update(['products']);
  }
}
