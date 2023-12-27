import 'package:entaj/src/.env.dart';
import 'package:entaj/src/entities/GiftOrderSettingsModel.dart';

import '../../main.dart';
import '../app_config.dart';
import 'AppScriptModel.dart';
import 'category_model.dart';
import 'country_model.dart';
import 'page_model.dart';
import 'storefront_theme_model.dart';

class SettingModel {
  Header? header;
  Footer? footer;
  Settings? settings;

  SettingModel.fromJson(dynamic json) {
    settings = json['settings'] != null ? Settings.fromJson(json['settings']) : null;
    footer = json['footer'] != null ? Footer.fromJson(json['footer']) : null;
    header = json['header'] != null ? Header.fromJson(json['header']) : null;
  }
}

class Settings {
  int? id;
  String? uuid;
  String? name;
  String? permalink;
  CountryModel? currency;
  List<CountryModel>? currencies;
  Language? language;
  List<Languages>? languages;
  String? phone;
  String? email;
  String? logo;
  String? cover;
  String? icon;
  String? metaTitle;
  String? description;
  Head_scripts? headScripts;
  Head_scripts_apps? headScriptsApps;
  List<dynamic>? googleMaps;
  num? maintenanceMode;
  num? hasNewProductsService;
  bool? isLowStockLabelEnabled;
  bool? isProductReviewsEnabled;
  bool? isDifferentConsigneeAllowed;
  num? lowStockQuantityLimit;
  bool? customersLoginByEmailStatus;
  One_signal_keys? oneSignalKeys;
  Vat_settings? vatSettings;
  String? commercialRegistrationNumber;
  String? commercialRegistrationNumberActivation;
  dynamic? isTamaraProductWidgetEnabled;
  List<dynamic>? tamaraSupportedCurrencies;
  List<AppScriptModel>? appScripts;
  bool? isFilterProductsBasedOnCity;
  bool? isApplePayEnabled;
  bool? isApplePayEnabledInAllBrowsers;
  bool? isBuyAsAGuestEnabled;
  bool? isCustomersEmailMandatory;
  bool? isGmapsInAddressEnabled;
  bool? isGmapsInAddressMandatory;
  bool? isSplInAddressEnabled;
  bool? isGiftOrderEnabled;
  GiftOrderSettingsModel? giftOrderSettingsModel;
  Availability? availability;
  StorefrontThemeModel? storefrontTheme;
  Theme? theme;

  Settings.fromJson(dynamic json) {
    if (json['currencies'] != null) {
      currencies = [];
      json['currencies'].forEach((v) {
        currencies?.add(CountryModel.fromJson(v));
      });
    }
    if (json['languages'] != null) {
      languages = [];
      AppConfig.isEnglishLanguageEnable = false;
      json['languages'].forEach((v) {
        var lang = Languages.fromJson(v);
        languages?.add(lang);
        if (lang.code == 'en') AppConfig.isEnglishLanguageEnable = true;
      });
    }

    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    permalink = json['permalink'];
    currency = json['currency'] != null ? CountryModel.fromJson(json['currency']) : null;
/*
    language = json['language'] != null ? Language.fromJson(json['language']) : null;

    phone = json['phone'];
    email = json['email'];
    logo = json['logo'];
    cover = json['cover'];
    icon = json['icon'];
    metaTitle = json['meta_title'];
    description = json['description'];
    if (json['google_maps'] != null) {
      googleMaps = [];
      json['google_maps'].forEach((v) {
        googleMaps?.add((v));
      });
    }
    oneSignalKeys = json['one_signal_keys'] != null ? One_signal_keys.fromJson(json['one_signal_keys']) : null;
*/
    customersLoginByEmailStatus = json['customers_login_by_email_status'];
    vatSettings =
        json['vat_settings'] != null ? Vat_settings.fromJson(json['vat_settings']) : null;
    commercialRegistrationNumber = json['commercial_registration_number'];
    commercialRegistrationNumberActivation =
        json['commercial_registration_number_activation'];
    storefrontTheme = StorefrontThemeModel.fromJson(json['storefront_theme']);
    //  theme = json['theme'] != null ? Theme.fromJson(json['theme']) : null;
/*
    isTamaraProductWidgetEnabled = json['is_tamara_product_widget_enabled'];
    if (json['tamara_supported_currencies'] != null) {
      tamaraSupportedCurrencies = [];
      json['tamara_supported_currencies'].forEach((v) {
        tamaraSupportedCurrencies?.add((v));
      });
    }
    isApplePayEnabled = json['is_apple_pay_enabled'];
*/
    isFilterProductsBasedOnCity = json['is_filter_products_based_on_city'];
    isApplePayEnabled = json['is_apple_pay_enabled'];
    isApplePayEnabledInAllBrowsers = json['is_apple_pay_enabled_in_all_browsers'];
    isBuyAsAGuestEnabled = json['is_buy_as_a_guest_enabled'];
    isCustomersEmailMandatory = json['is_customers_email_mandatory'];
    isGmapsInAddressEnabled = json['is_gmaps_in_address_enabled'];
    isGmapsInAddressMandatory = json['is_gmaps_in_address_mandatory'];
    isSplInAddressEnabled = json['is_spl_in_address_enabled'];
    isGiftOrderEnabled = json['is_gift_order_enabled'];
    giftOrderSettingsModel =
        json['gift_order_settings'] != null ? GiftOrderSettingsModel.fromJson(json['gift_order_settings']) : null;
    availability =
        json['availability'] != null ? Availability.fromJson(json['availability']) : null;

    if (json['app_scripts'] != null) {
      appScripts = [];
      json['app_scripts'].forEach((v) {
        var item = AppScriptModel.fromJson(v);
        appScripts?.add(item);
        if (AppConfig.showBonatFromRemoteConfig) {
          if (item.appName == 'Bonat') AppConfig.showBonat = true;
          if (item.appName == 'Bonat Private') AppConfig.showBonat = true;
        }
      });
    }

    headScripts = json['head_scripts'] != null
        ? json['head_scripts'] is List
            ? null
            : Head_scripts.fromJson(json['head_scripts'])
        : null;
/*
    headScriptsApps = json['head_scripts_apps'] != null
        ? Head_scripts_apps.fromJson(json['head_scripts_apps'])
        : null;
*/

    if (AppConfig.showTidioFromRemoteConfig) {
      if (headScripts?.tidio != null) AppConfig.showTidio = true;
    }
    if (AppConfig.showLiveChatFromRemoteConfig) {
      if (headScripts?.livechat != null) AppConfig.showLiveChat = true;
    }
    if (AppConfig.showWhatsAppRemoteConfig) {
      if (headScripts?.getbutton != null) AppConfig.showWhatsAppHome = true;
    }
    if (AppConfig.showChatBotRemoteConfig) {
      if (headScripts?.chatbot != null) AppConfig.showChatBot = true;
    }

    if (AppConfig.showTrustPaymentFromRemoteConfig) {
      AppConfig.showTrustPayment = true;
    }
    maintenanceMode = json['maintenance_mode'];
    hasNewProductsService = json['has_new_products_service'];
    isLowStockLabelEnabled = json['is_low_stock_label_enabled'];
    isProductReviewsEnabled = json['is_product_reviews_enabled'];
    isDifferentConsigneeAllowed = json['is_different_consignee_allowed'];
    lowStockQuantityLimit = json['low_stock_quantity_limit'];

    AppConfig.showRatingsButton = isProductReviewsEnabled == true;
    AppConfig.isLowStockLabelEnabled = isLowStockLabelEnabled == true;
  }
}

class Theme {
  String? code;
  Colors? colors;
  Custom? custom;

  Theme.fromJson(dynamic json) {
    code = json['code'];
    colors = json['colors'] != null ? Colors.fromJson(json['colors']) : null;
    custom = json['custom'] != null ? Custom.fromJson(json['custom']) : null;
  }
}

class Custom {
  Css? css;

  Custom.fromJson(dynamic json) {
    css = json['css'] != null ? Css.fromJson(json['css']) : null;
  }
}

class Css {
  dynamic? embedded;
  dynamic? url;

  Css.fromJson(dynamic json) {
    embedded = json['embedded'];
    url = json['url'];
  }
}

class Colors {
  Buttons? buttons;

  Colors.fromJson(dynamic json) {
    buttons = json['buttons'] != null ? Buttons.fromJson(json['buttons']) : null;
  }
}

class Buttons {
  String? btnDefaultBackgroundColor;
  String? btnDefaultTextColor;
  String? btnDefaultBorderColor;
  String? btnHoverBackgroundColor;
  String? btnPressedBackgroundColor;
  String? btnPressedTextColor;
  String? btnPressedBorderColor;

  Buttons.fromJson(dynamic json) {
    btnDefaultBackgroundColor = json['btn_default_background_color'];
    btnDefaultTextColor = json['btn_default_text_color'];
    btnDefaultBorderColor = json['btn_default_border_color'];
    btnHoverBackgroundColor = json['btn_hover_background_color'];
    btnPressedBackgroundColor = json['btn_pressed_background_color'];
    btnPressedTextColor = json['btn_pressed_text_color'];
    btnPressedBorderColor = json['btn_pressed_border_color'];
  }
}

class Availability {
  bool? isStoreClosed;
  String? closingType;
  String? closingTimeType;
  bool? closedNow;
  Activating_data? activatingData;
  Closing_data? closingData;
  bool? notifyCustomer;
  bool? isTimeCounterDisplayed;
  bool? isAvailableHoursVisible;
  Message? title;
  Message? message;
  Times? times;

  Availability.fromJson(dynamic json) {
    isStoreClosed = json['is_store_closed'];
    closedNow = json['closed_now'];
    closingType = json['closing_type'];
    closingTimeType = json['closing_time_type'];
    message = json['message'] is List
        ? null
        : json['message'] != null
            ? Message.fromJson(json['message'])
            : null;
    title = json['title'] is List
        ? null
        : json['title'] != null
            ? Message.fromJson(json['title'])
            : null;
    activatingData = json['activating_data'] != null
        ? Activating_data.fromJson(json['activating_data'])
        : null;
    isTimeCounterDisplayed = json['is_time_counter_displayed'];

/*
    closingData = json['closing_data'] != null ? Closing_data.fromJson(json['closingData']) : null;
    notifyCustomer = json['notify_customer'];
    isAvailableHoursVisible = json['is_available_hours_visible'];
    title = json['title'] != null ? Title.fromJson(json['title']) : null;
    times = json['times'] != null ? Times.fromJson(json['times']) : null;
*/
  }
}

class Times {
  Monday? monday;
  Tuesday? tuesday;

  Times({this.monday, this.tuesday});

  Times.fromJson(dynamic json) {
    monday = json['Monday'] != null ? Monday.fromJson(json['Monday']) : null;
    tuesday = json['Tuesday'] != null ? Tuesday.fromJson(json['Tuesday']) : null;
  }
}

class Tuesday {
  Period_1? period1;

  Tuesday({this.period1});

  Tuesday.fromJson(dynamic json) {
    period1 = json['period_1'] != null ? Period_1.fromJson(json['period1']) : null;
  }
}

class Monday {
  Period_1? period1;
  Period_2? period2;

  Monday.fromJson(dynamic json) {
    period1 = json['period_1'] != null ? Period_1.fromJson(json['period1']) : null;
    period2 = json['period_2'] != null ? Period_2.fromJson(json['period2']) : null;
  }
}

class Period_2 {
  String? from;
  String? to;

  Period_2({this.from, this.to});

  Period_2.fromJson(dynamic json) {
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['from'] = from;
    map['to'] = to;
    return map;
  }
}

class Period_1 {
  String? from;
  String? to;

  Period_1.fromJson(dynamic json) {
    from = json['from'];
    to = json['to'];
  }
}

class Message {
  String? ar;
  String? en;

  Message.fromJson(dynamic json) {
    ar = json['ar'];
    en = json['en'];
  }
}

class Closing_data {
  dynamic? date;
  dynamic? time;
  dynamic? dayName;
  dynamic? remainingMonths;
  dynamic? remainingDays;
  dynamic? remainingHours;
  dynamic? remainingMinutes;

  Closing_data.fromJson(dynamic json) {
    date = json['date'];
    time = json['time'];
    dayName = json['day_name'];
    remainingMonths = json['remaining_months'];
    remainingDays = json['remaining_days'];
    remainingHours = json['remaining_hours'];
    remainingMinutes = json['remaining_minutes'];
  }
}

class Activating_data {
  String? date;
  String? time;
  String? dayName;
  int? remainingMonths;
  int? remainingDays;
  int? remainingHours;
  int? remainingMinutes;

  Activating_data.fromJson(dynamic json) {
    date = json['date'];
    time = json['time'];
    dayName = json['day_name'];
    remainingMonths = json['remaining_months'];
    remainingDays = json['remaining_days'];
    remainingHours = json['remaining_hours'];
    remainingMinutes = json['remaining_minutes'];
  }
}

class Vat_settings {
  String? id;
  CountryModel? country;
  double? taxPercentage;
  String? vatNumber;
  String? taxRegistrationCertificate;
  List<dynamic>? settings;
  bool? isCertificateVisible;
  bool? isVatNumberVisible;
  bool? canUseVat;
  bool? vatActivate;
  bool? isVatSelfPaid;
  bool? isVatIncludedInProductPrice;
  bool? isShippingFeeIncludedInVat;
  double? otherCountriesTaxPercentage;

  Vat_settings(
      {this.id,
      this.country,
      this.taxPercentage,
      this.vatNumber,
      this.taxRegistrationCertificate,
      this.settings,
      this.isCertificateVisible,
      this.isVatNumberVisible,
      this.canUseVat,
      this.vatActivate,
      this.isVatSelfPaid,
      this.isVatIncludedInProductPrice,
      this.isShippingFeeIncludedInVat,
      this.otherCountriesTaxPercentage});

  Vat_settings.fromJson(dynamic json) {
    /* id = json['id'];
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    taxPercentage = json['tax_percentage'];
  */
    vatNumber = json['vat_number'];
    taxRegistrationCertificate = json['tax_registration_certificate'];
    isVatNumberVisible = json['is_vat_number_visible'];
    /*   if (json['settings'] != null) {
      settings = [];
      json['settings'].forEach((v) {
        settings?.add((v));
      });
    }
    isCertificateVisible = json['is_certificate_visible'];
    canUseVat = json['can_use_vat'];
    vatActivate = json['vat_activate'];
    isVatSelfPaid = json['is_vat_self_paid'];
    isVatIncludedInProductPrice = json['is_vat_included_in_product_price'];
    isShippingFeeIncludedInVat = json['is_shipping_fee_included_in_vat'];
    otherCountriesTaxPercentage = json['other_countries_tax_percentage'];
*/
  }
}

class Name {
  String? ar;
  String? en;

  Name.fromJson(dynamic json) {
    ar = isArabicLanguage ? json['ar'] : json['en'] ?? json['ar'];
    en = json['en'];
  }
}

class One_signal_keys {
  String? appId;
  String? appKey;
  dynamic? androidPackageName;
  dynamic? iosAppId;

  One_signal_keys({this.appId, this.appKey, this.androidPackageName, this.iosAppId});

  One_signal_keys.fromJson(dynamic json) {
    appId = json['app_id'];
    appKey = json['app_key'];
    androidPackageName = json['android_package_name'];
    iosAppId = json['ios_app_id'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['app_id'] = appId;
    map['app_key'] = appKey;
    map['android_package_name'] = androidPackageName;
    map['ios_app_id'] = iosAppId;
    return map;
  }
}

class Head_scripts_apps {
  Snapchat_pixel? snapchatPixel;
  bool? globalHeadScript;
  Livechat? livechat;
  Linkarabydb? linkarabydb;
  Tidio? tidio;
  Intercom? intercom;
  Crisp? crisp;
  Chatbot? chatbot;
  Crazyegg? crazyegg;
  Zendesk? zendesk;
  Tawkto? tawkto;
  Smartarget? smartarget;
  Google_analytics? googleAnalytics;
  Drdsh? drdsh;
  Landbotio? z5dmo;
  Getbutton? getbutton;
  Landbotio? landbotio;
  bool? purchaseEvent;

  Head_scripts_apps(
      {this.snapchatPixel,
      this.globalHeadScript,
      this.livechat,
      this.linkarabydb,
      this.tidio,
      this.intercom,
      this.crisp,
      this.chatbot,
      this.crazyegg,
      this.zendesk,
      this.tawkto,
      this.smartarget,
      this.googleAnalytics,
      this.drdsh,
      this.z5dmo,
      this.landbotio,
      this.purchaseEvent});

  Head_scripts_apps.fromJson(dynamic json) {
    snapchatPixel = json['snapchat_pixel'] != null
        ? Snapchat_pixel.fromJson(json['snapchatPixel'])
        : null;
    globalHeadScript = json['global_head_script'];
    livechat = json['livechat'] != null ? Livechat.fromJson(json['livechat']) : null;
    linkarabydb =
        json['linkarabydb'] != null ? Linkarabydb.fromJson(json['linkarabydb']) : null;
    tidio = json['tidio'] != null ? Tidio.fromJson(json['tidio']) : null;
    intercom = json['intercom'] != null ? Intercom.fromJson(json['intercom']) : null;
    crisp = json['crisp'] != null ? Crisp.fromJson(json['crisp']) : null;
    chatbot = json['chatbot'] != null ? Chatbot.fromJson(json['chatbot']) : null;
    crazyegg = json['crazyegg'] != null ? Crazyegg.fromJson(json['crazyegg']) : null;
    zendesk = json['zendesk'] != null ? Zendesk.fromJson(json['zendesk']) : null;
    tawkto = json['tawkto'] != null ? Tawkto.fromJson(json['tawkto']) : null;
    z5dmo = json['z5dmo'] != null ? Landbotio.fromJson(json['z5dmo']) : null;
    getbutton = json['getbutton'] != null ? Getbutton.fromJson(json['getbutton']) : null;
    smartarget =
        json['smartarget'] != null ? Smartarget.fromJson(json['smartarget']) : null;
    googleAnalytics = json['google_analytics'] != null
        ? Google_analytics.fromJson(json['googleAnalytics'])
        : null;
    drdsh = json['drdsh'] != null ? Drdsh.fromJson(json['drdsh']) : null;
    landbotio = json['landbotio'] != null ? Landbotio.fromJson(json['landbotio']) : null;
    purchaseEvent = json['purchase_event'];
  }
}

class Getbutton {
  Params? params;

  Getbutton.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
  }
}

class Landbotio {
  Params? params;
  String? globalHeadScript;
  String? purchaseEvent;

  Landbotio.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    globalHeadScript = json['global_head_script'];
    purchaseEvent = json['purchase_event'];
  }
}

class Drdsh {
  Params? params;
  String? globalHeadScript;

  Drdsh({this.params, this.globalHeadScript});

  Drdsh.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    globalHeadScript = json['global_head_script'];
  }
}

class Params {
  String? drdshParams;
  String? googleAnalyticsParams;
  String? smartargetParams;
  String? tawktoParams;
  String? zendeskParams;
  String? crazyeggParams;
  String? chatbotParams;
  String? landbotioParams;
  String? crispParams;
  String? intercomParams;
  String? tidioParams;
  String? linkarabydbParams;
  String? livechatParams;
  String? snapchatPixelParams;
  String? z5dmo_params;
  String? getbutton_params;

  Params.fromJson(dynamic json) {
    googleAnalyticsParams = json['google_analytics_params'];
    smartargetParams = json['smartarget_params'];
    drdshParams = json['drdsh_params'];
    tawktoParams = json['tawkto_params'];
    zendeskParams = json['zendesk_params'];
    crazyeggParams = json['crazyegg_params'];
    chatbotParams = json['chatbotParams'];
    landbotioParams = json['landbotio_params'];
    crispParams = json['crisp_params'];
    intercomParams = json['intercom_params'];
    tidioParams = json['tidio_params'];
    linkarabydbParams = json['linkarabydb_params'];
    livechatParams = json['livechat_params'];
    snapchatPixelParams = json['snapchat_pixel_params'];
    z5dmo_params = json['z5dmo_params'];
    getbutton_params = json['getbutton_params'];
  }
}

class Google_analytics {
  Params? params;

  Google_analytics({this.params});

  Google_analytics.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
  }
}

class Smartarget {
  Params? params;
  String? globalHeadScript;

  Smartarget({this.params, this.globalHeadScript});

  Smartarget.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    globalHeadScript = json['global_head_script'];
  }
}

class Tawkto {
  Params? params;
  String? globalHeadScript;

  Tawkto({this.params, this.globalHeadScript});

  Tawkto.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    globalHeadScript = json['global_head_script'];
  }
}

class Zendesk {
  Params? params;
  String? globalHeadScript;

  Zendesk({this.params, this.globalHeadScript});

  Zendesk.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    globalHeadScript = json['global_head_script'];
  }
}

class Crazyegg {
  Params? params;
  String? globalHeadScript;

  Crazyegg.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    globalHeadScript = json['global_head_script'];
  }
}

class Chatbot {
  Params? params;
  String? globalHeadScript;

  Chatbot.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    globalHeadScript = json['global_head_script'];
  }
}

class Crisp {
  Params? params;
  String? globalHeadScript;

  Crisp.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    globalHeadScript = json['global_head_script'];
  }
}

class Intercom {
  Params? params;
  String? globalHeadScript;

  Intercom.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    globalHeadScript = json['global_head_script'];
  }
}

class Tidio {
  Params? params;
  String? globalHeadScript;

  Tidio.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    globalHeadScript = json['global_head_script'];
  }
}

class Linkarabydb {
  Params? params;
  String? globalHeadScript;

  Linkarabydb.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    globalHeadScript = json['global_head_script'];
  }
}

class Livechat {
  Params? params;
  String? globalHeadScript;

  Livechat({this.params, this.globalHeadScript});

  Livechat.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    globalHeadScript = json['global_head_script'];
  }
}

class Snapchat_pixel {
  Params? params;
  String? globalHeadScript;

  Snapchat_pixel({this.params, this.globalHeadScript});

  Snapchat_pixel.fromJson(dynamic json) {
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    globalHeadScript = json['global_head_script'];
  }
}

class Head_scripts {
  String? snapchatPixel;
  String? livechat;
  String? linkarabydb;
  String? tidio;
  String? intercom;
  String? crisp;
  String? chatbot;
  String? crazyegg;
  String? zendesk;
  String? tawkto;
  String? smartarget;
  String? googleAnalytics;
  String? drdsh;
  String? landbotio;
  String? getbutton;

  Head_scripts.fromJson(dynamic json) {
    snapchatPixel = json['snapchat_pixel'];
    livechat = json['livechat'];
    linkarabydb = json['linkarabydb'];
    tidio = json['tidio'];
    intercom = json['intercom'];
    crisp = json['crisp'];
    chatbot = json['chatbot'];
    crazyegg = json['crazyegg'];
    zendesk = json['zendesk'];
    tawkto = json['tawkto'];
    smartarget = json['smartarget'];
    googleAnalytics = json['google_analytics'];
    drdsh = json['drdsh'];
    landbotio = json['landbotio'];
    getbutton = json['getbutton'];
  }
}

class Languages {
  int? id;
  String? name;
  String? code;

  Languages({this.id, this.name, this.code});

  Languages.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    return map;
  }
}

class Language {
  int? id;
  String? name;
  String? code;

  Language({this.id, this.name, this.code});

  Language.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    return map;
  }
}

class Currencies {
  int? id;
  String? name;
  String? code;
  String? symbol;
  CountryModel? country;

  Currencies({this.id, this.name, this.code, this.symbol, this.country});

  Currencies.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    symbol = json['symbol'];

    country = json['country'] != null ? CountryModel.fromJson(json['country']) : null;
  }
}

class Currency {
  int? id;
  String? name;
  String? code;
  String? symbol;
  CountryModel? country;

  Currency({this.id, this.name, this.code, this.symbol, this.country});

  Currency.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    symbol = json['symbol'];
    country = json['country'] != null ? CountryModel.fromJson(json['country']) : null;
  }
}

class Footer {
  AboutUs? aboutUs;
  Links? links;
  BusinessLocation? businessLocation;
  SocialMedia? socialMedia;
  List<PaymentMethods>? paymentMethods;
  List<ShippingMethods>? shippingMethods;

  Footer.fromJson(dynamic json) {
    aboutUs = json['about_us'] != null ? AboutUs.fromJson(json['about_us']) : null;
    socialMedia =
        json['social_media'] != null ? SocialMedia.fromJson(json['social_media']) : null;
    if (json['payment_methods'] != null) {
      paymentMethods = [];
      json['payment_methods'].forEach((v) {
        paymentMethods?.add(PaymentMethods.fromJson(v));
      });
    }
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    if (json['shipping_methods'] != null) {
      shippingMethods = [];
      json['shipping_methods'].forEach((v) {
        shippingMethods?.add(ShippingMethods.fromJson(v));
      });
    }

    businessLocation = json['business_location'] != null
        ? BusinessLocation.fromJson(json['business_location'])
        : null;
/*
    if (json['shipping_methods'] != null) {
      shippingMethods = [];
      json['shipping_methods'].forEach((v) {
        shippingMethods?.add(Shipping_methods.fromJson(v));
      });
    }
*/
  }
}

class ShippingMethods {
  String? name;
  String? icon;

  ShippingMethods({this.name, this.icon});

  ShippingMethods.fromJson(dynamic json) {
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['icon'] = icon;
    return map;
  }
}

class PaymentMethods {
  String? name;
  String? icon;

  PaymentMethods.fromJson(dynamic json) {
    name = json['name'];
    icon = json['icon'];
  }
}

class SocialMedia {
  String? title;
  Items? items;

  SocialMedia.fromJson(dynamic json) {
    title = json['title'];
    items = json['items'] != null ? Items.fromJson(json['items']) : null;
  }
}

class Items {
  String? facebook;
  String? tiktok;
  String? twitter;
  String? instagram;
  String? snapchat;
  String? maroof;
  String? website;
  String? phone;
  String? email;
  int? id;
  bool? isSystemPage;
  bool? enabled;
  String? name;
  String? url;
  String? slug;

  Items.fromJson(dynamic json) {
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    tiktok = json['tiktok'];
    snapchat = json['snapchat'];
    maroof = json['maroof'];
    website = json['website'];
    phone = json['phone'];
    email = json['email'];
    id = json['id'];
    isSystemPage = json['is_system_page'];
    enabled = json['enabled'];
    name = json['name'];
    url = json['url'];
    slug = json['slug'];
  }
}

class BusinessLocation {
  CountryModel? country;
  City? city;
  String? district;
  String? street;
  dynamic? buildingNo;
  dynamic? postalCode;
  dynamic? additionalPostalCode;
  String? lat;
  String? lng;
  bool? showLocation;

  BusinessLocation.fromJson(dynamic json) {
    country = json['country'] != null ? CountryModel.fromJson(json['country']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    district = json['district'] == 'null' ? null : json['district'];
    street = json['street'] == 'null' ? null : json['street'];
    buildingNo = json['building_no'];
    postalCode = json['postal_code'];
    additionalPostalCode = json['additional_postal_code'];
    lat = json['lat'];
    lng = json['lng'];
    showLocation = json['show_location'];
  }
}

class City {
  int? id;
  String? name;
  int? priority;
  int? countryId;
  String? countryName;
  String? countryCode;
  String? arName;
  String? enName;
  String? customName;

  City.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    priority = json['priority'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    countryCode = json['country_code'];
    arName = json['ar_name'];
    enName = json['en_name'];
    customName = isArabicLanguage ? arName : (enName ?? arName);
  }
}

class Links {
  bool? enabled;
  String? title;
  List<Items>? items;
  List<PageModel>? itemsNotSystem;

  Links({this.enabled, this.title, this.items});

  Links.fromJson(dynamic json) {
    enabled = json['enabled'];
    title = json['title'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
    if (json['items'] != null) {
      itemsNotSystem = [];
      json['items'].forEach((v) {
        PageModel item = PageModel.fromJson(v);
        if (item.isSystemPage == false &&
            item.enabled == true /*&& item.name?.isNotEmpty == true*/)
          itemsNotSystem?.add(item);
      });
    }
  }
}

class AboutUs {
  bool? enabled;
  String? title;
  String? text;

  AboutUs.fromJson(dynamic json) {
    enabled = json['enabled'];
    title = json['title'];
    text = json['text'];
  }
}

class Header {
  AnnouncementBar? announcementBar;
  Logo? logo;
  Menu? menu;
  Menu? menu2;
  Cart? cart;
  Destinations? destinations;

  Header.fromJson(dynamic json) {
    announcementBar = json['announcement_bar'] != null
        ? AnnouncementBar.fromJson(json['announcement_bar'])
        : null;
    logo = json['logo'] != null ? Logo.fromJson(json['logo']) : null;
    menu = json['menu'] != null ? Menu.fromJson(json['menu']) : null;
    cart = json['cart'] != null ? Cart.fromJson(json['cart']) : null;
    destinations = json['destinations'] != null && json['destinations'] is! List
        ? Destinations.fromJson(json['destinations'])
        : null;
    menu2 = json['menu_v2'] != null ? Menu.fromJson(json['menu_v2']) : null;
  }
}

class Cart {
  int? count;
  bool? isReserved;

  Cart.fromJson(dynamic json) {
    count = json['count'];
    isReserved = json['is_reserved'];
  }
}

class Destinations {
  List<CountryModel>? countries;

  Destinations.fromJson(dynamic json) {
    if (json['countries'] != null) {
      countries = [];
      json['countries'].forEach((v) {
        countries?.add(CountryModel.fromJson(v));
      });
    }
  }
}

class Menu {
  String? id;
  String? label;
  String? location;
  String? slug;
  String? type;
  int? sortOrder;
  bool? isVisible;
  List<CategoryModel>? items;
  List<Menu>? children;

  Menu.fromJson(dynamic json) {
    id = json['id'];
    label = json['label'];
    location = json['location'];
    slug = json['slug'];
    type = json['type'];
    //sortOrder = json['sort_order'];
    isVisible = json['is_visible'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        var item = CategoryModel.fromJson(v);
        if (item.name == 'جميع المنتجات' || item.name == 'all products') {
          item.url = '/products/';
          item.id = null;
        }
        if (item.name == 'جميع التصنيفات' || item.name == 'all categories') {
          item.id = null;
          item.url = '/categories/';
        }
        if (item.name != 'homepage' && item.name != 'الصفحة الرئيسية') {
          items?.add(item);
        }
      });
    }
    if (isArabicLanguage) {
      try {
        var itemAllProduct =
            items?.firstWhere((element) => element.name == 'جميع المنتجات');
        items?.remove(itemAllProduct!);
        items?.insert(0, itemAllProduct!);
      } catch (e) {}
      try {
        var itemAllCategory =
            items?.firstWhere((element) => element.name == 'جميع التصنيفات');
        items?.remove(itemAllCategory!);
        items?.add(itemAllCategory!);
      } catch (e) {}
    } else {
      items?.sort((a, b) => a.name!.compareTo('all products'));
      try {
        var itemAllCategory =
            items?.firstWhere((element) => element.name == 'all categories');
        items?.remove(itemAllCategory!);
        items?.add(itemAllCategory!);
      } catch (e) {}
    }

    if (json['children'] != null) {
      children = [];
      json['children'].forEach((v) {
        children?.add(Menu.fromJson(v));
      });
    }
  }
}

class Logo {
  String? title;
  String? image;

  Logo.fromJson(dynamic json) {
    title = json['title'];
    image = json['image'];
  }
}

class AnnouncementBar {
  bool? enabled;
  bool? displayInHomepage;
  bool? displayInAllPages;
  String? text;
  String? link;
  Style? style;

  AnnouncementBar.fromJson(dynamic json) {
    enabled = json['enabled'];
    displayInHomepage = json['display_in_homepage'];
    displayInAllPages = json['display_in_all_pages'];
    text = json['text'];
    link = json['link'];
    style = json['style'] != null ? Style.fromJson(json['style']) : null;
  }
}

class Style {
  String? foregroundColor;
  String? backgroundColor;

  Style.fromJson(dynamic json) {
    foregroundColor = json['foreground_color'];
    backgroundColor = json['background_color'];
  }
}
