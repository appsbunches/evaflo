import 'dart:io';

import 'package:entaj/src/utils/functions.dart';

import '../../../app_config.dart';
import '../../payment/view.dart';
import 'package:flutter/services.dart';

import '../../../.env.dart';
import '../../../data/remote/api_requests.dart';
import '../../../data/shared_preferences/pref_manger.dart';
import '../../../entities/category_model.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_sized_box.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../main.dart';
import '../../../colors.dart';
import '../../../images.dart';
import '../../../utils/error_handler/error_handler.dart';
import '../../_auth/login/view.dart';
import '../logic.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final MainLogic _mainLogic = Get.find();
  final PrefManger _prefManger = Get.find();

  @override
  void initState() {
    _mainLogic.checkInternetConnection();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white));
    super.initState();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: Platform.isAndroid ? false : true,
      child: Drawer(
        child: GetBuilder<MainLogic>(
            init: Get.find<MainLogic>(),
            builder: (logic) {
              return (!logic.hasInternet && logic.categoriesList.isEmpty)
                  ? Center(
                      child: CustomText('يرجى التأكد من اتصالك بالإنترنت'.tr),
                    )
                  : Padding(
                      padding: EdgeInsets.fromLTRB(0, 30.h, 0, 40.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: CustomText(
                              "القائمة".tr,
                              color: greenLightColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (AppConfig.showBonat) buildBonat(),
                          if (AppConfig.currentThemeId == asayelThemeId &&
                              logic.menuSettingsMarkat.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                              child: CustomText(
                                'أفضل الماركات'.tr,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                                height: 60,
                                child: ListView.builder(
                                    itemCount: logic.menuSettingsMarkat.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      var item = logic.menuSettingsMarkat[index];
                                      return GestureDetector(
                                        onTap: () {
                                          goToLink(item.url);
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(start: 10),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: CustomImage(
                                              url: item.marka,
                                              fit: BoxFit.cover,
                                              width: 60,
                                              height: 60,
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
                          ],
                          buildCategories(),
                          if (AppConfig.showScrollDownIcon)
                            GestureDetector(
                                onTap: () {
                                  scrollController.animateTo(
                                    scrollController.offset + 100,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                                },
                                child: const Center(child: Icon(Icons.arrow_downward))),
                          if (AppConfig.showDeliveryOptions &&
                              !logic.navigationOptions
                                  .contains('hide_menu_delivery_payment')) ...[
                            Divider(
                              color: Colors.grey.shade300,
                              thickness: 2,
                            ),
                            InkWell(
                              onTap: () => logic.goToDeliveryOptions(),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText("خيارات الشحن".tr,
                                            fontWeight: FontWeight.bold, fontSize: 14),
                                      ],
                                    ),
                                    const Spacer(),
                                    RotationTransition(
                                        turns: AlwaysStoppedAnimation(
                                            (isArabicLanguage ? 180 : 0) / 360),
                                        child: Image.asset(iconBack,
                                            color: deliveryOptionIconColor, scale: 2)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          Divider(
                            color: Colors.grey.shade300,
                            thickness: 2,
                          ),
                          const CustomSizedBox(
                            height: 10,
                          ),
                          if (AppConfig.showPaymentMethod &&
                              !logic.navigationOptions
                                  .contains('hide_menu_delivery_payment')) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: CustomText(
                                "طرق الدفع".tr,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 40.h,
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: ListView.builder(
                                    itemCount: logic.settingModel?.footer?.paymentMethods
                                            ?.length ??
                                        0,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => Container(
                                          height: 40.h,
                                          width: 40.h,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30)),
                                          padding:
                                              const EdgeInsets.symmetric(horizontal: 5),
                                          margin:
                                              const EdgeInsets.symmetric(horizontal: 5),
                                          child: CustomImage(
                                              url: logic.settingModel?.footer
                                                  ?.paymentMethods?[index].icon,
                                              fit: BoxFit.contain,
                                              size: 10),
                                        ))),
                            Divider(
                              color: Colors.grey.shade300,
                              thickness: 2,
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (logic.settingModel?.settings?.vatSettings
                                        ?.taxRegistrationCertificate !=
                                    null)
                                  InkWell(
                                    onTap: () => Get.to(Scaffold(
                                      backgroundColor: Colors.white,
                                      appBar: AppBar(),
                                      body: CustomImage(
                                        width: double.infinity,
                                        height: double.infinity,
                                        url: logic.settingModel?.settings?.vatSettings
                                            ?.taxRegistrationCertificate,
                                      ),
                                    )),
                                    child: Image.asset(
                                      imageTax,
                                      scale: 2,
                                    ),
                                  ),
                                if (logic.settingModel?.settings?.vatSettings
                                            ?.vatNumber !=
                                        null &&
                                    logic.settingModel?.settings?.vatSettings
                                            ?.isVatNumberVisible ==
                                        true)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: InkWell(
                                        onTap: () {
                                          if (logic.settingModel?.settings?.vatSettings
                                                  ?.taxRegistrationCertificate !=
                                              null) {
                                            Get.to(Scaffold(
                                              backgroundColor: Colors.white,
                                              appBar: AppBar(),
                                              body: CustomImage(
                                                width: double.infinity,
                                                height: double.infinity,
                                                url: logic
                                                    .settingModel
                                                    ?.settings
                                                    ?.vatSettings
                                                    ?.taxRegistrationCertificate,
                                              ),
                                            ));
                                          }
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              /*logic.settingModel?.settings?.vatSettings
                                                              ?.vatNumber !=
                                                          null &&
                                                      logic.settingModel?.settings?.vatSettings
                                                              ?.isVatNumberVisible ==
                                                          true
                                                  ?*/
                                              "الرقم الضريبي"
                                                  .tr /*
                                                  : 'رقم السجل التجاري'.tr*/
                                              ,
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                            CustomText(
                                              /* logic.settingModel?.settings?.vatSettings
                                                              ?.vatNumber !=
                                                          null &&
                                                      logic.settingModel?.settings?.vatSettings
                                                              ?.isVatNumberVisible ==
                                                          true
                                                  ? */
                                              logic.settingModel?.settings?.vatSettings
                                                  ?.vatNumber /*
                                                  : logic.settingModel?.settings
                                                      ?.commercialRegistrationNumber*/
                                              ,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                if (logic.settingModel?.footer?.socialMedia?.items
                                            ?.maroof !=
                                        null &&
                                    logic.settingModel?.footer?.socialMedia?.items
                                            ?.maroof !=
                                        '')
                                  InkWell(
                                    onTap: () => logic.goToMaroof(),
                                    child: Image.asset(
                                      iconMaroof,
                                      width: 60.w,
                                    ),
                                  ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
            }),
      ),
    );
  }

  Column buildBonat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Image.asset(
              iconBonat,
              scale: 1.5,
            ),
            Expanded(
              child: InkWell(
                  onTap: () async {
                    if (!await _prefManger.getIsLogin()) {
                      Get.to(LoginPage())?.then((value) {
                        if (value == 'success') {
                          Future.delayed(const Duration(seconds: 1), () async {
                            _mainLogic.bonatUrl = null;
                            _mainLogic.loadBonat();
                            _mainLogic.openBonat();
                          });
                        }
                      });
                      return;
                    }
                    _mainLogic.openBonat();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CustomText(
                      'نقاط الولاء'.tr,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  )),
            ),
          ],
        ),
        Divider(
          color: Colors.grey.shade300,
          thickness: 2,
        ),
      ],
    );
  }

  Expanded buildCategories() {
    return Expanded(
      child: GetBuilder<MainLogic>(
          init: Get.find<MainLogic>(),
          id: 'categoriesMenu',
          builder: (logic) {
            if (logic.isCategoriesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (AppConfig.currentThemeId == asayelThemeId) {
              return Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                trackVisibility: true,
                child: ListView.builder(
                  itemCount: logic.categoriesListAsayel.length,
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) =>
                      buildCategoryListTile(logic.categoriesListAsayel[index]),
                ),
              );
            }
            return logic.sideMenuList.isNotEmpty
                ? Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: ListView.builder(
                      itemCount: logic.sideMenuList.length,
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) =>
                          buildCategoryListTile(logic.sideMenuList[index]),
                    ),
                  )
                : const SizedBox();
          }),
    );
  }

  buildCategoryListTile(CategoryModel? category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (AppConfig.currentThemeId == alphaThemeId ||
            (AppConfig.currentThemeId == zeyadaThemeId &&
                (category?.name == 'Offers' || category?.name == 'افضل العروض')))
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 10, top: 15),
            child: CustomImage(
              url: AppConfig.currentThemeId == zeyadaThemeId ? iconHot : category?.image,
              fit: BoxFit.cover,
              width: 30,
              height: 30,
            ),
          ),
        Expanded(
          child: category?.subCategories.isEmpty == true
              ? InkWell(
                  onTap: () {
                    Get.back();
                    goToLink(category?.url);
                    // Get.toNamed("/category-details/${category?.id}");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CustomText(
                      category?.name == null || category?.name == ''
                          ? category?.sEOCategoryTitle
                          : category?.name,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ExpansionTile(
                  title: GestureDetector(
                    onTap: () {
                      if(category?.url == '*') return;
                      Get.back();
                      Get.toNamed("/category-details/${category?.id}");
                    },
                    child: CustomText(
                      category?.name == null || category?.name == ''
                          ? category?.sEOCategoryTitle
                          : category?.name,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing:
                      category?.subCategories.isEmpty == true ? const SizedBox() : null,
                  children: category?.subCategories
                          .map((e) => Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(child: buildCategoryListTile(e)),
                                ],
                              ))
                          .toList() ??
                      [],
                ),
        ),
      ],
    );
  }
}
