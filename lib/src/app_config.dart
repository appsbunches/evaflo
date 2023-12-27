import 'package:entaj/src/.env.dart';
import 'package:flutter/material.dart';

class AppConfig {
  /// App Options
  static const bool liteVersion = true;
  static bool multiInventoryVersion = (storeId == '224947');
  static bool isEnglishLanguageEnable = true;
  static const bool useAppBuilder = false;
  static const countriesCodes = [
    '+966',
    '+971',
    '+965',
    '+968',
    '+973',
    '+974',
    '+962',
    '+20'
  ];
  static const String fontName = 'AvenirArabic';
  static const double fontDecIncValue = 2;
  static const bool isEnableWishlist = true;
  static const bool showOnBoarding = false;
  static const bool showStoreRating = false;
  static const bool showDiscountPercentage = true;
  static const bool showLoadingInImage = false;
  static bool showBonatFromRemoteConfig = false;
  static bool showBonat = false;
  static bool showTidioFromRemoteConfig = false;
  static bool showTidio = false;
  static bool showLiveChatFromRemoteConfig = false;
  static bool showLiveChat = false;
  static int? abandonedCartHoursCount = 24;
  static String? abandonedCartNotificationTextAr;
  static String? abandonedCartNotificationTextEn;
  static const bool showBonatInAppBar = true;
  static bool showWhatsAppRemoteConfig = false;
  static bool showWhatsAppHome = false;
  static bool showChatBotRemoteConfig = false;
  static bool showChatBot = false;
  static String? defaultCurrencyCode;
  static bool newFiltrationMode = (storeId == '224947');
  static bool giftCartEnable = true;

  /// General Option
  static bool isSoreUseNewTheme = true;
  static String? currentThemeId;
  static const bool showButtonWithBorder = false;
  static const bool showTextAsNormal = false;
  static const double? logoSizeInApBarHeight = 120;
  static const double? logoSizeInApBarWidth = 120;
  static const double logoSizeInAccount = 70;
  static const bool showProductOffer = true;
  static bool disableApplePay = false;

  /// Home Options
  static const bool showOneSlider = false;
  static const bool showCategoriesInHome = true;
  static const bool showScrollDownIconInHomeCategories = false;
  static const double paddingBetweenWidget = 5;
  static const double sliderAspectRatio = 2.33;
  static const BoxFit sliderFit = BoxFit.contain;
  static const double? featureSize = null;
  static bool showMoreTextInButton = false;
  static bool showFeatureAsColumn = false;

  /// Category Options
  static const bool showCategoryName = true;
  static const bool showCategoryDescription = true;
  static const String categoriesName = 'التصنيفات'; //Don't add (tr) after text
  static const BoxFit categoryImageFit = BoxFit.contain;
  static const bool showSubCategoriesAsGrid = false;

  /// Account Options
  static const bool showAppsBunchesLogo = true;
  static const bool showShippingTo = true;
  static const bool showCall = true;
  static bool showWhatsApp = true;
  static const bool showEmail = true;
  static bool showOurNetwork = true;
  static bool showStoreAddress = false;

  /// Page Details Options
  static bool useHtmlPackage = false;

  /// Drawer Options
  static bool showScrollDownIcon = false;
  static bool showDeliveryOptions = true;
  static bool showPaymentMethod = true;

  /// Product Details Options
  static bool showWhatsAppIconInProductPage = true;
  static bool showSku = true;
  static bool showChooseInOptions = true;
  static bool showWeightInProductPage = true;
  static bool showRatingsButton = true;
  static bool showLogoInProductDetailsPage = false;
  static bool enableHintInFileCustomField = false;
  static bool showShortDescription = true;
  static bool isTaxableLabelEnabled = true;
  static bool isLowStockLabelEnabled = true;
  static bool showTrustPayment = false;
  static bool showTrustPaymentFromRemoteConfig = false;

  /// Cart Options
  static bool showDeliveryCostNote = false;

  /// GetButtonFeature in app
  static bool showGBAllApp = false;

  /// Product Item Options
  static double productItemAspectRatio = currentThemeId == asayelThemeId ? 1.18 : 1;
  static const BoxFit productItemImageFit = BoxFit.contain;
  //home aspect ratio
  static const double productsHomeAspectRatio = 1.32;
  static const double productsHomeAsayelAspectRatio = 1.32;
  static const double productsLessThenThreeWidthAspectRatio = 1.18;
  //home item width
  static const double productItemHomeAspectRatio = 0.55;
  static double productItemHomeWidth = currentThemeId == duvetThemeId ? 166 : 140;
  static const double productItemHomeLessThenThreeWidth = 166;
  static const double productsHomeAsayelWidth = 160;
  //category details item aspect ratio
  static const double productCategoryDetailsItemAspectRatio = 0.55;
  //search item aspect ratio
  static const double productSearchItemAspectRatio = 0.55;
  //wishlist item aspect ratio
  static const double productWishlistItemAspectRatio = 0.55;
  //product details item aspect ratio
  static const double productsOffersAspectRatio = 1.32;
  static const double productsRelatedAspectRatio = 1.2;
  static const double productsRelatedLessThenThreeAspectRatio = 1.32;
  //product details item width
  static const double productsRelatedWidth = 140;
  static const double productsRelatedLessThenThreeWidth = 172.5;
}
