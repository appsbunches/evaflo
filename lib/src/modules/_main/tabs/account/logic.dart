import 'dart:developer';
import 'dart:io';

import 'package:url_launcher/url_launcher_string.dart';

import '../../../../app_config.dart';
import '../../../category_details/logic.dart';
import '../../../faq/view.dart';
import '../../../../utils/custom_widget/custom_text.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../../../data/remote/api_requests.dart';
import '../../../../data/shared_preferences/pref_manger.dart';
import '../../../../entities/user_model.dart';
import '../../../about_us/view.dart';
import '../../../delivery_option/logic.dart';
import '../../../delivery_option/view.dart';
import '../../../edit_account/view.dart';
import '../../../orders/view.dart';
import '../../logic.dart';
import '../../../page_details/view.dart';
import '../../../pages/view.dart';
import '../../../select_country/view.dart';
import '../../../../utils/error_handler/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/functions.dart';
import '../../../_auth/login/view.dart';
import '/main.dart';
import '../../../../.env.dart';

class AccountLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final MainLogic _mainLogic = Get.find();
  final PrefManger _prefManger = Get.find();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLogin = false;
  bool isLoading = false;
  bool isPrivacyLoading = false;
  bool isRefundLoading = false;
  bool isLogoutLoading = false;
  UserModel? userModel;
  String? startNumber;
  bool isEditLoading = false;

  @override
  onInit() {
    checkLoginState();
    super.onInit();
  }

  Future<void> checkLoginState() async {
    isLogin = await _prefManger.getIsLogin();
    update();
    if (isLogin) await getAccountDetails();
  }

  void goToEditAccount() {
    setData();
    Get.to(EditAccountPage());
  }

  void goToLogin() {
    Get.to(LoginPage())?.then((value) {
      checkLoginState();
    });
  }

  void goOrdersPage() {
    //   Get.to(LoginPage());
    Get.to(OrdersPage());
  }

  void goToAboutUsPage() async {
    if (!await checkInternet()) return;
    Get.to(AboutUsPage());
  }

  void goToPagesPage() {
    Get.to(PagesPage());
  }

  changeLanguage() async {
    var lang = await _prefManger.getIsArabic();
    await _prefManger.setIsArabic(!lang);
    isArabicLanguage = !lang;
    Get.updateLocale(Locale(isArabicLanguage ? 'ar' : 'en'));
    await _apiRequests.onInit();
    await _mainLogic.mainData.getPages(true);
    _mainLogic.getStoreSetting();
    _mainLogic.getCategories();
    Get.find<DeliveryOptionLogic>().getShippingMethods(true);
    if (Get.isRegistered<CategoryDetailsLogic>(tag: 'lite')) {
      var logic = Get.find<CategoryDetailsLogic>(tag: 'lite');
      logic.sortList = [
        'الأفتراضي'.tr,
        'الأحدث'.tr,
        'الأكثر شعبية'.tr,
        'الأقل سعر'.tr,
        'الأعلى سعر'.tr
      ];
      logic.selectedSort = logic.selectedSort?.tr;
    }
    update();
  }

  getAccountDetails() async {
    isLoading = true;
    update(['account']);
    try {
      var response = await _apiRequests.getAccountDetails();
      log(response.data.toString());
      userModel = UserModel.fromJson(response.data['payload']);
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
    isLoading = false;
    update(['account']);
    update();
  }

  logout() async {
    await _prefManger.setIsLogin(false);
    await _prefManger.setToken(null);
    await _prefManger.setSession(null);
    await _apiRequests.onInit();
    _mainLogic.bonatUrl = null;
    ErrorHandler.generateSession(false, renewSession: true);
    isLogin = false;

    userModel = null;
    update();
  }

  void goToWhatsApp() async {
    String whatsAppUrlFromRemote = remoteConfig.getString(WA_ACCOUNT_KEY);
    if (whatsAppUrlFromRemote.isEmpty) {
      await getRemoteConfigValues();
    }
    whatsAppUrlFromRemote = remoteConfig.getString(WA_ACCOUNT_KEY);
    String whatsAppUrl = "";
    log('whatsAppUrlFromRemote => ' + whatsAppUrlFromRemote);
    String phoneNumber = _mainLogic.settingModel?.footer?.socialMedia?.items?.phone ?? '';
    String description = "Hello, From App".tr;
    whatsAppUrl = 'https://wa.me/+$phoneNumber?text=${Uri.parse(description)}';
    whatsAppUrl = whatsAppUrl.replaceAll('++', '+');

    var whatsAppUrlString =
        (whatsAppUrlFromRemote.isEmpty ? whatsAppUrl : whatsAppUrlFromRemote);
    launchWhatsapp(whatsAppUrlString);
  }

  void setData() {
    nameController.text = userModel?.name ?? '';
    emailController.text = userModel?.email ?? '';
    phoneController.text =
        userModel?.mobile?.substring(3, userModel?.mobile?.length) ?? '';
    startNumber = userModel?.mobile?.substring(0, 3) ?? '';
  }

  Future<void> editAccountDetails() async {
    isEditLoading = true;
    update();
    try {
      var response = await _apiRequests.editAccountDetails(
          nameController.text, emailController.text);

      userModel = UserModel.fromJson(response.data['payload']);
      update();
      Get.back();
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
    isEditLoading = false;
    update();
  }

  Future<void> deleteAccount() async {
    Get.back();
    try {
      var response = await _apiRequests.deleteAccount();
      await logout();
      Get.back();
      showMessage('تم حذف الحساب بنجاح'.tr, 1);
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
  }

  goToTwitter() {
    launch(
        "https://www.twitter.com/${_mainLogic.settingModel?.footer?.socialMedia?.items?.twitter}");
  }

  goToLinkedin() {
    launch(
        "https://www.snapchat.com/add/${_mainLogic.settingModel?.footer?.socialMedia?.items?.snapchat}");
  }

  goToInstagram() {
    launch(
        "https://www.instagram.com/${_mainLogic.settingModel?.footer?.socialMedia?.items?.instagram}");
  }

  goToFacebook() {
    launch(
        "https://www.facebook.com/${_mainLogic.settingModel?.footer?.socialMedia?.items?.facebook}");
  }

  goToTiktok() {
    launch(
        "https://www.tiktok.com/@${_mainLogic.settingModel?.footer?.socialMedia?.items?.tiktok}");
  }

  goToPhone() {
    launch("tel:${_mainLogic.settingModel?.footer?.socialMedia?.items?.phone}");
  }

  goToWebSite(){
    launch(_mainLogic.settingModel?.footer?.socialMedia?.items?.website ?? "");

  }

  goToEmail() {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: _mainLogic.settingModel?.footer?.socialMedia?.items?.email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'رسالة من تطبيق ${isArabicLanguage ? appNameAr : appNameEn}'
      }),
    );

    log(_mainLogic.settingModel?.footer?.socialMedia?.items?.email ?? '');
    launch(emailLaunchUri.toString());
  }

  goToShippingMethod() async {
    Get.to(DeliveryOptionPage());
  }

  void goToAppBunchesSite() async {
    String urlString = appsBunchesUrl;
    if (await canLaunch(urlString)) launch(urlString);
  }

  void goToZid() async {
    var uriOld =
        Uri(scheme: 'https', host: 'grow.zid.sa', path: 'join-zid', queryParameters: {
      'utm_source': 'app',
      'utm_medium': 'AppsBunches',
      'utm_campaign': Platform.isAndroid ? 'android' : 'ios',
      'store_link':
          Get.find<MainLogic>().settingModel?.settings?.permalink ?? (storeUrl + '/'),
      'referralCode': 'sfwnlqrywty'
    });
    launchUrl(Uri.parse('https://web.zid.sa/register/sfwnlqrywty?ref=sfwnlqrywty'));
  }

  goToPrivacyPolicy() async {
    if (!await checkInternet()) return;
    Get.to(PageDetailsPage(
      type: 1,
      title: "سياسة الخصوصية والاستخدام".tr,
      pageModel: _mainLogic.pageModelPrivacy,
    ));
  }

  getRefundPolicy() async {
    if (!await checkInternet()) return;
    Get.to(PageDetailsPage(
      type: 2,
      title: "سياسة الإستبدال والاسترجاع".tr,
      pageModel: _mainLogic.pageModelRefund,
    ));
  }

  goToTermsAndConditions() async {
    if (!await checkInternet()) return;
    Get.to(PageDetailsPage(
      type: 3,
      title: "الشروط والأحكام".tr,
      pageModel: _mainLogic.pageModelTerms,
    ));
  }

  goToSuggestions() async {
    if (!await checkInternet()) return;
    Get.to(PageDetailsPage(
      type: 6,
      title: "الشكاوى والاقتراحات".tr,
      pageModel: _mainLogic.pageModelSuggestions,
    ));
  }

  goToLicense() async {
    if (!await checkInternet()) return;
    Get.to(PageDetailsPage(
      type: 7,
      title: "التراخيص".tr,
      pageModel: _mainLogic.pageModelLicense,
    ));
  }

  shareApp(context) {
    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      shareLink,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  goToCountries() {
    Get.to(SelectCountryPage());
  }

  goToFaq() async {
    if (!await checkInternet()) return;
    Get.to(const FaqPage());
  }

  goToAddress() {
    Get.defaultDialog(
        title: 'العنوان'.tr,
        content: Column(
          children: [
            if (_mainLogic.settingModel?.footer?.businessLocation?.street != null)
              CustomText(_mainLogic.settingModel?.footer?.businessLocation?.street ?? ''),
            Row(
              children: [
                const Icon(Icons.location_on),
                Expanded(
                  child: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12 + AppConfig.fontDecIncValue,
                              fontFamily: AppConfig.fontName),
                          children: [
                        if (_mainLogic
                                .settingModel?.footer?.businessLocation?.country?.name !=
                            null)
                          TextSpan(
                              text: _mainLogic.settingModel?.footer?.businessLocation
                                      ?.country?.name ??
                                  ''),
                        if (_mainLogic.settingModel?.footer?.businessLocation?.city
                                ?.customName !=
                            null)
                          const TextSpan(text: ', '),
                        if (_mainLogic.settingModel?.footer?.businessLocation?.city
                                ?.customName !=
                            null)
                          TextSpan(
                              text: _mainLogic.settingModel?.footer?.businessLocation
                                      ?.city?.customName ??
                                  ''),
                        if (_mainLogic.settingModel?.footer?.businessLocation?.district !=
                            null)
                          const TextSpan(text: ', '),
                        if (_mainLogic.settingModel?.footer?.businessLocation?.district !=
                            null)
                          TextSpan(
                              text: _mainLogic
                                      .settingModel?.footer?.businessLocation?.district ??
                                  ''),
                        if (_mainLogic.settingModel?.footer?.businessLocation?.street !=
                            null)
                          const TextSpan(text: ', '),
                        if (_mainLogic.settingModel?.footer?.businessLocation?.street !=
                            null)
                          TextSpan(
                              text: _mainLogic
                                      .settingModel?.footer?.businessLocation?.street ??
                                  ''),
                      ])),
                ),
              ],
            ),
          ],
        ));
  }
}
