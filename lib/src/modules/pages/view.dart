import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../.env.dart';
import '../../app_config.dart';
import '../../entities/page_model.dart';
import '../../utils/custom_widget/custom_list_tile.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/functions.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import '../_main/logic.dart';
import '../delivery_option/view.dart';
import '../faq/view.dart';
import '../page_details/view.dart';
import 'logic.dart';

class PagesPage extends StatelessWidget {
  final PagesLogic logic = Get.find();
  final MainLogic _mainLogic = Get.find();

  PagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: AppConfig.showGBAllApp ? GlobalFloatingWhatsApp() : null,
      appBar: AppBar(
        title: CustomText(
          "الصفحات الإضافية".tr,
          fontSize: 16,
        ),
      ),
      body: GetBuilder<MainLogic>(
          id: "pages",
          builder: (logic) {
            return logic.isPagesLoading
                ? const CustomProgressIndicator()
                : AppConfig.isSoreUseNewTheme
                    ? RefreshIndicator(
                        onRefresh: () =>
                            logic.getHomeScreen(themeId: AppConfig.currentThemeId),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (logic.footerSettings?.links1Title != null &&
                                    logic.footerSettings?.links1Title != '' &&
                                    logic.footerSettings?.links1Hide != true)
                                  CustomText(
                                    logic.footerSettings?.links1Title,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 2,
                                    fontSize: 20,
                                  ),
                                if (logic.footerSettings?.links1Hide != true &&
                                    logic.footerSettings?.links1Links?.isNotEmpty == true)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        logic.footerSettings?.links1Links?.length ?? 0,
                                    itemBuilder: (context, index) => CustomListTile(
                                      logic.footerSettings?.links1Links?[index].title,
                                      () => onTap(
                                        logic.footerSettings?.links1Links?[index].url ??
                                            '',
                                        logic.footerSettings?.links1Links?[index].title,
                                        logic.footerSettings?.links1Links?[index],
                                      ),
                                      null,
                                    ),
                                  ),
                                if (logic.footerSettings?.links2Title != null &&
                                    logic.footerSettings?.links2Title != '' &&
                                    logic.footerSettings?.links2Hide != true)
                                  const SizedBox(
                                    height: 20,
                                  ),
                                if (logic.footerSettings?.links2Title != null &&
                                    logic.footerSettings?.links2Title != '' &&
                                    logic.footerSettings?.links2Hide != true)
                                  CustomText(
                                    logic.footerSettings?.links2Title,
                                    fontSize: 20,
                                    maxLines: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                if (logic.footerSettings?.links2Hide != true &&
                                    logic.footerSettings?.links2Links?.isNotEmpty == true)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        logic.footerSettings?.links2Links?.length ?? 0,
                                    itemBuilder: (context, index) => CustomListTile(
                                      logic.footerSettings?.links2Links?[index].title,
                                      () => onTap(
                                        logic.footerSettings?.links2Links?[index].url ??
                                            '',
                                        logic.footerSettings?.links2Links?[index].title,
                                        logic.footerSettings?.links2Links?[index],
                                      ),
                                      null,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Builder(builder: (context) {
                        List<PageModel> newList = [];
                        List<String?> newListTitle = [];
                        for (var element in logic.pagesList) {
                          if (!newListTitle.contains(element.title)) {
                            newList.add(element);
                            newListTitle.add(element.title);
                          }
                        }
                        logic.settingModel?.footer?.links?.itemsNotSystem
                            ?.forEach((element) {
                          if (!newListTitle.contains(element.title)) {
                            newList.add(element);
                            newListTitle.add(element.title);
                          }
                        });
                        return RefreshIndicator(
                          onRefresh: () => logic.mainData.getPages(true),
                          child: Column(
                            children: [
                              Expanded(
                                  child: ListView.builder(
                                      itemCount: newList.length,
                                      itemBuilder: (context, index) =>
                                          newList[index].title != null
                                              ? CustomListTile(
                                                  newList[index].title,
                                                  () => Get.to(PageDetailsPage(
                                                      pageModel: newList[index],
                                                      title: newList[index].title,
                                                      type: 4)),
                                                  null,
                                                )
                                              : const SizedBox()))
                            ],
                          ),
                        );
                      });
          }),
    );
  }

  onTap(String url, String? title, pageModel) {
    log("url=> $url");
    if (pageModel == null && url.isEmpty) {
      Get.find<MainLogic>().changeSelectedValue(0, true, backCount: 0);
      Get.back();
      return;
    }
    if (url.contains('privacy-policy') && !url.contains('blogs')) {
      Get.to(PageDetailsPage(
        type: 1,
        title: "سياسة الخصوصية والاستخدام".tr,
        pageModel: _mainLogic.pageModelPrivacy,
      ));
      return;
    }
    if (url.contains('refund-exchange-policy') && !url.contains('blogs')) {
      Get.to(PageDetailsPage(
        type: 2,
        title: "سياسة الإستبدال والاسترجاع".tr,
        pageModel: _mainLogic.pageModelRefund,
      ));
      return;
    }
    if (url.contains('terms-and-conditions') && !url.contains('blogs')) {
      Get.to(PageDetailsPage(
        type: 3,
        title: "الشروط والأحكام".tr,
        pageModel: _mainLogic.pageModelTerms,
      ));
      return;
    }
    if (url.contains('complaints-and-suggestions') && !url.contains('blogs')) {
      Get.to(PageDetailsPage(
        type: 6,
        title: "الشكاوى والاقتراحات".tr,
        pageModel: _mainLogic.pageModelSuggestions,
      ));
      return;
    }
    if (url.contains('/license') && !url.contains('blogs')) {
      Get.to(PageDetailsPage(
        type: 7,
        title: "التراخيص".tr,
        pageModel: _mainLogic.pageModelLicense,
      ));
      return;
    }
    if (url.contains('live-gold-price') == true) {
      launch((Get.find<MainLogic>().settingModel?.settings?.permalink ?? storeUrl) +
          url.substring(1));
      return;
    }
    if (url.contains('حاسبة-زكاة') == true) {
      launch(
          "${(Get.find<MainLogic>().settingModel?.settings?.permalink ?? (storeUrl + '/'))}blogs/%D8%AD%D8%A7%D8%B3%D8%A8%D8%A9-%D8%B2%D9%83%D8%A7%D8%A9");
      return;
    }
    if (url.contains('categories')) {
      try {
        var categoryId =
            url.substring(url.indexOf('categories') + 11, url.indexOf('categories') + 17);
        Get.toNamed("/category-details/$categoryId");
        return;
      } catch (e) {
        return;
      }
    } else if (url.contains('products')) {
      try {
        var productId = url.substring(url.indexOf('products') + 9, url.length);
        var url1 = Uri.encodeComponent(productId);
        Get.toNamed("/product-details/$url1", arguments: {'backCount': '3'});
        return;
      } catch (e) {
        return;
      }
    } else if (url.contains('shipping-and-payment')) {
      Get.to(DeliveryOptionPage());
    } else if (url.contains('https://') || url.contains('http://')) {
      goToLink(url);
    } else if (url.contains('/faqs')) {
      Get.to(const FaqPage());
    } else {
      Get.to(PageDetailsPage(
        type: 5,
        title: title,
        url: url,
        pageModel: pageModel,
      ));
    }
  }
}
