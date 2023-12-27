import '../../widgets/products_wigget.dart';
import '../../widgets/testimonials_widget.dart';
import '../../../category_details/view.dart';

import '../../../../custom_home_widget.dart';
import '../../../../app_config.dart';
import '../../../../colors.dart';
import '../../../../images.dart';
import '../../../../utils/custom_widget/custom_button_widget.dart';
import '../../../../utils/custom_widget/custom_image.dart';
import '../../../../utils/functions.dart';
import '../../widgets/annoucement_bar_widget.dart';
import '../../widgets/availability_bar_widget.dart';
import '../../widgets/brand_widget.dart';
import '../../widgets/categories_grid_widget.dart';
import '../../widgets/categories_widget.dart';
import '../../widgets/slider_widget.dart';
import '../../logic.dart';
import '../../../no_Internet_connection_screen.dart';
import '../../../../services/app_events.dart';
import '../../../../utils/custom_widget/custom_text.dart';
import '../../../../utils/item_widget/item_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'logic.dart';

class HomePage extends StatelessWidget {
  final AppEvents _appEvents = Get.find();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _appEvents.logScreenOpenEvent('HomeTab');
    return AppConfig.liteVersion
        ? const CategoryDetailsPage(
            hideHeaderFooter: true,
          )
        : GetBuilder<MainLogic>(
            init: Get.find<MainLogic>(),
            builder: (logic) {
              return RefreshIndicator(
                onRefresh: () => logic.refreshData(),
                child: SizedBox(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: !logic.hasInternet
                        ? const NoInternetConnectionScreen()
                        : AppConfig.useAppBuilder
                            ? GetBuilder<HomeLogic>(
                                init: Get.find<HomeLogic>(),
                                builder: (logic) {
                                  return Column(
                                    children: logic.getAppBuilderItems(),
                                  );
                                })
                            : (AppConfig.isSoreUseNewTheme)
                                ? GetBuilder<HomeLogic>(
                                    init: Get.find<HomeLogic>(),
                                    builder: (logic) {
                                      return Column(
                                        children: logic.getDisplayOrderModule(),
                                      );
                                    })
                                : Column(
                                    children: [
                                      const CustomHomeWidget(),
                                      const AvailabilityBarWidget(),
                                      const AnnouncementBarWidget(),
                                      CategoriesWidget(),
                                      if (logic.homeScreenModel?.products == null &&
                                          logic.slider != null)
                                        if (logic.homeScreenModel?.slider?.display ==
                                            true)
                                          SliderWidget(
                                            sliderItems:
                                                logic.homeScreenModel?.slider?.items ??
                                                    [],
                                            hideDots: false,
                                            textColor: '#000000',
                                            backgroundColor: '#ffffff',
                                          ),
                                      if (logic.homeScreenModel?.products != null)
                                        GridView.builder(
                                          itemCount:
                                              logic.homeScreenModel?.products?.length ??
                                                  0,
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.only(
                                              bottom: 20, left: 8, right: 8),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 8,
                                                  mainAxisSpacing: 8,
                                                  childAspectRatio: AppConfig.productItemHomeAspectRatio),
                                          itemBuilder: (context, index) => ItemProduct(
                                            logic.homeScreenModel?.products?[index],
                                            backCount: 1,
                                            horizontal: false,
                                            forWishlist: false,
                                          ),
                                        ),
                                      if (logic
                                              .homeScreenModel?.promotionImage?.display ==
                                          true)
                                        buildPromotion(),
                                      if (logic.homeScreenModel?.products == null)
                                        buildDescription(),
                                      if (logic.homeScreenModel?.products == null)
                                        if (logic.homeScreenModel?.featuredCategories
                                                ?.display ==
                                            true)
                                          CategoriesGridWidget(
                                            title: logic.homeScreenModel
                                                ?.featuredCategories?.title,
                                            moreText: null,
                                            showAsColumn: false,
                                            categories: logic.homeScreenModel
                                                    ?.featuredCategories?.items ??
                                                [],
                                          ),
                                      if (logic.homeScreenModel?.products == null)
                                        GetBuilder<MainLogic>(builder: (logic) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ProductsWidget(
                                                  featuredProducts: logic.homeScreenModel
                                                      ?.featuredProductsPromoted),
                                              ProductsWidget(
                                                  featuredProducts: logic
                                                      .homeScreenModel?.onSaleProducts),
                                              ProductsWidget(
                                                  featuredProducts: logic
                                                      .homeScreenModel?.featuredProducts),
                                              ProductsWidget(
                                                  featuredProducts: logic.homeScreenModel
                                                      ?.featuredProducts2),
                                              ProductsWidget(
                                                  featuredProducts: logic.homeScreenModel
                                                      ?.featuredProducts3),
                                              ProductsWidget(
                                                  featuredProducts: logic.homeScreenModel
                                                      ?.featuredProducts4),
                                              ProductsWidget(
                                                  featuredProducts: logic
                                                      .homeScreenModel?.recentProducts),
                                            ],
                                          );
                                        }),
                                      if (logic.homeScreenModel?.products == null)
                                        BrandWidget(
                                            brands: logic.homeScreenModel?.brands),
                                      if (logic.homeScreenModel?.products == null)
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      if (logic.homeScreenModel?.products == null)
                                        TestimonialWidget(
                                            title: logic.testimonials?.title ?? '',
                                            display: logic.testimonials?.display ?? false,
                                            items: logic.testimonials?.items ?? []),
                                      if (logic.homeScreenModel?.products == null)
                                        const SizedBox(
                                          height: 15,
                                        ),
                                    ],
                                  ),
                  ),
                ),
              );
            });
  }

  GetBuilder<MainLogic> buildPromotion() {
    return GetBuilder<MainLogic>(builder: (logic) {
      return logic.isHomeLoading
          ? Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20.sp)),
                width: double.infinity,
                child: SizedBox(
                  height: 100.h,
                ),
              ))
          : (logic.homeScreenModel?.promotionImage?.image == null &&
                  logic.homeScreenModel?.promotionImage?.text == null &&
                  logic.homeScreenModel?.promotionImage?.title == null)
              ? const SizedBox()
              : SizedBox(
                  height: 250.h,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (logic.homeScreenModel?.promotionImage?.image != null)
                          CustomImage(
                            url: logic.homeScreenModel?.promotionImage?.image,
                            height: 250.h,
                            showErrorImage: true,
                            fit: BoxFit.fitHeight,
                          ),
                        Container(
                          color: /*logic.homeScreenModel?.promotionImage?.display == true
                    ? HexColor.fromHex(
                    logic.homeScreenModel?.promotionImage?.style
                        ?.backgroundColor ?? backgroundDescriptionColor): */
                              null,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (logic.homeScreenModel?.promotionImage?.title != null)
                                CustomText(
                                  logic.homeScreenModel?.promotionImage?.title,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  textAlign: TextAlign.center,
                                  fontSize: 15,
                                ),
                              if (logic.homeScreenModel?.promotionImage?.title != null)
                                const SizedBox(
                                  height: 10,
                                ),
                              if (logic.homeScreenModel?.promotionImage?.text != null)
                                CustomText(
                                  logic.homeScreenModel?.promotionImage?.text,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              if (logic.homeScreenModel?.promotionImage?.text != null)
                                const SizedBox(
                                  height: 10,
                                ),
                              if (logic.homeScreenModel?.promotionImage?.buttonText !=
                                  null)
                                ElevatedButton(
                                  child: CustomText(
                                      logic.homeScreenModel?.promotionImage?.buttonText ??
                                          ''),
                                  onPressed: () => goToLink(
                                      logic.homeScreenModel?.promotionImage?.link),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
    });
  }

  GetBuilder<MainLogic> buildDescription() {
    return GetBuilder<MainLogic>(builder: (logic) {
      return logic.isHomeLoading
          ? Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20.sp)),
                width: double.infinity,
                child: SizedBox(
                  height: 100.h,
                ),
              ))
          : logic.homeScreenModel?.storeDescription == null ||
                  logic.homeScreenModel?.storeDescription?.display == false ||
                  (logic.homeScreenModel?.storeDescription?.title == null &&
                      logic.homeScreenModel?.storeDescription?.text == null &&
                      logic.homeScreenModel?.storeDescription?.image == null &&
                      logic.homeScreenModel?.storeDescription?.socialMediaIcons == null)
              ? const SizedBox()
              : Stack(
                  children: [
                    if (logic.homeScreenModel?.storeDescription?.image != null)
                      CustomImage(
                      url: logic.homeScreenModel?.storeDescription?.image,
                      showErrorImage: true,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                      decoration: logic.homeScreenModel?.storeDescription?.image != null
                          ? null
                          : BoxDecoration(
                              color: HexColor.fromHex(logic.homeScreenModel
                                      ?.storeDescription?.style?.backgroundColor ??
                                  backgroundDescriptionColor),
                              borderRadius: BorderRadius.circular(20.sp)),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (logic.homeScreenModel?.storeDescription?.title != null)
                            CustomText(
                              logic.homeScreenModel?.storeDescription?.title,
                              fontWeight: FontWeight.bold,
                              color: HexColor.fromHex(logic.homeScreenModel
                                      ?.storeDescription?.style?.foregroundColor ??
                                  foregroundDescriptionColor),
                              textAlign: TextAlign.center,
                            ),
                          if (logic.homeScreenModel?.storeDescription?.text != null)
                            CustomText(
                              logic.homeScreenModel?.storeDescription?.text,
                              textAlign: TextAlign.center,
                              color: HexColor.fromHex(logic.homeScreenModel
                                      ?.storeDescription?.style?.foregroundColor ??
                                  foregroundDescriptionColor),
                              fontSize: 10,
                            ),
                          if (logic.homeScreenModel?.storeDescription
                                  ?.showSocialMediaIcons ==
                              true)
                            const SizedBox(
                              height: 5,
                            ),
                          if (logic.homeScreenModel?.storeDescription
                                  ?.showSocialMediaIcons ==
                              true)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (logic.homeScreenModel?.storeDescription
                                        ?.socialMediaIcons?.tiktok !=
                                    null)
                                  InkWell(
                                    onTap: () => logic.goToTiktok(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        iconTiktok,
                                        color: HexColor.fromHex(logic
                                                .homeScreenModel
                                                ?.storeDescription
                                                ?.style
                                                ?.foregroundColor ??
                                            foregroundDescriptionColor),
                                        scale: 2,
                                        height: 22,
                                      ),
                                    ),
                                  ),
                                if (logic.homeScreenModel?.storeDescription
                                        ?.socialMediaIcons?.twitter !=
                                    null)
                                  InkWell(
                                    onTap: () => logic.goToTwitter(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        iconTwitter,
                                        color: HexColor.fromHex(logic
                                                .homeScreenModel
                                                ?.storeDescription
                                                ?.style
                                                ?.foregroundColor ??
                                            foregroundDescriptionColor),
                                        scale: 2,
                                        height: 22,
                                      ),
                                    ),
                                  ),
                                if (logic.homeScreenModel?.storeDescription
                                        ?.socialMediaIcons?.snapchat !=
                                    null)
                                  InkWell(
                                    onTap: () => logic.goToSnapchat(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        iconSnapchat,
                                        color: HexColor.fromHex(logic
                                                .homeScreenModel
                                                ?.storeDescription
                                                ?.style
                                                ?.foregroundColor ??
                                            foregroundDescriptionColor),
                                        height: 22,
                                        scale: 2,
                                      ),
                                    ),
                                  ),
                                if (logic.homeScreenModel?.storeDescription
                                        ?.socialMediaIcons?.instagram !=
                                    null)
                                  InkWell(
                                    onTap: () => logic.goToInstagram(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        iconInstagram,
                                        color: HexColor.fromHex(logic
                                                .homeScreenModel
                                                ?.storeDescription
                                                ?.style
                                                ?.foregroundColor ??
                                            foregroundDescriptionColor),
                                        height: 22,
                                        scale: 2,
                                      ),
                                    ),
                                  ),
                                if (logic.homeScreenModel?.storeDescription
                                        ?.socialMediaIcons?.facebook !=
                                    null)
                                  InkWell(
                                    onTap: () => logic.goToFacebook(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        iconFacebook,
                                        color: HexColor.fromHex(logic
                                                .homeScreenModel
                                                ?.storeDescription
                                                ?.style
                                                ?.foregroundColor ??
                                            foregroundDescriptionColor),
                                        height: 22,
                                        scale: 2,
                                      ),
                                    ),
                                  ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ],
                );
    });
  }
}
