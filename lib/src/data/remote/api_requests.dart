import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart' as ge;
import 'package:image_picker/image_picker.dart';

import '../../../main.dart';
import '../../.env.dart';
import '../hive/wishlist/hive_controller.dart';
import '../shared_preferences/pref_manger.dart';

class ApiRequests extends ge.GetxController {
  final String? tag;
  final PrefManger _prefManger = ge.Get.find();
  late Dio _dioV2;
  late Dio _dioV1;
  late Dio _dioAppBuilder;

  ApiRequests({this.tag});

  @override
  Future<void> onInit() async {
    String session = await _prefManger.getSession();
    String authorizationToken = AUTHORIZATION_TOKEN;
    String accessToken = ACCESS_TOKEN;
    String customerToken = await _prefManger.getToken();
    bool isFromRemote = await _prefManger.getIsFromRemote();

    log('session => $session');
    if (isFromRemote) {
      accessToken = await _prefManger.getAccessToken();
      authorizationToken = await _prefManger.getAuthorizationToken();
      if (accessToken == '') {
        await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 1),
        ));
        await remoteConfig.ensureInitialized();
        try {
          await remoteConfig.fetchAndActivate();
        } catch (e) {}
        accessToken = remoteConfig.getString(ACCESS_TOKEN_KEY);
        await _prefManger.setAccessToken(accessToken);
      }
      if (authorizationToken == '') {
        authorizationToken = remoteConfig.getString(AUTHORIZATION_TOKEN_KEY);
        await _prefManger.setAuthorizationToken(authorizationToken);
      }

      await _prefManger.setIsFromRemote(true);
    }

    _dioV2 = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: 120000),
        receiveTimeout: const Duration(milliseconds: 120000),
        queryParameters: HiveController.generalBox.get('city') == null
            ? {}
            : {
                'cities': HiveController.generalBox.get('city'),
                'city': HiveController.generalBox.get('city'),
              },
        headers: {
          'store-id': storeId,
          'source': 'mobile_app',
          'ROLE': 'Manager',
          'Accept': accept,
          'X-CUSTOMER-TOKEN': customerToken,
          'x-manager-token': accessToken,
          'CART-SESSION-ID': session,
          if (HiveController.generalBox.get('currency') != null)
            'currency': HiveController.generalBox.get('currency'),
          if (HiveController.generalBox.get('city') != null)
            'Destination-City': HiveController.generalBox.get('city'),
          'Accept-Language': tag ?? (isArabicLanguage ? 'ar' : 'en'),
          'Authorization': 'Bearer $authorizationToken',
          'hide-header-footer': true
        }));

    _dioV1 = Dio(BaseOptions(
        baseUrl: baseUrlV1,
        connectTimeout: const Duration(milliseconds: 120000),
        // 120 seconds
        receiveTimeout: const Duration(milliseconds: 120000),
        // 120 seconds
        queryParameters: HiveController.generalBox.get('city') == null
            ? {}
            : {
                'cities': HiveController.generalBox.get('city'),
                'city': HiveController.generalBox.get('city'),
              },
        headers: {
          'store-id': storeId,
          'Accept': accept,
          'source': 'mobile_app',
          'ROLE': 'CUSTOMER',
          if (HiveController.generalBox.get('currency') != null)
            'currency': HiveController.generalBox.get('currency'),
          if (HiveController.generalBox.get('city') != null)
            'Destination-City': HiveController.generalBox.get('city'),
          'X-CUSTOMER-TOKEN': customerToken,
          'x-manager-token': accessToken,
          'CART-SESSION-ID': session,
          'Accept-Language': tag ?? (isArabicLanguage ? 'ar' : 'en'),
          'Authorization': 'Bearer $authorizationToken',
          'hide-header-footer': true
        }));

    _dioAppBuilder = Dio(BaseOptions(
        baseUrl: baseUrlAppBuilder,
        connectTimeout: const Duration(milliseconds: 120000),
        receiveTimeout: const Duration(milliseconds: 120000),
        queryParameters: HiveController.generalBox.get('city') == null
            ? {}
            : {
                'cities': HiveController.generalBox.get('city'),
                'city': HiveController.generalBox.get('city'),
              },
        headers: {
          'store_id': storeId,
          'access_token': accessToken,
          'authorization': authorizationToken,
          if (HiveController.generalBox.get('city') != null)
            'Destination-City': HiveController.generalBox.get('city'),
          if (HiveController.generalBox.get('currency') != null)
            'currency': HiveController.generalBox.get('currency'),
        }));
    _dioV1.interceptors.add(CurlLoggerDioInterceptor());
    _dioV2.interceptors.add(CurlLoggerDioInterceptor());
    super.onInit();
  }

  ///---------------------- App Builder ----------------------///
  ///Sections
  Future<Response> getAppBuilderSections() async {
    await onInit();
    return await _dioAppBuilder.get("sections");
  }

  ///Sections
  Future<Response> getAppBuilderColors() async {
    await onInit();
    return await _dioAppBuilder.get("custom_color_bars");
  }

  ///---------------------- Catalog -- Store ----------------------///

  Future<Response> getCategories() async {
    return await _dioV2.get("catalog/stores/$storeId/categories");
  }

  Future<Response> getCategoryDetails(String? categoryId) async {
    return await _dioV2.get("catalog/stores/$storeId/categories/$categoryId");
  }

  Future<Response> getHomeScreen() async {
    return await _dioV2.get("catalog/stores/$storeId/landing-page");
  }

  Future<Response> getHomeScreenNewTheme(String? themeId) async {
    var request = await _dioV2.get(
        "catalog/stores/$storeId/storefront-themes/$themeId/files/layout?template=home.twig");
    //log(request.realUri.toString());
    return request;
  }

  Future<Response> getStoreSetting() async {
    return await _dioV2.get("catalog/stores/$storeId/layout-setting",
        options: Options(headers: {'CART-SESSION-ID': ''}));
  }

  Future<Response> getShippingMethods() async {
    await onInit();
    return await _dioV2.get("catalog/stores/$storeId/payment-and-shipping-methods");
  }

  Future<Response> getPrivacyPolicy() async {
    return await _dioV2.get("catalog/stores/$storeId/privacy-policy");
  }

  Future<Response> getComplaintsAndSuggestions() async {
    return await _dioV2.get("catalog/stores/$storeId/complaints-and-suggestions");
  }

  Future<Response> getRefundPolicy() async {
    return await _dioV2.get("catalog/stores/$storeId/refund-exchange-policy");
  }

  Future<Response> getTermsAndConditions() async {
    return await _dioV2.get("catalog/stores/$storeId/terms-conditions");
  }

  Future<Response> getLicense() async {
    return await _dioV2.get("catalog/stores/$storeId/license");
  }

  ///---------------------- Catalog -- Pages ----------------------///
  Future<Response> getPages() async {
    return await _dioV2.get("catalog/stores/$storeId/pages");
  }

  Future<Response> getPagesDetails({int? pageId}) async {
    return await _dioV2.get("catalog/stores/$storeId/pages/$pageId");
  }

  Future<Response> getPagesDetailsBySlug({String? slug}) async {
    var url = "catalog/stores/$storeId/pages/slug/${slug?.replaceAll('/', '')}";
    log(url.toString());
    return await _dioV2.get(url.toString());
  }

  Future<Response> getFaqs() async {
    return await _dioV2.get("catalog/stores/$storeId/pages/faqs");
  }

  ///---------------------- Catalog -- Customer ----------------------///
  /// Auth
  Future<Response> register(
      String countryCode, String mobileNumber, String name, String email,
      {required bool isEmail}) async {
    return await _dioV2.post("catalog/customers/register${isEmail ? '-email' : ''}",
        data: FormData.fromMap({
          'name': name,
          'email': email,
          'country_code': countryCode,
          'mobile_number': mobileNumber,
        }));
  }

  Future<Response> login(String countryCode, String mobileNumber,
      {required bool isEmail, String? customerIP, String? customerIPCountry}) async {
    return await _dioV2.post("catalog/customers/login${isEmail ? '/email' : ''}",
        options: Options(headers: {
          'CUSTOMER-IP': customerIP,
          'CUSTOMER-IP_COUNTRY': customerIPCountry,
        }),
        data: FormData.fromMap(isEmail
            ? {'email': mobileNumber}
            : {
                'country_code': countryCode,
                'mobile_number': mobileNumber,
              }));
  }

  Future<Response> confirmAccount(String code, String mobileNumber,
      {required bool isEmail}) async {
    return await _dioV2.post("catalog/customers/login/verify${isEmail ? '-email' : ''}",
        data: FormData.fromMap({
          'code': code,
          if (isEmail) 'email': mobileNumber,
          if (!isEmail) 'mobile_number': mobileNumber,
        }));
  }

  Future<Response> logout() async {
    return await _dioV2.post("catalog/customers/logout");
  }

  ///Profile
  Future<Response> getAccountDetails() async {
    await onInit();
    return await _dioV2.get("catalog/customers/profile");
  }

  Future<Response> editAccountDetails(String name, String email) async {
    return await _dioV2.post("catalog/customers/profile",
        data: FormData.fromMap({
          'name': name,
          'email': email,
          '_method': 'put',
        }));
  }

  Future<Response> deleteAccount() async {
    return await _dioV2.delete(
      "catalog/customers/profile",
    );
  }

  /// Orders
  Future<Response> getOrders() async {
    return await _dioV2.get("catalog/customers/store/$storeId/orders");
  }

  Future<Response> getOrdersDetails(String orderCode) async {
    log("ORDER ID => $orderCode");
    return await _dioV2.get("catalog/stores/$storeId/orders/$orderCode/invoice");
  }

  ///---------------------- Catalog -- Cart ----------------------///
  Future<Response> createSession() async {
    return await _dioV2.post("catalog/stores/$storeId/carts",
      options: Options(headers: {
        'source': 'mobile_app',
      }),
    );
  }

  Future<Response> deleteSession() async {
    return await _dioV2.delete("catalog/stores/$storeId/carts",
      options: Options(headers: {
        'source': 'mobile_app',
      }),
    );
  }

  Future<Response> getCart() async {
    var request = await _dioV2.get("catalog/stores/$storeId/carts",
      options: Options(headers: {
        'source': 'mobile_app',
      }),
    );
    log(request.realUri.toString());
    return request;
  }

  Future<Response> cloneCart() async {
    return await _dioV2.post("catalog/stores/$storeId/carts/clone",
        options: Options(headers: {'CURRENCY': null, 'currency': null,'source': 'mobile_app',}));
  }

  Future<Response> verifyCart() async {
    return await _dioV2.post("catalog/stores/$storeId/carts/verify",
      options: Options(headers: {
        'source': 'mobile_app',
      }),
    );
  }

  Future<Response> getDiscountRules() async {
    return await _dioV2.get("catalog/stores/$storeId/discount-rules");
  }

  Future<Response> addCartItem({
    required String productId,
    required String quantity,
    required bool hasFields,
    List? customFieldsList,
  }) async {
    var requestBody = {
      "id": productId,
      "quantity": quantity,
      if (hasFields) "custom_fields": customFieldsList
    };
    log(json.encode(requestBody));
    return await _dioV2.post("catalog/stores/$storeId/carts/products", data: requestBody,
      options: Options(headers: {
        'source': 'mobile_app',
      }),
    );
  }

  Future<Response> updateCartItem(String id, String quantity) async {
    var requestBody = {
      "id": id,
      "quantity": quantity,
    };
    log(requestBody.toString());
    return await _dioV2.put("catalog/stores/$storeId/carts/products", data: requestBody);
  }

  Future<Response> deleteCartItem(int key) async {
    return await _dioV2.post("catalog/stores/$storeId/carts/products",
        data: FormData.fromMap({
          'id': key,
          '_method': 'delete',
        }));
  }

  Future<Response> uploadFileImage({required File file, required bool isFile}) async {
    return await _dioV2.post(
        "catalog/stores/$storeId/carts/products/input-fields/${isFile ? 'file' : 'image'}",
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(file.path),
        }));
  }

  ///Coupons
  Future<Response> redeemCoupon(String coupon) async {
    return await _dioV2.post("catalog/stores/$storeId/carts/coupons",
        data: FormData.fromMap({
          'coupon': coupon,
        }));
  }

  Future<Response> removeCoupon() async {
    return await _dioV2.delete("catalog/stores/$storeId/carts/coupons");
  }

  Future<Response> addCartGift({
    String? senderName,
    String? receiverName,
    String? mediaLink,
    String? giftMessage,
    String? cardDesign,
  }) async {
    return await _dioV2.post("catalog/stores/$storeId/carts/gift-card", data: {
      "sender_name": senderName,
      "receiver_name": receiverName,
      "media_link": mediaLink,
      "gift_message": giftMessage,
      "card_design": '{"file": $cardDesign}'
    });
  }

  Future<Response> removeCartGift() async {
    return await _dioV2.delete("catalog/stores/$storeId/carts/gift-card");
  }

  ///---------------------- Catalog -- Reviews ----------------------///
  Future<Response> getProductReviews(
      {String? productId, int page = 1, int pageSize = 10}) async {
    var queryParameters = {'page': page, 'page_size': pageSize};
    log(queryParameters.toString());
    return await _dioV2.get("catalog/stores/$storeId/reviews/products/$productId",
        queryParameters: queryParameters);
  }

  Future<Response> getCustomerProductReviews(String? productId) async {
    return await _dioV2
        .get("catalog/customers/stores/$storeId/reviews/products/$productId");
  }

  Future<Response> checkIfBoughtProduct(String productId) async {
    return await _dioV2
        .get("catalog/customers/store/$storeId/orders/products/$productId");
  }

  ///---------------------- Catalog -- Bank ----------------------///
  Future<Response> getStoreBanks() async {
    return await _dioV2.get("catalog/stores/$storeId/banks");
  }

  Future<Response> uploadTransfer(
      {String? orderCode, XFile? image, String? storeBankId, String? senderName}) async {
    String session = await _prefManger.getSession();
    String authorizationToken = AUTHORIZATION_TOKEN;
    String accessToken = ACCESS_TOKEN;
    String customerToken = await _prefManger.getToken();
    bool isFromRemote = await _prefManger.getIsFromRemote();

    if (isFromRemote) {
      accessToken = await _prefManger.getAccessToken();
      authorizationToken = await _prefManger.getAuthorizationToken();
      if (accessToken == '') {
        await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 1),
        ));
        await remoteConfig.ensureInitialized();
        try {
          await remoteConfig.fetchAndActivate();
        } catch (e) {}
        accessToken = remoteConfig.getString(ACCESS_TOKEN_KEY);
        await _prefManger.setAccessToken(accessToken);
      }
      if (authorizationToken == '') {
        authorizationToken = remoteConfig.getString(AUTHORIZATION_TOKEN_KEY);
        await _prefManger.setAuthorizationToken(authorizationToken);
      }

      await _prefManger.setIsFromRemote(true);
    }

    return await Dio(BaseOptions(baseUrl: baseUrl, headers: {
      'store-id': storeId,
      'ROLE': 'Manager',
      'Accept': accept,
      if (HiveController.generalBox.get('currency') != null)
        'currency': HiveController.generalBox.get('currency'),
      'Content-Type': 'multipart/form-data',
      'X-CUSTOMER-TOKEN': customerToken,
      'x-manager-token': accessToken,
      'CART-SESSION-ID': session,
      'Accept-Language': isArabicLanguage ? 'ar' : 'en',
      'Authorization': 'Bearer $authorizationToken'
    })).post("catalog/stores/$storeId/orders/$orderCode/bank-transaction/slip",
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(image?.path ?? ''),
          'store_bank_id': storeBankId,
          'sender_name': senderName
        }));
  }

  Future<Response> addProductReviews(
      {required String productId,
      String? comment,
      required double? rating,
      required int isAnonymous}) async {
    return await _dioV2.post(
        "catalog/customers/stores/$storeId/reviews/products/$productId",
        data: FormData.fromMap({
          'comment': comment,
          'rating': rating != null ? rating.toInt() : rating,
          'is_anonymous': isAnonymous,
        }));
  }

  ///-----------------
  ///----- Catalog -- Reviews ----------------------///
  Future<Response> generateCheckoutToken() async {
    String session = await _prefManger.getSession();
    String customerToken = await _prefManger.getToken();

    log(session);
    log(customerToken);
    return await _dioV2.post("catalog/checkout/$storeId/generate-token",
        data: FormData.fromMap({
          'cart_session': session,
          'x_customer_token': customerToken,
          'store_id': storeId,
        }));
  }

  ///---------------------- products ----------------------///
  Future<Response> getProductDetails(String? productId) async {
    log("PRODUCT ID ==> $productId");
    return await _dioV1.get("products/$productId");
  }

  Future<Response> getSimpleBundleOffer(List<String> productIds) async {
    int index = 0;
    Map<String, dynamic> formData = {};
    for (var element in productIds) {
      formData['product_ids[$index]'] = element;
      index++;
    }
    return await _dioV2.post("catalog/stores/$storeId/products/simple-bundle-offer",
        data: FormData.fromMap(formData));
  }

  Future<Response> getIndividualBundleOffer(String? productId) async {
    return await _dioV2.get(
        "catalog/stores/$storeId/products/$productId/bundle-offer?page=1&page_size=20");
  }

  Future<Response> getProductsList({
    List<String?>? categoryList,
    String? q,
    int? page = 1,
    int? pageSize = 14,
    String? listingPriceGte,
    String? listingPriceLte,
    String? ordering,
    String? cities,
    List<String?>? attributeValues,
    bool? sale_price__isnull,
  }) async {
    String? attributeValuesString;
    attributeValues?.forEach((element) {
      attributeValuesString = '${attributeValuesString ?? ''}$element,';
    });
    attributeValuesString =
        attributeValuesString?.substring(0, (attributeValuesString?.length ?? 0) - 1);
    log("CATEGORY ID ==> $categoryList");
    log("QUARRY ID ==> $q");
    log("ListingPriceGte VALUE ==> $listingPriceGte");
    log("ListingPriceLte VALUE ==> $listingPriceLte");
    log("Ordering VALUE ==> $ordering");
    log("cities VALUE ==> $cities");
    log("Sale_price__isnull VALUE ==> $sale_price__isnull");
    log("attribute_values VALUE ==> $attributeValuesString");

    var queryParameters = {
      if (categoryList != null && categoryList.isNotEmpty)
        'categories': categoryList.toString(),
      if (q != null) 'q': [q],
      if (listingPriceGte != null) 'listing_price__gte': listingPriceGte,
      if (listingPriceLte != null) 'listing_price__lte': listingPriceLte,
      if (ordering != null) 'ordering': ordering,
      // if (cities != null) 'cities': cities,
      if (sale_price__isnull == true) 'sale_price__isnull': false,
      'page': page,
      'page_size': pageSize,
      if (attributeValuesString != null) 'attribute_values': attributeValuesString
    };

    log(queryParameters.toString());
    var request = await _dioV1.get("products", queryParameters: queryParameters);
    log(request.realUri.toString());
    return request;
  }

  Future<Response> getProductsListByIds({
    String? ids__in,
    required int pageSize,
  }) async {
    var queryParameters = {'id__in': ids__in, 'page': 1, 'page_size': pageSize};
    // log(queryParameters.toString());

    var request = await _dioV1.get("products", queryParameters: queryParameters);
    log(request.realUri.toString());
    return request;
  }

  Future<Response> notifyMeProduct(String? productId, String? email) async {
    return await _dioV1.post("products/$productId/notifications/",
        data: FormData.fromMap({
          'email': email,
          'language': isArabicLanguage ? 'ar' : 'en',
        }));
  }

  Future<Response> notifyMeStore(String? email) async {
    return await _dioV2.post("catalog/stores/$storeId/availability/notifications",
        data: FormData.fromMap({
          'email': email,
          'language': isArabicLanguage ? 'ar' : 'en',
        }));
  }
}
