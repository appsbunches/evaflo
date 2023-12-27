import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../.env.dart';
import '../../app_config.dart';
import '../../data/remote/api_requests.dart';
import '../../entities/custom_option_field_request.dart';
import '../../entities/custom_user_input_field_request.dart';
import '../../entities/discount_response_model.dart';
import '../../entities/offer_response_model.dart';
import '../../entities/product_details_model.dart';
import '../../services/app_events.dart';
import '../../utils/error_handler/error_handler.dart';
import '../../utils/functions.dart';
import '../_main/logic.dart';
import '../cart/logic.dart';
import '../images/view.dart';
import '../reviews/view.dart';

class ProductDetailsLogic extends GetxController with WidgetsBindingObserver {
  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      isEmpty = emailController.text.isEmpty;
      update(['isEmpty']);
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
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
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

  final ApiRequests _apiRequests = Get.find();
  final CartLogic _cartLogic = Get.find();
  final MainLogic _mainLogic = Get.find();
  final AppEvents _appEvents = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController quantityController =
      TextEditingController(text: '1');

  Map<String, TextEditingController> mapTextEditController = {};
  Map<String, String> mapDropDownChoices = {};
  Map<String?, String?> mapOptions = {};
  Map<String, bool> mapCheckboxChoicesItem = {};
  Map<String, Map<String, bool>> mapCheckboxChoices = {};
  ProductDetailsModel? productModel;
  DiscountResponseModel? discountResponseModel;
  List<ProductDetailsModel> offerProductsList = [];
  String? description;
  int selectedImageIndex = 0;
  List<String?> selectedIds = [];

  //int quantity = 1;
  bool isEmpty = true;
  bool clickOnMore = false;
  bool inStock = true;
  bool hasInternet = true;
  bool isLoading = false;
  bool isReviewsLoading = false;
  bool isUploadLoading = false;
  bool isNotifyMeLoading = false;
  bool isProductDeleted = false;
  double priceCustom = 0;
  double salePriceCustom = 0;
  double priceTotal = 0;
  double salePriceTotal = 0;
  String formattedPrice = '';
  String formattedSalePrice = '';

  Future<bool> checkInternetConnection(String productId) async {
    var connection =
        (await Connectivity().checkConnectivity() != ConnectivityResult.none);
    hasInternet = connection;
    update([productId]);
    return connection;
  }

  increaseQuantity() {
    if (quantityController.text.isEmpty) {
      quantityController.text = '0';
    }
    int quantity = int.parse(quantityController.text);

    var maxQuantityPerCart =
        productModel?.purchaseRestrictions?.maxQuantityPerCart;
    var productQuantity = productModel?.quantity;
    if (maxQuantityPerCart != null && productQuantity != null) {
      if (productQuantity < maxQuantityPerCart) {
        if (quantity >= productQuantity) {
          return;
        }
      } else {
        if (quantity >= maxQuantityPerCart) {
          return;
        }
      }
    }
    if (maxQuantityPerCart != null) {
      if (quantity >= maxQuantityPerCart) {
        return;
      }
    } else if (productQuantity != null) {
      if (quantity >= productQuantity) return;
    } else if (quantity > 9999) {
      quantityController.text = '9999';
    }

    quantity++;
    quantityController.text = quantity.toString();
    quantityController.selection = TextSelection.fromPosition(
        TextPosition(offset: quantityController.text.length));

    update(['quantity']);

    _cartLogic.increaseQuantity(_cartLogic.getCartItem(getProductId()),
        newQty1: int.parse(quantityController.text));
  }

  decreaseQuantity() {
    if (quantityController.text.isEmpty) {
      quantityController.text = '2';
    }
    int quantity = int.parse(quantityController.text);
    if (quantity < 2) return;
    var minQty = productModel?.purchaseRestrictions?.minQuantityPerCart;
    var maxQty = productModel?.purchaseRestrictions?.maxQuantityPerCart;

    if (minQty != null) {
      if (quantity == minQty) {
        final CartLogic cartLogic = Get.find();
        /*Fluttertoast.showToast(
            msg: isArabicLanguage
                ? "أقل كمية مسموح بها $minQty وأقصى كمية $maxQty"
                : 'The minimum allowed quantity is $minQty and the maximum quantity is $maxQty');*/
        cartLogic.deleteItemFromProductDetailsPage(
            cartLogic.getCartItem(getProductId())?.id, productModel?.id);
        return;
      }
    }
    quantity--;
    quantityController.text = quantity.toString();

    quantityController.selection = TextSelection.fromPosition(
        TextPosition(offset: quantityController.text.length));
    update(['quantity']);
    _cartLogic.decreaseQuantity(_cartLogic.getCartItem(getProductId()),
        newQty1: int.parse(quantityController.text));
  }

  void goToReviews() {
    if (productModel == null) {
      return;
    }
    Get.to(ReviewsPage(
      productId: productModel!.id!,
      isFromOrderDetails: false,
    ));
  }

  void changeSelectedImage(int index) {
    selectedImageIndex = index;
    update(['images']);
  }

  goToImages(List<Images>? images, int index) {
    if (images == null || images.isEmpty) {
      return;
    }

    Get.to(ImagesPage(images, index));
  }

  double lastDif = 0;
  double lastSaleDif = 0;

  void onChangeOption(String? newValue, Options? option,
      {bool withUpdate = false}) {
    mapOptions[option?.name] = newValue;
    if (withUpdate) update([option?.name ?? '']);
    if (productModel?.options == null) return;
    if (mapOptions.length != productModel?.options?.length) return;
    String? productId = getProductId();
    productModel?.variants?.forEach((element) {
      if (element.id == productId) {
        //productModel?.name = element.name;

        priceTotal = element.price;
        salePriceTotal = element.salePrice;
        selectedIds = [];
        updatePrices(caseName: 'ALL');
        productModel?.sku = element.sku;
        productModel?.quantity = element.quantity;
        productModel?.purchaseRestrictions?.maxQuantityPerCart =
            element.purchaseRestrictions?.maxQuantityPerCart;
        productModel?.purchaseRestrictions?.minQuantityPerCart =
            element.purchaseRestrictions?.minQuantityPerCart;
        //  productModel?.quantity = element.quantity;
        productModel?.images = [];
        productModel?.images?.addAll(element.images ?? []);
        if (AppConfig.isSoreUseNewTheme || element.images?.isEmpty == true) {
          productModel?.images?.addAll(productModel?.originalImages ?? []);
        }
        quantityController.text = '1';

        _cartLogic.cartModel?.products?.forEach((cartElement) {
          if (cartElement.productId == element.id?.replaceAll('-', '')) {
            quantityController.text = cartElement.quantity.toString();
            update(['quantity']);
          }
        });
        if (withUpdate) {
          update([
            'price',
            'notify',
            'addToCart${productModel?.id}',
            productModel?.id ?? ''
          ]);
        }
        if (withUpdate) update();
      }
    });
  }

  String? getProductId() {
    if (productModel == null) return null;
    if (productModel?.hasOptions == false) return productModel?.id;
    String? productId;
    if (productModel?.hasOptions == true && mapOptions.isNotEmpty) {
      productModel?.variants?.forEach((variant) {
        var product = [];
        mapOptions.forEach((key, value) {
          variant.attributes?.forEach((attributes) {
            if (attributes.name == key && attributes.value == value) {
              product.add(true);
            } else {
              product.add(false);
            }
          });
        });
        var trueCount = 0;
        var falseCount = 0;
        for (var element in product) {
          element ? trueCount++ : falseCount++;
        }
        if (trueCount >= mapOptions.length) {
          productId = variant.id;
        }
        //log(trueCount.toString() + " T -- " + variant.id.toString());
        //log(falseCount.toString() + " F -- " + variant.id.toString());
      });
    }
    return productId;
  }

  List getCustomList() {
    List list = [];

    productModel?.customFields?.forEach((element) {
      mapTextEditController.forEach((key, value) {
        if (key == element.id) {
          if ((mapTextEditController[element.id]?.text.length ?? 0) > 0) {
            list.add(CustomUserInputFieldRequest(
                    priceSettings: element.id,
                    groupId: element.id,
                    name: element.label,
                    value: mapTextEditController[element.id]?.text,
                    type: element.type)
                .toJson());
          }
        }
      });
    });

    productModel?.customOptionFields?.forEach((customOption) {
      mapDropDownChoices.forEach((key, value) {
        if (key == customOption.id) {
          if ((mapDropDownChoices[customOption.id]?.length ?? 0) > 0) {
            list.add(CustomOptionFieldRequest(
                    priceSettings: {customOption.id: value},
                    groupId: customOption.id,
                    groupName: customOption.name,
                    value: "✔",
                    name: customOption.choices
                            ?.firstWhere((element) => element.id == value)
                            .ar ??
                        '',
                    type: customOption.type)
                .toJson());
          }
        }
      });
    });

    productModel?.customOptionFields?.forEach((customOption) {
      mapCheckboxChoices.forEach((key, value) {
        if (key == customOption.id) {
          if ((mapCheckboxChoices[customOption.id]?.length ?? 0) > 0) {
            List checkedList = [];
            mapCheckboxChoices[key]?.forEach((key2, value2) {
              if (value2) {
                checkedList.add(key2);
              }
            });
            for (var elementCheck in checkedList) {
              list.add(CustomOptionFieldRequest(
                      priceSettings: {key: elementCheck},
                      groupId: customOption.id,
                      groupName: customOption.name,
                      value: "✔",
                      name: productModel?.customOptionFields
                              ?.firstWhere((element) => element.id == key)
                              .name ??
                          '',
                      type: customOption.type)
                  .toJson());
            }
          }
        }
      });
    });

    return list;
  }

  changeDropDownSelected(String id, double customPrice, value) {
    int index1 = 0;
    productModel?.customFields?.forEach((elementCustomField) {
      int index = 0;
      elementCustomField.choices?.forEach((element) {
        productModel?.customFields?[index1].choices?[index].isSelected = false;
        if (element.id == value) {
          productModel?.customFields?[index1].choices?[index].isSelected = true;
        }
        index++;
      });
      index1++;
    });

    updatePrices(caseName: 'DROPDOWN');
    mapDropDownChoices[id] = value.toString();
    updateQty();
    update(['price', id, 'quantity']);
    _cartLogic.update(['addToCart${productModel?.id}']);
  }

  changeCheckboxSelected(
      String id, String choicesId, double customPrice, bool? value) {
    int index1 = 0;
    productModel?.customFields?.forEach((elementCustomField) {
      int index = 0;
      elementCustomField.choices?.forEach((element) {
        if (element.id == choicesId) {
          productModel?.customFields?[index1].choices?[index].isSelected =
              value ?? false;
        }
        index++;
      });
      index1++;
    });

    updatePrices(caseName: 'CHECKBOX');
    mapCheckboxChoicesItem = {};
    mapCheckboxChoices[id]?.forEach((key, value) {
      mapCheckboxChoicesItem[key] = value;
    });
    mapCheckboxChoicesItem[choicesId] = value ?? false;
    mapCheckboxChoices[id] = mapCheckboxChoicesItem;
    update([id]);
  }

  getDescription({required bool all}) {
    if (!all) {
      if ((productModel?.description?.length ?? 0) > 300) {
        if ((productModel?.description?.length ?? 0) < 350) {
          getDescription(all: true);
        }
        description = productModel?.description?.substring(0, 300) ?? '';
      } else {
        description = productModel?.description ?? ' ';
      }
    } else {
      description = productModel?.description ?? ' ';
    }

    if (description!.lastChars(1) == '<' || description!.lastChars(1) == '>') {
      description = description?.substring(0, description!.length - 1);
    }
    clickOnMore = !clickOnMore;
    update(['description']);
  }

  Future<void> getProductDetails(String productId) async {
    isProductDeleted = false;
    if (!await checkInternetConnection(productId)) return;
    productModel = null;
    isLoading = true;
    update([productId]);

    try {
      var response = await _apiRequests.getProductDetails(productId);
      // log(json.encode(response.data));
      productModel = ProductDetailsModel.fromJson(response.data);
      if (productModel?.parentId != null) {
        var response =
            await _apiRequests.getProductDetails(productModel?.parentId);
        productModel = ProductDetailsModel.fromJson(response.data);
      }
      priceCustom = 0;
      salePriceCustom = 0;
      priceTotal = productModel!.price;
      salePriceTotal = productModel!.salePrice;
      formattedPrice =
          '${priceTotal.toStringAsFixed(2)} ${productModel?.currency}';
      formattedSalePrice =
          '${salePriceTotal.toStringAsFixed(2)} ${productModel?.currency}';
      update(['price']);

      updateQty();
      //  if (AppConfig.showProductOffer) {
      getIndividualBundleOffer(productModel?.id, productId);
      List<String> productRelatedIds = [];
      productModel?.relatedProducts?.forEach((element) {
        productRelatedIds.add(element.id ?? '');
      });
      await getSimpleBundleOffer(productRelatedIds);
      //  }

      if (AppConfig.showChooseInOptions) {
        productModel?.options?.forEach((element) {
          productModel?.options?.forEach((elementOption) {
            if (elementOption.choices?.isNotEmpty == true) {
              onChangeOption(elementOption.choices?[0], elementOption,
                  withUpdate: false);
              if (productModel?.quantity == 0) {
                var exist = false;
                elementOption.choices?.forEach((elementChoice) {
                  if (!exist) {
                    onChangeOption(elementChoice, elementOption,
                        withUpdate: false);
                  }
                  if (productModel?.quantity != 0) exist = true;
                });
              }
            }
          });
        });
      }
      getDescription(all: false);

      _appEvents.logOpenProduct(
          name: productModel?.name,
          price: productModel?.formattedPrice,
          productId: productId);
    } catch (e) {
      try {
        if (e is dio.DioError) {
          if (e.response != null) {
            if ((e.response!.data['detail']?.toString().contains('Not found') ==
                    true) ||
                (e.response!.data['detail']?.toString().contains('غير موجود') ==
                    true)) {
              isProductDeleted = true;
            }
          }
        }
      } catch (e) {}

      ErrorHandler.handleError(e);
    }

    isLoading = false;
    update([productId]);
  }

  Future<void> getIndividualBundleOffer(String? id, String productId) async {
    try {
      var response = await _apiRequests.getIndividualBundleOffer(id);
      //log(json.encode(response.data));
      discountResponseModel =
          DiscountResponseModel.fromJson(response.data['payload']);
      productModel?.offerLabel = discountResponseModel?.name;

      offerProductsList = (response.data['products']['results'] as List)
          .map((e) => ProductDetailsModel.fromJson(e))
          .toList();
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
    update([productId]);
  }

  void observeTextEdit(
      TextEditingController? mapTextEditController, double customPrice,
      {required String? key}) {
    mapTextEditController?.addListener(() {
      if (mapTextEditController.text != '') {
        productModel?.customFields
            ?.firstWhere((element) => element.id == key)
            .isSelected = true;
        updatePrices(caseName: 'TEXT');
      } else if (mapTextEditController.text == '') {
        productModel?.customFields
            ?.firstWhere((element) => element.id == key)
            .isSelected = false;
        updatePrices(caseName: 'TEXT');
      }
    });
  }

  updatePrices({required String caseName}) {
    double addonPrices = 0;
    productModel?.customFields?.forEach((element) {
      if (element.type == 'CHECKBOX' &&
          (caseName == 'CHECKBOX' || caseName == 'ALL')) {
        element.choices?.forEach((elementChoices) {
          if (elementChoices.isSelected &&
              !selectedIds.contains(elementChoices.id)) {
            addonPrices += elementChoices.price ?? 0;
            selectedIds.add(elementChoices.id);
          } else if (!elementChoices.isSelected &&
              selectedIds.contains(elementChoices.id)) {
            addonPrices -= elementChoices.price ?? 0;
            selectedIds.remove(elementChoices.id);
          }
        });
      }
      if (element.type == 'DROPDOWN' &&
          (caseName == 'DROPDOWN' || caseName == 'ALL')) {
        element.choices?.forEach((elementChoices) {
          // log(elementChoices.isSelected.toString());
          if (elementChoices.isSelected &&
              !selectedIds.contains(elementChoices.id)) {
            addonPrices += elementChoices.price ?? 0;
            selectedIds.add(elementChoices.id);
          } else if (selectedIds.contains(elementChoices.id)) {
            addonPrices -= elementChoices.price ?? 0;
            selectedIds.remove(elementChoices.id);
          }
        });
      } else if ((element.type == 'TEXT' || element.type == 'NUMBER') &&
          (caseName == 'TEXT' || caseName == 'ALL')) {
        if (element.isSelected && !selectedIds.contains(element.id)) {
          addonPrices += (element.price ?? 0);
          selectedIds.add(element.id);
        } else if (!element.isSelected && selectedIds.contains(element.id)) {
          addonPrices -= (element.price ?? 0);
          selectedIds.remove(element.id);
        }
      }
    });

    priceTotal = priceTotal + addonPrices;
    if (salePriceTotal != 0) {
      salePriceTotal = salePriceTotal + addonPrices;
    }

    formattedPrice =
        '${priceTotal.toStringAsFixed(2)} ${productModel?.currency}';
    formattedSalePrice =
        '${salePriceTotal.toStringAsFixed(2)} ${productModel?.currency}';
    update(['price']);
  }

  Future<void> sentNotification() async {
    if (emailController.text.isEmpty) {
      showMessage("يرجى ادخال البريد الإلكتروني".tr, 2);
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      showMessage("البريد الالكتروني غير صالح".tr, 2);
      return;
    }

    isNotifyMeLoading = true;
    update();

    try {
      var response = await _apiRequests.notifyMeProduct(
          productModel?.id, emailController.text);
      emailController.text = '';
      showMessage("تم تفعيل التنبيه بنجاح".tr, 1);
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }

    isNotifyMeLoading = false;
    update();
  }

  Future<List<String?>> uploadFileImage(bool isFile, String id) async {
    List<String?> path = [];
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: isFile ? FileType.any : FileType.image);

    final file = File(result?.files.single.path ?? '');
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    if (sizeInMb > 8) {
      showMessage('حجم الملف غير صالح\nحجم الملف الأقصى : 8M'.tr, 2);
      return path;
    }
    if (result != null) {
      File file = File(result.files.single.path ?? '');

      isUploadLoading = true;
      update([id]);
      try {
        var res =
            await _apiRequests.uploadFileImage(file: file, isFile: isFile);
        path = [];
        path.add(res.data['payload']['path']);
        path.add(res.data['payload']['temporary_url']);
      } catch (e) {
        ErrorHandler.handleError(e);
      }
      isUploadLoading = false;
      update([id]);
    } else {}
    return path;
  }

  Future<void> getSimpleBundleOffer(List<String> productRelatedIds) async {
    try {
      var res = await _apiRequests.getSimpleBundleOffer(productRelatedIds);
      List<OfferResponseModel> offerList = (res.data['payload'] as List)
          .map((e) => OfferResponseModel.fromJson(e))
          .toList();

      for (var elementOffer in offerList) {
        productModel?.relatedProducts?.forEach((element) {
          if (elementOffer.productIds?.contains(element.id) == true) {
            element.offerLabel = elementOffer.name;
          }
        });
      }
    } catch (e) {}
  }

  goToWhatsApp({String? message}) async {
    String whatsAppUrlFromRemote = remoteConfig.getString(WA_PRODUCT_KEY);
    String whatsAppUrl = "";
    String whatsAppUrlFromRemoteWithDes = '$whatsAppUrlFromRemote$message';
    String phoneNumber = _mainLogic.settingModel?.settings?.headScriptsApps
            ?.z5dmo?.params?.z5dmo_params ??
        _mainLogic.settingModel?.footer?.socialMedia?.items?.phone ??
        '';
    whatsAppUrl =
        'https://wa.me/+$phoneNumber?text=${Uri.encodeComponent(message ?? '')}';
    whatsAppUrl = whatsAppUrl.replaceAll('++', '+');

    var whatsAppUrlFinal = whatsAppUrlFromRemote.isEmpty
        ? whatsAppUrl
        : whatsAppUrlFromRemoteWithDes;
    launchWhatsapp(whatsAppUrlFinal);
  }

  onChangeAddToCart(s) {
    if (s.isEmpty) return;
    if (onChange(s, _cartLogic)) {}
    _cartLogic.increaseQuantity(_cartLogic.getCartItem(getProductId()),
        newQty1: int.parse(quantityController.text));
    update(['quantity']);
  }

  bool onChange(s, CartLogic cartLogic) {
    if (s.isEmpty) {
      return false;
    }
    quantityController.text = replaceArabicNumber(s);
    quantityController.selection = TextSelection.fromPosition(
        TextPosition(offset: quantityController.text.length));

    var inputQty = int.parse(quantityController.text.toString());
    var maxQuantityPerCart =
        productModel?.purchaseRestrictions?.maxQuantityPerCart;
    var productQuantity = productModel?.quantity;
    log('productQty $productQuantity --- inputQty $inputQty');

    if (maxQuantityPerCart != null && productQuantity != null) {
      if (productQuantity < maxQuantityPerCart) {
        if (inputQty >= productQuantity) {
          quantityController.text = productQuantity.toString();
          return false;
        }
      } else {
        if (inputQty >= maxQuantityPerCart) {
          quantityController.text = maxQuantityPerCart.toString();
          return false;
        }
      }
    }
    if (maxQuantityPerCart != null) {
      if (inputQty >= maxQuantityPerCart) {
        quantityController.text = maxQuantityPerCart.toString();
        return false;
      }
    }
    if (productModel!.quantity == null) return false;

    if (productModel?.purchaseRestrictions?.maxQuantityPerCart != null) {
      if (inputQty >= productModel!.purchaseRestrictions!.maxQuantityPerCart!) {
        quantityController.text =
            productModel!.purchaseRestrictions!.maxQuantityPerCart!.toString();
        return false;
      }
    } else if (productQuantity < inputQty) {
      quantityController.text = (productModel!.quantity).toString();
      return false;
    }
    return true;
  }

  void updateQty() {
    _cartLogic.cartModel?.products?.forEach((elementCart) {
      if (elementCart.productId == getProductId()?.replaceAll('-', '')) {
        bool hasDropdown = false;
        productModel?.customOptionFields?.forEach((element) {
          if (element.type == 'DROPDOWN') hasDropdown = true;
        });
        if (hasDropdown) {
          quantityController.text = '1';
          update(['quantity']);
          elementCart.customFields?.forEach((elementCartItem) {
            for (var elementCustom in getCustomList()) {
              if (elementCustom['group_name'] == elementCartItem.groupName) {
                if (elementCustom['name'] == elementCartItem.realName) {
                  quantityController.text = elementCart.quantity.toString();
                  update(['quantity']);
                }
              }
            }
          });
        } else {
          quantityController.text = elementCart.quantity.toString();
          update(['quantity']);
        }
      }
    });
  }
}
