import 'dart:developer';
import 'dart:io';

import 'package:entaj/src/entities/FilterModel.dart';

import '../../app_config.dart';

import '../../../main.dart';
import '../../data/remote/api_requests.dart';
import '../../entities/country_model.dart';
import '../../entities/offer_response_model.dart';
import '../../entities/category_model.dart';
import '../../entities/product_details_model.dart';
import '../_main/logic.dart';
import 'filter_dialog.dart';
import '../search/view.dart';
import '../../utils/error_handler/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'new_filteration_dialog.dart';
import 'select_city_dialog.dart';

class CategoryDetailsLogic extends GetxController with WidgetsBindingObserver {
  late ScrollController scrollController;

  late String categoryId;
  final ApiRequests _apiRequests = Get.find();
  bool hasInternet = true;
  bool isCategoryLoading = false;
  bool isProductsLoading = false;
  bool isUnderLoading = false;
  bool filter = false;
  bool hideHeaderFooter = false;
  bool showJustDiscount = false;
  CategoryModel? categoryModel;
  String? filterUrl;
  String? cities;
  String? ordering;
  String? next;
  String? name;
  int mPage = 1;
  List<String> sortList = [
    'الأفتراضي'.tr,
    'الأحدث'.tr,
    'الأكثر شعبية'.tr,
    'الأقل سعر'.tr,
    'الأعلى سعر'.tr
  ];
  String? selectedSort;
  List<ProductDetailsModel> productsList = [];
  TextEditingController startPriceController = TextEditingController();
  TextEditingController endPriceController = TextEditingController();
  RangeValues rangeValues = const RangeValues(0, 1);
  List<CategoryModel> subCategories = [];
  CountryModel? selectedCountryModel;
  CountryModel? selectedCityModel;
  FilterModel? filterModel;
  List<String?> attributeValues = [];
  String productsUrl = '';

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
    categoryId = Get.parameters['categoryId'] ?? '';
    scrollController = ScrollController();
    startPriceController.text = '';
    endPriceController.text = '';
    filter = false;
    categoryId = categoryId;
    if (categoryId == 'arguments') {
      var argument = Get.arguments as Map;
      filterUrl = argument['filter'];
      name = argument['name'];
      ordering = filterUrl?.contains('sale') == true ? getOrdering() : 'display_order';
      ordering =
          filterUrl?.contains('recent_products') == true ? '-created_at' : getOrdering();

      if (filterUrl?.contains('popularity_order') == true) {
        onSortChanged(sortList[2]);
      }
      if (filterUrl?.contains('recent_products') == true) {
        onSortChanged(sortList[1]);
      }
      if (filterUrl?.contains('sale') == true) {
        onSortChanged(sortList[1]);
      }
    } else {
      getCategoryDetails(categoryId);
    }

    //   clearAndFetch();
    scrollController.addListener(_reviewsScrollListener);
    WidgetsBinding.instance.addObserver(this);
  }

  void _reviewsScrollListener() async {
    try {
      var scrollable = Platform.isAndroid
          ? !scrollController.position.outOfRange
          : scrollController.position.outOfRange;
      if (scrollController.offset >= scrollController.position.maxScrollExtent &&
          scrollable &&
          isUnderLoading == false) {
        if (next != null) {
          getProductsList(
              page: ++mPage, forPagination: true, mHideHeaderFooter: hideHeaderFooter);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  void openFilterDialog(categoryId) {
    if (AppConfig.newFiltrationMode) {
      Get.bottomSheet(
          NewFiltrationDialog(categoryId: hideHeaderFooter ? 'lite' : categoryId),
          isScrollControlled: true);
    } else {
      Get.dialog(FilterDialog(categoryId: hideHeaderFooter ? 'lite' : categoryId));
    }
  }

  void goToSearch() {
    Get.to(const SearchPage());
  }

  void onChangeDiscountSelected() {
    showJustDiscount = !showJustDiscount;
    update();
  }

  changeRange(RangeValues value) {
    rangeValues = value;
    update();
  }

  getCategoryDetails(String categoryId) async {
    categoryModel = null;
    isCategoryLoading = true;
    update();
    try {
      var response = await _apiRequests.getCategoryDetails(categoryId);
      categoryModel = CategoryModel.fromJson(response.data['payload']);
      subCategories = categoryModel?.subCategories ?? [];

      if (AppConfig.isEnglishLanguageEnable) {
        bool hasContent = true;
        for (var element in subCategories) {
          if (element.name?.isNotEmpty != true) hasContent = false;
        }
        if (!hasContent) {
          var apiRequestOther =
              Get.find<ApiRequests>(tag: isArabicLanguage ? 'en' : 'ar');
          await apiRequestOther.onInit();
          var responseOther = await apiRequestOther.getCategoryDetails(categoryId);
          categoryModel = CategoryModel.fromJson(responseOther.data['payload']);

          for (var element in subCategories) {
            int elementIndex = subCategories.indexOf(element);
            if (element.name?.isNotEmpty != true) {
              element.name = subCategories[elementIndex].name;
            }
          }
          subCategories = categoryModel?.subCategories ?? [];
        }
      }
    } catch (e) {
      //  ErrorHandler.handleError(e);
    }
    isCategoryLoading = false;
    update();
  }

  getProductsList(
      {int page = 1,
      required bool forPagination,
      required bool mHideHeaderFooter}) async {
    hasInternet = true;
    hideHeaderFooter = mHideHeaderFooter;
    if (productsList.isEmpty) isProductsLoading = true;
    if (forPagination && productsList.isNotEmpty) isUnderLoading = true;
    update();
    try {
      var response = hideHeaderFooter
          ? await _apiRequests.getProductsList(
              page: page,
              ordering: ordering,
              sale_price__isnull: filterUrl?.contains('sale') == true || showJustDiscount,
              listingPriceGte: filter ? startPriceController.text : null,
              listingPriceLte: filter ? endPriceController.text : null,
              attributeValues: attributeValues)
          : await _apiRequests.getProductsList(
              categoryList: filterUrl != null
                  ? null
                  : categoryId == '*'
                      ? null
                      : [categoryId],
              page: page,
              sale_price__isnull: filterUrl?.contains('sale') == true || showJustDiscount,
              ordering: ordering,
              cities: cities,
              listingPriceGte: filter ? startPriceController.text : null,
              listingPriceLte: filter ? endPriceController.text : null,
              attributeValues: attributeValues);
      productsUrl = response.realUri.toString();
      var newList = (response.data['results'] as List)
          .map((element) => ProductDetailsModel.fromJson(element))
          .toList();
      productsList.addAll(newList);
      next = response.data['next'];

      if (AppConfig.isEnglishLanguageEnable) {
        bool hasContent = true;
        for (var element in productsList) {
          if (element.name?.isNotEmpty != true) hasContent = false;
        }
        if (!hasContent) {
          var apiRequestOther =
              Get.find<ApiRequests>(tag: isArabicLanguage ? 'en' : 'ar');
          await apiRequestOther.onInit();
          var responseOther = hideHeaderFooter
              ? await apiRequestOther.getProductsList(
                  page: page,
                  ordering: ordering,
                  listingPriceGte: filter ? startPriceController.text : null,
                  listingPriceLte: filter ? endPriceController.text : null)
              : await apiRequestOther.getProductsList(
                  categoryList: filterUrl != null
                      ? null
                      : categoryId == '*'
                          ? null
                          : [categoryId],
                  page: page,
                  sale_price__isnull: filterUrl?.contains('sale'),
                  ordering: ordering,
                  listingPriceGte: filter ? startPriceController.text : null,
                  listingPriceLte: filter ? endPriceController.text : null);

          var productsListOther = [];
          var otherList = (responseOther.data['results'] as List)
              .map((element) => ProductDetailsModel.fromJson(element))
              .toList();
          productsListOther.addAll(otherList);

          for (var element in productsListOther) {
            int elementIndex = productsListOther.indexOf(element);
            if (element.name?.isNotEmpty != true) {
              element.name = productsListOther[elementIndex].name;
            }
          }
        }
      }

      if (AppConfig.showProductOffer) {
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
      }
      filterModel = FilterModel.fromJson(response.data['filters']);
    } catch (e) {
      hasInternet = await ErrorHandler.handleError(e);
    }
    isProductsLoading = false;
    isUnderLoading = false;
    update();
  }

  String? getOrdering() {
    if (!AppConfig.isSoreUseNewTheme) {
      if (selectedSort == sortList[0]) {
        ordering = '-display_order';
        return '-display_order';
      }
    }
    if (selectedSort == sortList[1]) {
      ordering = '-created_at';
      return '-created_at';
    }
    if (selectedSort == sortList[2]) {
      ordering = 'popularity_order';
      return 'popularity_order';
    }
    if (selectedSort == sortList[3]) {
      ordering = 'price';
      return 'price';
    }
    if (selectedSort == sortList[4]) {
      ordering = '-price';
      return '-price';
    }
    ordering = null;
    return null;
  }

  void onSortChanged(String? value) {
    selectedSort = value;
    getOrdering();
    clearAndFetch();
    update();
  }

  restPrice() {
    showJustDiscount = false;
    filter = false;
    startPriceController.text = '';
    endPriceController.text = '';
    attributeValues = [];
    rangeValues = const RangeValues(0, 1);
    clearAndFetch();
    update();
  }

  filterPrices() {
    filter = true;
    clearAndFetch();
    Get.back();
  }

  int getBackCount(String categoryId) {
    int backCount = 1;
    final MainLogic mainLogic = Get.find<MainLogic>();
    var categories = mainLogic.categoriesList;

    for (var element in categories) {
      if (element.ids.contains(categoryId)) {
        int index = element.ids.indexOf(categoryId);
        int realIndex = element.ids.length - index;
        backCount = realIndex;
      }
    }
    return backCount;
  }

  Future<void> clearAndFetch({bool removeFilter = false}) async {
    if (removeFilter) {
      filter = false;
      startPriceController.text = '';
      endPriceController.text = '';
      rangeValues = const RangeValues(0, 1);
    }
    productsList = [];
    next = null;
    mPage = 1;
    await getProductsList(
      forPagination: false,
      mHideHeaderFooter: hideHeaderFooter,
    );
  }

  openCitesFilter(String categoryId) {
    selectedCountryModel =
        Get.find<MainLogic>().settingModel?.header?.destinations?.countries?.first;
    selectedCityModel = selectedCountryModel?.cities?.first;
    Get.dialog(SelectCityDialog(
      categoryId: categoryId,
    ));
  }

  void filterCities() {
    cities = selectedCityModel?.id.toString();
    clearAndFetch();
    getProductsList(forPagination: false, mHideHeaderFooter: false);
    Get.back();
  }

  onChangeCountry(CountryModel? val) {
    selectedCountryModel = val;
    selectedCityModel = val?.cities?.first;
    update(['SelectCityDialog']);
  }

  onChangeCity(CountryModel? val) {
    selectedCityModel = val;
    update(['SelectCityDialog']);
  }
}
