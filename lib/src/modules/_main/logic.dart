import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:entaj/src/modules/_main/widgets/select_city_dialog.dart';
import 'package:entaj/src/modules/cart/logic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as ui;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../main.dart';
import '../../.env.dart';
import '../../app_config.dart';
import '../../data/hive/wishlist/hive_controller.dart';
import '../../data/remote/api_requests.dart';
import '../../data/shared_preferences/pref_manger.dart';
import '../../entities/AppBuilderModel.dart';
import '../../entities/ColorsModel.dart';
import '../../entities/category_model.dart';
import '../../entities/country_model.dart';
import '../../entities/faq_model.dart';
import '../../entities/home_screen_model.dart';
import '../../entities/home_screen_new_theme_model.dart';
import '../../entities/module_model.dart' as module_model;
import '../../entities/page_model.dart';
import '../../entities/setting_model.dart';
import '../../utils/error_handler/error_handler.dart';
import '../../utils/functions.dart';
import '../cart/view.dart';
import '../delivery_option/logic.dart';
import '../delivery_option/view.dart';
import '../notification/view.dart';
import '../search/view.dart';
import '../wishlist/view.dart';
import 'data.dart';
import 'tabs/account/logic.dart';
import 'tabs/account/view.dart';
import 'tabs/categories/view.dart';
import 'tabs/home/view.dart';
import 'widgets/bonat_widget.dart';

class MainLogic extends GetxController {
  late WebViewController controllerTidio;
  late WebViewController controllerLiveChat;
  late WebViewController controllerChatBot;
  bool isTidioLoading = true;
  bool isLiveChatLoading = true;
  bool isChatBotLoading = true;

  @override
  void onInit() async {
    Get.lazyPut<MainData>(() => MainData());
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        if (!hasInternet) {
          if (categoriesList.isEmpty && !isCategoriesLoading) getCategories();
          if (settingModel == null && !isStoreSettingLoading) getStoreSetting();
          if (pageModelPrivacy == null && !isStoreSettingLoading) {
            getStoreSetting();
          }
        }
        hasInternet = true;
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      Get.find<MainData>().onInit();
    });
    super.onInit();
  }

  final ApiRequests _apiRequests = Get.find();
  final PrefManger _prefManger = Get.find();
  final MainData mainData = MainData();
  final DeliveryOptionLogic _deliveryOptionLogic = Get.find();
  final ui.TextEditingController closeEmailController = ui.TextEditingController();

  List<FaqModel> faqList = [];
  List<PageModel> pagesList = [];
  ui.Widget _currentScreen = HomePage();
  List<CategoryModel> categoriesList = [];
  List<CategoryModel> categoriesListWithoutAllProduct = [];
  List<CategoryModel> categoriesListAsayel = [];
  List<CategoryModel> menuSettingsMarkat = [];
  List<CategoryModel> menuSettingsLinks = [];

  List<CategoryModel> mainMenuList = [];
  List<CategoryModel> sideMenuList = [];
  List<String> navigationOptions = [];

  HomeScreenModel? homeScreenModel;
  module_model.Settings? footerSettings;
  module_model.Settings? headerSettings;
  HomeScreenNewThemeModel? homeScreenNewThemeModel;
  ColorsModel? colorsModel;
  List<AppBuilderModel> appBuilderModelList = [];
  Slider? slider;
  Testimonials? testimonials;
  SettingModel? settingModel;
  int _navigatorValue = 0;
  bool hasInternet = true;
  bool showAppBar = true;
  bool isPagesLoading = false;
  bool isCategoriesLoading = false;
  bool isAppBuilderHomeLoading = false;
  bool isHomeLoading = false;
  bool isFaqLoading = false;
  bool isStoreSettingLoading = false;
  bool isBonatLoading = false;
  bool isSaveCountryLoading = false;
  bool showAnnouncementBar = true;
  bool hideRoyalThemeLinks = true;
  CountryModel? selectedCurrencyModel;
  CountryModel? tempSelectedCurrencyModel;
  CountryModel? selectedCountryModel;
  CountryModel? selectedCityModel;
  CountryModel? tempSelectedCityModel;
  CountryModel? tempSelectedCountryModel;
  PageModel? pageModelPrivacy;
  PageModel? pageModelLicense;
  PageModel? pageModelTerms;
  PageModel? pageModelSuggestions;
  PageModel? pageModelRefund;
  int? selectedIndex;
  String? bonatUrl;

  get navigatorValue => _navigatorValue;

  get currentScreen => _currentScreen;

  List tap0List = [];
  List tap1List = [];
  List tap2List = [];
  List tap3List = [];
  List tap4List = [];

  openTap(int index) {
    if (selectedIndex == index) {
      selectedIndex = null;
      update();
      return;
    }
    selectedIndex = index;
    update(['faq']);
  }

  Future<bool> checkInternetConnection() async {
    var connection =
        (await Connectivity().checkConnectivity() != ConnectivityResult.none);

    hasInternet = connection;
    update();
    return connection;
  }

  double chatBotHeight = 0;
  double tidioChatHeight = 0;
  double liveChatHeight = 0;
  double bonatHeight = 0;

  openTidioChat() async {
    if (tidioChatHeight == 0) {
      tidioChatHeight = double.infinity;
    } else {
      tidioChatHeight = 0;
      liveChatHeight = 0;
    }
    update();
  }

  openLiveChat() async {
    if (liveChatHeight == 0) {
      liveChatHeight = double.infinity;
    } else {
      tidioChatHeight = 0;
      liveChatHeight = 0;
    }
    update();
  }

  openChatBot() async {
    if (chatBotHeight == 0) {
      chatBotHeight = double.infinity;
    } else {
      tidioChatHeight = 0;
      liveChatHeight = 0;
      chatBotHeight = 0;
    }
    update();
  }

  openBonat() async {
    if (bonatHeight == 0) {
      loadBonat();
      bonatHeight = double.infinity;
    } else {
      bonatHeight = 0;
      tidioChatHeight = 0;
      liveChatHeight = 0;
    }
    update();
  }

  void changeSelectedValue(int selectedValue, bool withUpdate, {required int backCount}) {
    _navigatorValue = selectedValue;
    switch (selectedValue) {
      case 0:
        {
          _currentScreen = HomePage();
          showAppBar = true;
          for (var i = backCount; i >= 1; i--) {
            Get.back();
          }
          break;
        }
      case 1:
        {
          _currentScreen = CategoriesPage();
          showAppBar = true;
          for (var i = backCount; i >= 1; i--) {
            Get.back();
          }
          break;
        }
      case 2:
        {
          _currentScreen = CartPage();
          showAppBar = false;
          for (var i = backCount; i >= 1; i--) {
            Get.back();
          }
          break;
        }
      case 3:
        {
          showAppBar = false;
          _currentScreen = const WishlistPage();
          for (var i = backCount; i >= 1; i--) {
            Get.back();
          }
          break;
        }
      case 4:
        {
          _currentScreen = AccountPage();
          showAppBar = false;
          for (var i = backCount; i >= 1; i--) {
            Get.back();
          }
          break;
        }
    }
    tidioChatHeight = 0;
    liveChatHeight = 0;
    if (withUpdate) update();
  }

  goToTwitter({String? twitter}) {
    launch(
        "https://www.twitter.com/${twitter ?? homeScreenModel?.storeDescription?.socialMediaIcons?.twitter}");
  }

  goToWhatsApp({String? message}) async {
    String whatsAppUrl = "";
    String message = remoteConfig.getString(WA_HOME_KEY).isNotEmpty == true
        ? remoteConfig.getString(WA_HOME_KEY)
        : 'راسلنا';

    String phoneNumber =
        settingModel?.settings?.headScriptsApps?.getbutton?.params?.getbutton_params ??
            settingModel?.settings?.headScripts?.getbutton ??
            '';
    whatsAppUrl =
        'https://wa.me/+$phoneNumber?text=${Uri.encodeComponent(message ?? '')}';
    whatsAppUrl = whatsAppUrl.replaceAll('++', '+');

    var whatsAppUrlFinal = whatsAppUrl;

    launchWhatsapp(whatsAppUrlFinal);
  }

  goToSnapchat({String? snapchat}) {
    launch(
        "https://www.snapchat.com/add/${snapchat ?? homeScreenModel?.storeDescription?.socialMediaIcons?.snapchat}");
  }

  goToPhone({String? phone}) {
    launch(
        "tel://${phone ?? homeScreenModel?.storeDescription?.socialMediaIcons?.phone}");
  }

  goToEmail({String? email}) async {
    final Uri params = Uri(
        scheme: 'mailto',
        path: homeScreenModel?.storeDescription?.socialMediaIcons?.email,
        queryParameters: {'subject': '', 'body': ''});
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  goToInstagram({String? instagram}) {
    launch(
        "https://www.instagram.com/${instagram ?? homeScreenModel?.storeDescription?.socialMediaIcons?.instagram}");
  }

  goToFacebook({String? facebook}) {
    launch(
        "https://www.facebook.com/${facebook ?? homeScreenModel?.storeDescription?.socialMediaIcons?.facebook}");
  }

  void goToSearch() {
    Get.to(const SearchPage());
  }

  void goToNotification() {
    Get.to(NotificationPage());
  }

  void goToDeliveryOptions() {
    Get.to(DeliveryOptionPage());
  }

  Future<void> getStoreSetting() async {
    if (AppConfig.useAppBuilder) mainData.getAppBuilderSections();
    isStoreSettingLoading = true;
    update();
    try {
      var response = await _apiRequests.getStoreSetting();
      settingModel = SettingModel.fromJson(response.data['payload']);
      var storefrontThemeId = settingModel?.settings?.storefrontTheme?.id;
      AppConfig.multiInventoryVersion =
          settingModel?.settings?.isFilterProductsBasedOnCity == true &&
              settingModel?.header?.destinations?.countries?.isNotEmpty == true &&
              remoteConfig.getBool(IS_MULTI_INVENTORY_ENABLE_KEY);
      if (AppConfig.multiInventoryVersion) {
        if (settingModel?.settings?.isFilterProductsBasedOnCity == true &&
            settingModel?.header?.destinations?.countries?.isNotEmpty == true &&
            HiveController.generalBox.get('city') == null) {
          selectedCountryModel = settingModel?.header?.destinations?.countries?.first;
          selectedCityModel = selectedCountryModel?.cities?.first;
          await Get.dialog(const SelectCityDialog(), barrierDismissible: false);
          await _apiRequests.onInit();
        } else {
          settingModel?.header?.destinations?.countries?.forEach((element) {
            if (element.id == HiveController.generalBox.get('country')) {
              selectedCountryModel = element;
              element.cities?.forEach((elementCity) {
                if (elementCity.id == HiveController.generalBox.get('city')) {
                  selectedCityModel = elementCity;
                }
              });
            }
          });
        }
      }
      log(selectedCityModel.toString());
      log("storefrontThemeId => " + storefrontThemeId.toString());
      if (kDebugMode) {
        //storefrontThemeId = royalThemeId;
      }
      if (storefrontThemeId == softThemeId ||
          storefrontThemeId == eshraqThemeId ||
          storefrontThemeId == royalThemeId ||
          storefrontThemeId == duvetThemeId ||
          storefrontThemeId == monkeyThemeId ||
          storefrontThemeId == naquaThemeId ||
          storefrontThemeId == foodyThemeId ||
          storefrontThemeId == balsamThemeId ||
          storefrontThemeId == perfectThemeId ||
          storefrontThemeId == ghassqThemeId ||
          storefrontThemeId == asayelThemeId ||
          storefrontThemeId == asayelStagingThemeId ||
          storefrontThemeId == loaLoaThemeId ||
          storefrontThemeId == gloryThemeId ||
          storefrontThemeId == alphaThemeId ||
          storefrontThemeId == zeyadaThemeId ||
          storefrontThemeId == customThemeId) {
        AppConfig.isSoreUseNewTheme = true;
        AppConfig.currentThemeId = storefrontThemeId;
        if (storefrontThemeId == asayelStagingThemeId) {
          asayelThemeId = asayelStagingThemeId;
        }
        getHomeScreen(themeId: storefrontThemeId);
      } else {
        AppConfig.isSoreUseNewTheme = false;
        getHomeScreen();
      }

      showAnnouncementBar = true;
      settingModel?.settings?.currencies?.forEach((element) {
        if (element.code == HiveController.generalBox.get('currency')) {
          selectedCurrencyModel = element;
        }
      });
      selectedCurrencyModel ??= settingModel?.settings?.currency;
      mainData.initWebViewControllers();
      // settingModel?.footer?.links?.itemsNotSystem = await mainData.getContentPages(settingModel?.footer?.links?.itemsNotSystem ?? []);
    } catch (e) {
      log(e.toString());

      hasInternet = await ErrorHandler.handleError(e);
      AppConfig.isSoreUseNewTheme = false;
      getHomeScreen();
    }
    isStoreSettingLoading = false;
    update();
  }

  Future<void> getCategories() async {
    if (!await checkInternetConnection()) return;
    isCategoriesLoading = true;
    update(['categories', 'categories2', 'categoriesMenu']);
    try {
      var response = await _apiRequests.getCategories();
      categoriesList = [];
      categoriesListAsayel = [];
      categoriesListWithoutAllProduct = [];
      categoriesList.add(CategoryModel.fromJson({
        'id': '*',
        'url': '/products/',
        'name': 'جميع المنتجات'.tr,
        'sub_categories': []
      }));
      categoriesList.addAll((response.data['payload'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList());
      categoriesListAsayel = ((response.data['payload'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList());
      categoriesListAsayel.addAll(menuSettingsLinks);
      categoriesListWithoutAllProduct.addAll((response.data['payload'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList());

      if (AppConfig.isEnglishLanguageEnable) {
        if (!checkCategoryContent()) {
          var apiRequestOther =
              Get.find<ApiRequests>(tag: isArabicLanguage ? 'en' : 'ar');
          await apiRequestOther.onInit();
          var responseOther = await apiRequestOther.getCategories();
          List<CategoryModel> categoriesListOther = [];
          List<CategoryModel> categoriesListWithoutAllProductOther = [];
          categoriesListOther.add(CategoryModel.fromJson(
              {'id': '*', 'name': 'جميع المنتجات'.tr, 'sub_categories': []}));
          categoriesListOther.addAll((responseOther.data['payload'] as List)
              .map((e) => CategoryModel.fromJson(e))
              .toList());
          categoriesListWithoutAllProductOther.addAll(
              (responseOther.data['payload'] as List)
                  .map((e) => CategoryModel.fromJson(e))
                  .toList());

          for (var element in categoriesList) {
            int elementIndex = categoriesList.indexOf(element);
            if (element.name?.isNotEmpty != true) {
              element.name = categoriesListOther[elementIndex].name;
            }

            element.subCategories.forEach((elementSub) {
              int elementSubIndex =
                  categoriesList[elementIndex].subCategories.indexOf(elementSub);
              if (elementSub.name?.isNotEmpty != true) {
                elementSub.name =
                    categoriesListOther[elementIndex].subCategories[elementSubIndex].name;
              }
              elementSub.subCategories.forEach((elementSubSub) {
                int elementSubSubIndex = categoriesList[elementIndex]
                    .subCategories[elementSubIndex]
                    .subCategories
                    .indexOf(elementSubSub);
                if (elementSubSub.name?.isNotEmpty != true) {
                  elementSubSub.name = categoriesListOther[elementIndex]
                      .subCategories[elementSubIndex]
                      .subCategories[elementSubSubIndex]
                      .name;
                }
              });
            });
          }

          for (var element in categoriesListWithoutAllProduct) {
            int elementIndex = categoriesListWithoutAllProduct.indexOf(element);
            if (element.name?.isNotEmpty != true) {
              element.name = categoriesListWithoutAllProductOther[elementIndex].name;
            }
          }
        }
      }
    } catch (e) {
      hasInternet = await ErrorHandler.handleError(e);
    }
    isCategoriesLoading = false;
    update(['categories', 'categories2', 'categoriesMenu']);
  }

  Future<void> getHomeScreen({String? themeId}) async {
    isHomeLoading = true;
    update();
    try {
      if (AppConfig.isSoreUseNewTheme) {
        var response = await _apiRequests.getHomeScreenNewTheme(themeId);
        homeScreenNewThemeModel = HomeScreenNewThemeModel.fromJson(response.data);

        homeScreenNewThemeModel?.payload?.files?.forEach((element) {
          if (element.name == 'footer.twig') {
            if (element.modules?.isNotEmpty == true) {
              footerSettings = element.modules?.first.settings;
            }
          }
          if (element.name == 'header.twig') {
            if (element.modules?.isNotEmpty == true) {
              element.modules?.forEach((elementModule) {
                headerSettings = elementModule.settings;
                categoriesListAsayel
                    .addAll(elementModule.settings?.menuSettingslinks ?? []);
                menuSettingsLinks = (elementModule.settings?.menuSettingslinks ?? []);
                menuSettingsMarkat = (elementModule.settings?.menuSettingsMarkat ?? []);
                navigationOptions = (elementModule.settings?.navigationOptions ?? []);
                hideRoyalThemeLinks = elementModule.settings?.links1Hide ?? false;
              });
            }
          }
        });

        footerSettings?.links1Links =
            await mainData.getContentPages(footerSettings?.links1Links ?? []);
        footerSettings?.links2Links =
            await mainData.getContentPages(footerSettings?.links2Links ?? []);
        if (AppConfig.showProductOffer) {
          await mainData.getOffers();
        }
      } else {
        var response = await _apiRequests.getHomeScreen();
        homeScreenModel = HomeScreenModel.fromJson(response.data['payload']);
        slider = Slider.fromJson(response.data['payload']['slider']);
        testimonials = Testimonials.fromJson(response.data['payload']['testimonials']);
        if (AppConfig.showProductOffer) {
          await mainData.getOffers();
        }
        showAnnouncementBar = true;
      }
    } catch (e, s) {
      hasInternet = await ErrorHandler.handleError(e, stacktrace: s);
    }
    handleMainMenuList();
    handleSideMenuList();
    isHomeLoading = false;
    update();
  }

  Future<void> refreshData() async {
    if (!await checkInternet()) return;
    getStoreSetting();
    mainData.getPages(false);
    getCategories();
  }

  addAvailability() {}

  goToTiktok({String? tiktok}) {
    launch(
        "https://www.tiktok.com/@${tiktok ?? homeScreenModel?.storeDescription?.socialMediaIcons?.tiktok}");
  }

  goToMaroof() async {
    if (!await checkInternet()) return;
    launch(settingModel?.footer?.socialMedia?.items?.maroof ?? '');
  }

  bool checkCategoryContent() {
    bool hasContent = true;
    for (var element in categoriesList) {
      if (element.name?.isNotEmpty != true) hasContent = false;
      element.subCategories.forEach((elementSub) {
        if (elementSub.name?.isNotEmpty != true) hasContent = false;
        elementSub.subCategories.forEach((elementSubSub) {
          if (elementSubSub.name?.isNotEmpty != true) hasContent = false;
        });
      });
    }
    log(hasContent.toString());
    return hasContent;
  }

  hideTidioIcon(int removeType) {
    if (removeType == 1) {
      AppConfig.showTidio = false;
      AppConfig.showTidioFromRemoteConfig = false;
    } else if (removeType == 2) {
      AppConfig.showLiveChat = false;
      AppConfig.showLiveChatFromRemoteConfig = false;
    } else if (removeType == 3) {
      AppConfig.showChatBot = false;
      AppConfig.showChatBotRemoteConfig = false;
    }
    update();
  }

  Future<void> loadBonat() async {
    if (!await _prefManger.getIsLogin()) return;
    isBonatLoading = true;
    update(['bonat']);
    var user = Get.find<AccountLogic>().userModel;
    if (user == null) {
      await Get.find<AccountLogic>().getAccountDetails();
    }
    user = Get.find<AccountLogic>().userModel;
    String permalink =
        Get.find<MainLogic>().settingModel?.settings?.permalink ?? (storeUrl + '');
    var doubleSlashIndex = permalink.indexOf('//', 8);
    if (doubleSlashIndex != -1) {
      permalink = permalink.replaceRange(doubleSlashIndex, doubleSlashIndex + 1, '');
    }
    doubleSlashIndex = permalink.indexOf('/', 8);
    if (doubleSlashIndex != -1) {
      permalink = permalink.replaceRange(doubleSlashIndex, doubleSlashIndex + 1, '');
    }
    bonatUrl =
        'https://plugin.bonat.io/?storeLink=$permalink&customerId=${user?.id}&phoneNumber=${user?.mobile}&lang=${isArabicLanguage ? 'ar' : 'en'}';
    update(['bonat']);
    try {
      await bonatController.loadRequest(Uri.parse(bonatUrl ?? ''));
    } catch (e) {}
    await Future.delayed(const Duration(seconds: 2));
    isBonatLoading = false;
    update(['bonat']);
  }

  onChangeCountry(CountryModel? val, bool temp) {
    tempSelectedCountryModel = val;
    tempSelectedCityModel = val?.cities?.first;
    if (!temp) {
      selectedCountryModel = val;
      selectedCityModel = val?.cities?.first;
      HiveController.generalBox.put('country', selectedCountryModel?.id);
      HiveController.generalBox.put('city', selectedCityModel?.id);
    }
    update(['SelectCityDialog']);
  }

  onChangeCity(CountryModel? val, bool temp) {
    tempSelectedCityModel = val;
    if (!temp) {
      selectedCityModel = val;
      HiveController.generalBox.put('city', selectedCityModel?.id);
    }
    update(['SelectCityDialog']);
  }

  onChangeCurrency(CountryModel? currencies, bool temp) {
    tempSelectedCurrencyModel = currencies;
    if (!temp) {
      selectedCurrencyModel = currencies;
    }
    update(['SelectCityDialog']);
  }

  saveCountry() async {
    isSaveCountryLoading = true;
    update(['SelectCityDialog']);
    try {
      HiveController.generalBox.put('currency', tempSelectedCurrencyModel?.code);
      HiveController.generalBox.put('country', tempSelectedCountryModel?.id);
      HiveController.generalBox.put('city', tempSelectedCityModel?.id);
      await _apiRequests.onInit();
      if (AppConfig.multiInventoryVersion &&
          (HiveController.generalBox.get('city') != selectedCityModel?.id)) {
        await Get.find<ApiRequests>().deleteSession();
        await ErrorHandler.generateSession(false, renewSession: true);
      }
      selectedCountryModel = tempSelectedCountryModel;
      selectedCityModel = tempSelectedCityModel;
      selectedCurrencyModel = tempSelectedCurrencyModel;
      getStoreSetting();
      getCategories();
      await Get.find<CartLogic>().getCartItems(false);
      _deliveryOptionLogic.getShippingMethods(false);
      Get.back();
      HiveController.generalBox.values.forEach((element) {
        log(element.toString());
      });
    } catch (e, s) {
      ErrorHandler.handleError(e, stacktrace: s);
    }

    isSaveCountryLoading = false;
    update(['SelectCityDialog']);
  }

  void handleMainMenuList() {
    if (AppConfig.currentThemeId == alphaThemeId) {
      mainMenuList = [];
      return;
    }
    if (AppConfig.currentThemeId == gloryThemeId) {
      mainMenuList = [];
      return;
    }
    if (AppConfig.currentThemeId == royalThemeId) {
      if (hideRoyalThemeLinks) {
        mainMenuList = [];
        return;
      }
      mainMenuList = menuSettingsLinks;
      return;
    }

    List<CategoryModel> items = [];
    items.addAll(settingModel?.header?.menu2?.items ?? []);
    if (isArabicLanguage) {
      try {
        var itemAllProduct =
            items.firstWhere((element) => element.name == 'جميع المنتجات');
        items.remove(itemAllProduct);
        items.insert(0, itemAllProduct);
      } catch (e) {}
      try {
        var itemAllCategory =
            items.firstWhere((element) => element.name == 'جميع التصنيفات');
        items.remove(itemAllCategory);
        items.add(itemAllCategory);
      } catch (e) {}
    } else {
      items.sort((a, b) => a.name!.compareTo('all products'));
      try {
        var itemAllCategory =
            items.firstWhere((element) => element.name == 'all categories');
        items.remove(itemAllCategory);
        items.add(itemAllCategory);
      } catch (e) {}
    }
    if (AppConfig.currentThemeId == zeyadaThemeId &&
        !(headerSettings?.menuHideDiscount == true)) {
      items.add(CategoryModel.fromJson({
        'name': isArabicLanguage ? 'افضل العروض' : 'Offers',
        'url': '/products/sale'
      }));
    }
    if (navigationOptions.contains('hide_menu_categories') &&
        AppConfig.currentThemeId == perfectThemeId) {
      mainMenuList = [];
    } else {
      mainMenuList = items;
    }
  }

  void handleSideMenuList() {
    List<CategoryModel> items = [];
    if (AppConfig.currentThemeId == zeyadaThemeId) {
      items.addAll(categoriesListWithoutAllProduct);
      items.add(CategoryModel.fromJson({
        'name': !isArabicLanguage ? 'All Products' : 'جميع المنتجات',
        'url': '/products/'
      }));
      items.add(CategoryModel.fromJson({
        'name': !isArabicLanguage ? 'All Categories' : 'جميع الأقسام',
        'url': '/categories/'
      }));
      items.add(CategoryModel.fromJson({
        'name': isArabicLanguage ? 'افضل العروض' : 'Offers',
        'url': '/products/sale'
      }));
      sideMenuList = items;
      return;
    }
    items.addAll(settingModel?.header?.menu2?.items ?? []);

    if (isArabicLanguage) {
      try {
        var itemAllProduct =
            items.firstWhere((element) => element.name == 'جميع المنتجات');
        items.remove(itemAllProduct);
        if (AppConfig.currentThemeId == zeyadaThemeId) {
          items.add(itemAllProduct);
        } else {
          items.insert(0, itemAllProduct);
        }
      } catch (e) {}
      try {
        var itemAllCategory =
            items.firstWhere((element) => element.name == 'جميع التصنيفات');
        items.remove(itemAllCategory);
        if (AppConfig.currentThemeId == perfectThemeId) {
          var itemAllProduct =
              items.firstWhereOrNull((element) => element.name == 'جميع المنتجات');
          items.insert(itemAllProduct == null ? 0 : 1, itemAllCategory);
        } else {
          items.add(itemAllCategory);
        }
      } catch (e) {}
    } else {
      items.sort((a, b) => a.name!.compareTo('all products'));
      try {
        var itemAllCategory =
            items.firstWhere((element) => element.name == 'all categories');
        var itemAllProduct =
            items.firstWhereOrNull((element) => element.name == 'all products');
        items.remove(itemAllCategory);
        if (AppConfig.currentThemeId == perfectThemeId) {
          items.insert(itemAllProduct == null ? 0 : 1, itemAllCategory);
        } else {
          items.add(itemAllCategory);
        }
      } catch (e) {}
    }
    if (AppConfig.currentThemeId == perfectThemeId &&
        navigationOptions.contains('hide_menu_categories')) {
      items.removeWhere((element) => element.id != null);
    }
    sideMenuList = items;
    if (AppConfig.currentThemeId == royalThemeId) {
      if (hideRoyalThemeLinks) {
        sideMenuList = [
          CategoryModel.fromJson({
            'name': 'جميع الأقسام',
          }, items: items)
        ];
        return;
      }
      sideMenuList = [
        CategoryModel.fromJson({'name': 'جميع الأقسام', 'url': '*'}, items: items),
      ];
      sideMenuList.addAll(menuSettingsLinks);
    }
    if (AppConfig.currentThemeId == alphaThemeId) {
      sideMenuList = [
        if (!(headerSettings?.headerOptions?.contains('hide_menu_all_products') == true))
          CategoryModel.fromJson({
            'name': 'جميع المنتجات',
            'image': headerSettings?.MenuIcons_allProducts,
            'url': '/products/'
          }),
        if (!(headerSettings?.headerOptions?.contains('hide_menu_all_categories') ==
            true))
          CategoryModel.fromJson({
            'name': 'تصنيفات المتجر',
            'image': headerSettings?.MenuIcons_allCategories,
            'url': '/categories/'
          }),
        if (!(headerSettings?.headerOptions?.contains('hide_menu_onsale_products') ==
            true))
          CategoryModel.fromJson({
            'name': 'منتجات مخفضة',
            'image': headerSettings?.MenuIcons_onSaleProducts,
            'url': '/products/sale'
          }),
        if (!(headerSettings?.headerOptions?.contains('hide_menu_newest_products') ==
            true))
          CategoryModel.fromJson({
            'name': 'احدث المنتجات',
            'image': headerSettings?.MenuIcons_newestProducts,
            'url': '/products/recent_products'
          }),
        ...headerSettings?.MenuCategories_categoriesList?.map((e) {
              return categoriesList.firstWhere((element) => element.id == e);
            }).toList() ??
            [],
        if (headerSettings?.links_links?.isNotEmpty == true)
          CategoryModel.fromJson(
            {
              'name': 'روابط قد تهمك',
              'image': headerSettings?.MenuIcons_CustomLinks,
            },
            items: headerSettings?.links_links ?? [],
          ),
        if (!(headerSettings?.headerOptions?.contains('hide_menu_delivery_payment') ==
            true))
          CategoryModel.fromJson({
            'name': 'خيارات الدفع والشحن',
            'image': headerSettings?.MenuIcons_DeliveryAndPayment,
            'url': '/shipping-and-payment/'
          }),
        if (!(headerSettings?.headerOptions?.contains('hide_menu_shopping_cart') == true))
          CategoryModel.fromJson({
            'name': 'سلة المشتريات',
            'image': headerSettings?.MenuIcons_ShoppingCart,
            'url': '/cart/'
          }),
      ];
      //sideMenuList.addAll(menuSettingsLinks);
    }
  }
}
