import '../../app_config.dart';
import '../../data/hive/wishlist/hive_controller.dart';
import '../../data/hive/wishlist/wishlist_model.dart';
import '../../data/remote/api_requests.dart';
import '../../entities/product_details_model.dart';
import '../../services/app_events.dart';
import '../../utils/error_handler/error_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../entities/offer_response_model.dart';
import '../../utils/functions.dart';

class WishlistLogic extends GetxController with WidgetsBindingObserver {
  final ApiRequests _apiRequests = Get.find();
  final AppEvents _appEvents = Get.find();
  final TextEditingController searchController = TextEditingController();
  List<ProductDetailsModel> productsList = [];
  bool isProductsLoading = false;
  bool isUnderLoading = false;
  String? next;
  int mPage = 1;

  @override
  void onInit() {
    super.onInit();
    getProductsList();
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

  Future<void> getProductsList() async {
    var valueListenable = HiveController.getWishlist();
    final wishlist = valueListenable.values.toList().cast<WishlistModel>();
    if (wishlist.isEmpty) return;
    if (!await checkInternet()) return;
    isProductsLoading = true;
    try {
      update(['products']);
    } catch (e) {}
    try {
      String? idsListString;
      for (var element in wishlist) {
        if (idsListString == null) {
          idsListString = element.productId;
          continue;
        }
        idsListString = '$idsListString,${element.productId}';
      }
      idsListString?.replaceAll('null,', '');
      var response = await _apiRequests.getProductsListByIds(
          ids__in: idsListString, pageSize: idsListString?.length ?? 0);

      var newList = (response.data['results'] as List)
          .map((element) => ProductDetailsModel.fromJson(element))
          .toList();
      productsList = newList;

      List<String> productsIds = [];
      for (var element in productsList) {
        if (element.id != null) {
          productsIds.add(element.id!);
        }
      }

      if (AppConfig.showProductOffer) {
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
      }
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
    isUnderLoading = false;
    isProductsLoading = false;
    update(['products']);
  }

  void removeItem(String? id) {
    productsList.removeWhere((element) => element.id == id);
    update(['products']);
  }
}
