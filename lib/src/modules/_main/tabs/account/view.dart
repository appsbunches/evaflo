import '../../../../../main.dart';
import '../../../../app_config.dart';
import '../../../../colors.dart';
import '../../../../data/shared_preferences/pref_manger.dart';
import '../../../../images.dart';
import '../../../delivery_option/logic.dart';
import '../../logic.dart';
import '../../../../utils/custom_widget/custom_button_widget.dart';
import '../../../../utils/custom_widget/custom_list_tile.dart';
import '../../../../utils/custom_widget/custom_sized_box.dart';
import '../../../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../services/app_events.dart';
import 'logic.dart';
import 'dart:math' as math;

class AccountPage extends StatelessWidget {
  final AccountLogic logic = Get.find();
  final MainLogic _mainLogic = Get.find();
  final AppEvents _appEvents = Get.find();

  AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _appEvents.logScreenOpenEvent('Account');
    logic.checkLoginState();
    return GetBuilder<AccountLogic>(builder: (logic) {
      return RefreshIndicator(
        onRefresh: () async {
          await logic.checkLoginState();
          await _mainLogic.getStoreSetting();
          await _mainLogic.mainData.getFaqs();
          logic.update();
        },
        child: Column(
          children: [
            AppBar(
              backgroundColor: headerBackgroundColor,
              foregroundColor: headerForegroundColor,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: isArabicLanguage
                      ? Image.asset(iconMenu, scale: 2, color: headerForegroundColor)
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Image.asset(iconMenu,
                              scale: 2, color: headerForegroundColor),
                        ),
                  alignment: AlignmentDirectional.centerStart,
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: CustomText(
                "حسابي".tr,
                color: headerForegroundColor,
                fontSize: 16,
              ),
              actions: [
                if (logic.isLogin && logic.userModel != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 15),
                    child: Image.asset(
                      iconLogoAppBarEnd,
                      alignment: AlignmentDirectional.centerEnd,
                      height: AppConfig.logoSizeInApBarHeight,
                      width: AppConfig.logoSizeInApBarWidth,
                      color: headerLogoColor,
                    ),
                  ),
              ],
            ),
            GetBuilder<AccountLogic>(
                id: "account",
                builder: (logic) {
                  return logic.isLoading && logic.userModel == null
                      ? const Center(child: CircularProgressIndicator())
                      : Stack(
                          children: [
                            Positioned(
                                left: -70.w,
                                right: -70.w,
                                top: (logic.isLogin && logic.userModel != null)
                                    ? -150.h
                                    : -120.h,
                                child: RotationTransition(
                                  turns: const AlwaysStoppedAnimation(-1.9 / 360),
                                  child: Image.asset(
                                    imageArt,
                                    color: accountHeaderBackgroundColor,
                                    height: 300.h,
                                  ),
                                )),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                                child: (logic.isLogin && logic.userModel != null)
                                    ? Padding(
                                        padding: EdgeInsets.only(bottom: 30.h),
                                        child: Row(
                                          children: [
                                            CustomText(
                                              "أهلا بك ".tr +
                                                  logic.userModel!.name.toString(),
                                              color: logoutIconColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            const Spacer(),
                                            logic.isLogoutLoading
                                                ? const CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                  )
                                                : InkWell(
                                                    onTap: () => logic.logout(),
                                                    child: Row(
                                                      children: [
                                                        CustomText(
                                                          "خروج".tr,
                                                          color: logoutIconColor,
                                                          fontSize: 14,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Image.asset(
                                                          iconLogout,
                                                          color: logoutIconColor,
                                                          scale: 2,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Image.asset(
                                            iconLogoFull,
                                            color: accountIconLogoFullColor,
                                            height: AppConfig.logoSizeInAccount.h,
                                            fit: BoxFit.fitHeight,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(50.w, 10.h, 50.w, 0),
                                            child: CustomButtonWidget(
                                              title: "تسجيل / دخول مستخدم".tr,
                                              onClick: () => logic.goToLogin(),
                                              color: buttonBackgroundLoginColor,
                                              textColor: buttonTextLoginColor,
                                            ),
                                          )
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        );
                }),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        if (logic.isLogin && logic.userModel != null)
                          CustomListTile("تعديل الملف الشخصي".tr,
                              () => logic.goToEditAccount(), iconEdit),
                        FutureBuilder<bool>(
                            future: PrefManger().getIsLogin(),
                            builder: (context, snap) {
                              return snap.data != true
                                  ? const SizedBox()
                                  : CustomListTile(
                                      "طلباتي".tr,
                                      () {
                                        logic.goOrdersPage();
                                      },
                                      iconOrders,
                                    );
                            }),
                        /*  if (logic.isLogin && logic.userModel != null)
                          CustomListTile(
                            "عنواني".tr,
                            () {},
                            iconLocation,
                          ),*/
                        if (AppConfig.isEnglishLanguageEnable)
                          InkWell(
                            onTap: () => logic.changeLanguage(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    iconLanguage,
                                    scale: 2,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                    "لغة التطبيق".tr,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const Spacer(),
                                  CustomText(
                                    isArabicLanguage ? 'English' : 'العربية',
                                    fontWeight: FontWeight.bold,
                                    color: greenLightColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ),
                        Divider(
                          thickness: 3,
                          color: Colors.grey.shade200,
                        ),
                      ],
                    ),
                    if ((_mainLogic.settingModel?.footer?.aboutUs?.enabled == true &&
                            _mainLogic.settingModel?.footer?.aboutUs?.text?.isNotEmpty ==
                                true &&
                            !AppConfig.isSoreUseNewTheme) ||
                        _mainLogic.footerSettings?.about_us_des?.isNotEmpty == true &&
                            AppConfig.isSoreUseNewTheme)
                      CustomListTile(
                        "من نحن".tr,
                        () => logic.goToAboutUsPage(),
                        iconAbout,
                      ),
                    if (_mainLogic.pageModelPrivacy?.contentWithoutTags?.isNotEmpty ==
                        true)
                      GetBuilder<AccountLogic>(
                          id: "privacy",
                          builder: (logic) {
                            return logic.isPrivacyLoading
                                ? const Center(child: CircularProgressIndicator())
                                : CustomListTile("سياسة الخصوصية والاستخدام".tr,
                                    () => logic.goToPrivacyPolicy(), iconPolices);
                          }),
                    if (_mainLogic.pageModelTerms?.contentWithoutTags?.isNotEmpty == true)
                      CustomListTile(
                        "الشروط والأحكام".tr,
                        () => logic.goToTermsAndConditions(),
                        iconPaper,
                      ),
                    if (_mainLogic.pageModelLicense?.contentWithoutTags?.isNotEmpty ==
                        true)
                      CustomListTile(
                        "التراخيص".tr,
                        () => logic.goToLicense(),
                        iconPaper,
                      ),
                    if (_mainLogic.pageModelRefund?.contentWithoutTags?.isNotEmpty ==
                        true)
                      GetBuilder<AccountLogic>(
                          id: "refund",
                          builder: (logic) {
                            return logic.isRefundLoading
                                ? const Center(child: CircularProgressIndicator())
                                : CustomListTile(
                                    "سياسة الإستبدال والاسترجاع".tr,
                                    () => logic.getRefundPolicy(),
                                    iconRefund,
                                  );
                          }),
                    if (_mainLogic.pageModelSuggestions?.contentWithoutTags?.isNotEmpty ==
                        true)
                      CustomListTile(
                        "الشكاوى والاقتراحات".tr,
                        () => logic.goToSuggestions(),
                        iconPaper,
                      ),
                    if (_mainLogic.faqList.isNotEmpty)
                      CustomListTile(
                        'الأسئلة الشائعة'.tr,
                        () => logic.goToFaq(),
                        iconPaper,
                      ),
                    if (AppConfig.showDeliveryOptions)
                      GetBuilder<DeliveryOptionLogic>(
                          init: Get.find<DeliveryOptionLogic>(),
                          builder: (deliveryOptionLogic) {
                            return deliveryOptionLogic.listShippingMethods.isEmpty
                                ? const SizedBox()
                                : CustomListTile(
                                    "خيارات الشحن".tr,
                                    () => logic.goToShippingMethod(),
                                    iconDeliveryMethod,
                                  );
                          }),
                    Builder(builder: (context) {
                      return CustomListTile(
                        "شارك التطبيق".tr,
                        () => logic.shareApp(context),
                        iconShare,
                      );
                    }),
                    GetBuilder<MainLogic>(
                        id: 'pages',
                        init: Get.find<MainLogic>(),
                        builder: (mainLogic) {
                          return AppConfig.isSoreUseNewTheme
                              ? ((mainLogic.footerSettings?.links1Links?.isNotEmpty ??
                                              false) ==
                                          false &&
                                      (mainLogic.footerSettings?.links2Links
                                                  ?.isNotEmpty ??
                                              false) ==
                                          false)
                                  ? const SizedBox()
                                  : CustomListTile(
                                      'الصفحات الإضافية'.tr,
                                      () => logic.goToPagesPage(),
                                      iconPaper,
                                    )
                              : mainLogic.pagesList.isEmpty &&
                                      (mainLogic.settingModel?.footer?.links
                                              ?.itemsNotSystem?.isNotEmpty ==
                                          false)
                                  ? const SizedBox()
                                  : CustomListTile(
                                      'الصفحات الإضافية'.tr,
                                      () => logic.goToPagesPage(),
                                      iconPaper,
                                    );
                        }),
                    if (_mainLogic.settingModel?.footer?.businessLocation != null &&
                        AppConfig.showStoreAddress)
                      CustomListTile(
                        "العنوان".tr,
                        () => logic.goToAddress(),
                        'map',
                      ),
                    if (AppConfig.showShippingTo)
                      Divider(
                        thickness: 3,
                        color: Colors.grey.shade200,
                      ),
                    if (AppConfig.showShippingTo)
                      CustomListTile(
                        "الشحن إلى".tr,
                        () => logic.goToCountries(),
                        iconDeliveryMethod,
                      ),
                    Divider(
                      thickness: 3,
                      color: Colors.grey.shade200,
                    ),
                    (_mainLogic.settingModel?.footer?.socialMedia?.items?.twitter ==
                                null &&
                            _mainLogic
                                    .settingModel?.footer?.socialMedia?.items?.facebook ==
                                null &&
                            _mainLogic.settingModel?.footer?.socialMedia?.items
                                    ?.instagram ==
                                null &&
                            _mainLogic
                                    .settingModel?.footer?.socialMedia?.items?.snapchat ==
                                null)
                        ? const SizedBox()
                        : Container(
                            margin: const EdgeInsets.all(15),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.sp),
                                color: Colors.grey.shade100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (AppConfig.showOurNetwork)
                                  CustomText(
                                    "شبكاتنا".tr,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                if (AppConfig.showOurNetwork) const Spacer(),

                                if (_mainLogic.settingModel?.footer?.socialMedia
                                    ?.items?.website !=
                                    null)
                                  InkWell(
                                    onTap: () => logic.goToWebSite(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Image.asset(
                                        iconWebSite,
                                        color: socialMediaIconColor,
                                        scale: 2,
                                        height: 22,
                                      ),
                                    ),
                                  ),

                                if (_mainLogic.settingModel?.footer?.socialMedia?.items
                                        ?.tiktok !=
                                    null)
                                  InkWell(
                                    onTap: () => logic.goToTiktok(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Image.asset(
                                        iconTiktok,
                                        color: socialMediaIconColor,
                                        scale: 2,
                                        height: 22,
                                      ),
                                    ),
                                  ),
                                if (_mainLogic.settingModel?.footer?.socialMedia?.items
                                        ?.twitter !=
                                    null)
                                  InkWell(
                                    onTap: () => logic.goToTwitter(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Image.asset(
                                        iconTwitter,
                                        color: socialMediaIconColor,
                                        height: 22,
                                        scale: 2,
                                      ),
                                    ),
                                  ),
                                if (_mainLogic.settingModel?.footer?.socialMedia?.items
                                        ?.snapchat !=
                                    null)
                                  InkWell(
                                    onTap: () => logic.goToLinkedin(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Image.asset(
                                        iconSnapchat,
                                        height: 22,
                                        color: socialMediaIconColor,
                                        scale: 2,
                                      ),
                                    ),
                                  ),
                                if (_mainLogic.settingModel?.footer?.socialMedia?.items
                                        ?.instagram !=
                                    null)
                                  InkWell(
                                    onTap: () => logic.goToInstagram(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Image.asset(
                                        iconInstagram,
                                        color: socialMediaIconColor,
                                        height: 22,
                                        scale: 2,
                                      ),
                                    ),
                                  ),
                                if (_mainLogic.settingModel?.footer?.socialMedia?.items
                                        ?.facebook !=
                                    null)
                                  InkWell(
                                    onTap: () => logic.goToFacebook(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Image.asset(
                                        iconFacebook,
                                        color: socialMediaIconColor,
                                        height: 22,
                                        scale: 2,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                    if (AppConfig.showCall ||
                        AppConfig.showEmail ||
                        AppConfig.showWhatsApp)
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              "تواصل معنا".tr,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            const CustomSizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (AppConfig.showCall)
                                  Expanded(
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25.sp),
                                      onTap: () => logic.goToPhone(),
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25.sp),
                                            color: greenLightColor),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const CustomSizedBox(
                                              width: 5,
                                            ),
                                            Image.asset(
                                              iconCall,
                                              height: 20,
                                              color: buttonTextCallColor,
                                            ),
                                            const CustomSizedBox(
                                              width: 5,
                                            ),
                                            CustomText(
                                              "اتصال".tr,
                                              fontSize: 11,
                                              color: buttonTextCallColor,
                                            ),
                                            const CustomSizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                const CustomSizedBox(
                                  width: 5,
                                ),
                                if (AppConfig.showWhatsApp)
                                  Expanded(
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25.sp),
                                      onTap: () => logic.goToWhatsApp(),
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25.sp),
                                            color: greenLightColor),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const CustomSizedBox(
                                              width: 5,
                                            ),
                                            Image.asset(
                                              iconWhatsapp,
                                              height: 20,
                                              color: buttonTextCallColor,
                                            ),
                                            const CustomSizedBox(
                                              width: 5,
                                            ),
                                            CustomText(
                                              "واتس اب".tr,
                                              fontSize: 11,
                                              color: buttonTextCallColor,
                                            ),
                                            const CustomSizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                const CustomSizedBox(
                                  width: 5,
                                ),
                                if (AppConfig.showEmail)
                                  Expanded(
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25.sp),
                                      onTap: () => logic.goToEmail(),
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25.sp),
                                            color: greenLightColor),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const CustomSizedBox(
                                              width: 5,
                                            ),
                                            Image.asset(
                                              iconMail,
                                              height: 20,
                                              color: buttonTextCallColor,
                                            ),
                                            const CustomSizedBox(
                                              width: 5,
                                            ),
                                            CustomText(
                                              "ايميل".tr,
                                              fontSize: 11,
                                              color: buttonTextCallColor,
                                            ),
                                            const CustomSizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                            const CustomSizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    if (AppConfig.showAppsBunchesLogo)
                      Divider(
                        thickness: 3,
                        color: Colors.grey.shade200,
                      ),
                    if (AppConfig.showAppsBunchesLogo)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                "تطوير".tr,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                height: 1.2,
                                textAlign: TextAlign.center,
                                color: Colors.grey.shade800,
                              ),
                              const CustomSizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () => logic.goToAppBunchesSite(),
                                child: Image.asset(
                                  imageAppsBunches,
                                  height: 40,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              CustomText(
                                "بالشراكة مع".tr,
                                fontSize: 12,
                                height: 1.2,
                                fontWeight: FontWeight.normal,
                                textAlign: TextAlign.center,
                                color: Colors.grey.shade800,
                              ),
                              const CustomSizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () => logic.goToZid(),
                                child: Image.asset(
                                  isArabicLanguage ? iconZidAr : iconZidEn,
                                  height: 42,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    Center(
                        child: CustomText(
                      'version $versionNumber',
                      fontSize: 10,
                    )),
                    const CustomSizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
