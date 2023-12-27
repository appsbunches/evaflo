import 'package:entaj/src/modules/product_details/widgets/product_whats_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../main.dart';
import '../../.env.dart';
import '../../app_config.dart';
import '../../colors.dart';
import '../../entities/product_details_model.dart';
import '../../images.dart';
import '../../services/app_events.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import '../_main/logic.dart';
import '../_main/widgets/my_bottom_nav.dart';
import '../_main/widgets/trust_payment_widget.dart';
import 'logic.dart';
import 'widgets/item_option.dart';
import 'widgets/product_add_to_cart_widget.dart';
import 'widgets/product_custom_field.dart';
import 'widgets/product_description_widget.dart';
import 'widgets/product_image_widget.dart';
import 'widgets/product_offer_widget.dart';
import 'widgets/product_related_widget.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final AppEvents _appEvents = Get.find();

  late FocusNode phoneNumberFocusNode;
  late final ProductDetailsLogic logic;

  @override
  void initState() {
    var productId = Get.parameters['productId'] ?? 'unknown';
    logic = Get.put(ProductDetailsLogic(), tag: productId);
    phoneNumberFocusNode = FocusNode();
    phoneNumberFocusNode.addListener(() {
      // print(phoneNumberFocusNode.toString());
      logic.update(['Whats']);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var productId = Get.parameters['productId'] ?? 'unknown';
    int backCount = int.parse(Get.arguments['backCount'] ?? '1');
    logic.quantityController.text = '1';
    logic.getProductDetails(productId);
    logic.selectedImageIndex = 0;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:
          backCount == 0 ? null : MyBottomNavigation(backCount: backCount),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: AppConfig.showGBAllApp
          ? Container(
              margin: (AppConfig.showWhatsAppRemoteConfig)
                  ? EdgeInsetsDirectional.only(bottom: 80.h)
                  : null,
              child: const GlobalFloatingWhatsApp())
          : null,
      appBar: AppBar(
        title: AppConfig.showLogoInProductDetailsPage
            ? Image.asset(
                iconLogoAppBarCenter,
                height: AppConfig.logoSizeInApBarHeight,
                width: AppConfig.logoSizeInApBarWidth,
                color: headerLogoColor,
              )
            : SizedBox(),
        actions: [
          GetBuilder<ProductDetailsLogic>(
              init: Get.find<ProductDetailsLogic>(tag: productId),
              tag: productId,
              id: productId,
              builder: (logic) {
                return logic.productModel == null
                    ? const SizedBox()
                    : InkWell(
                        onTap: () => Share.share(logic.productModel?.htmlUrl ?? ''),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              //CustomText("مشاركة".tr),
                              //const SizedBox(width: 5,),
                              Icon(Icons.share)
                            ],
                          ),
                        ),
                      );
              })
        ],
      ),
      body: GetBuilder<ProductDetailsLogic>(
          tag: productId,
          init: Get.find<ProductDetailsLogic>(tag: productId),
          id: productId,
          builder: (logic) {
            return logic.isLoading
                ? const CustomProgressIndicator()
                : !logic.hasInternet
                    ? Container(
                        width: double.infinity,
                        height: 600.h,
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.wifi_off,
                              color: Colors.grey,
                              size: 60,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomText(
                              'يرجى التأكد من اتصالك بالإنترنت'.tr,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      )
                    : (logic.productModel == null && logic.isProductDeleted)
                        ? Center(child: CustomText("Product has been deleted".tr))
                        : logic.productModel == null
                            ? const SizedBox()
                            : Column(
                                children: [
                                  Expanded(
                                    child: RefreshIndicator(
                                      onRefresh: () async =>
                                          logic.getProductDetails(productId),
                                      child: SingleChildScrollView(
                                        child: GetBuilder<ProductDetailsLogic>(
                                            tag: productId,
                                            init: Get.find<ProductDetailsLogic>(
                                                tag: productId),
                                            id: productId,
                                            builder: (logic) {
                                              return buildProductDetailsColumn(
                                                  productId, logic, backCount);
                                            }),
                                      ),
                                    ),
                                  ),
                                  ProductAddToCartWidget(
                                      productId, phoneNumberFocusNode, _appEvents),
                                ],
                              );
          }),
    );
  }

  Column buildProductDetailsColumn(
      String productId, ProductDetailsLogic logic, int backCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImageWidget(productId: productId),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              CustomText(
                logic.productModel?.name,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              if (AppConfig.showShortDescription)
                const SizedBox(
                  height: 15,
                ),
              if (AppConfig.showShortDescription)
                HtmlWidget(logic.productModel?.shortDescription ?? ''),
              const SizedBox(
                height: 5,
              ),
              if (logic.productModel?.offerLabel != null)
                const SizedBox(
                  height: 5,
                ),
              if (logic.productModel?.offerLabel != null)
                Row(
                  children: [
                    const Icon(
                      Icons.wallet_giftcard,
                      color: moveColor,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: CustomText(
                        logic.productModel?.offerLabel,
                        color: Colors.black,
                        textAlign: TextAlign.start,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 8,
              ),
              if (AppConfig.showRatingsButton)
                if (logic.productModel?.rating?.average != 0.0)
                  Row(
                    children: [
                      RatingBarIndicator(
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: yalowColor,
                        ),
                        itemSize: 20,
                        rating: logic.productModel?.rating?.average ?? 0.0,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        '(${logic.productModel?.rating?.totalCount})',
                        color: Colors.grey.shade800,
                        fontSize: 11,
                      )
                    ],
                  ),
              if (logic.productModel?.soldProductsCount !=
                      null /* &&
                  AppConfig.showSoldProductsCount*/
                  )
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: CustomText(
                    isArabicLanguage
                        ? 'تم شراؤه أكثر من  (${logic.productModel?.soldProductsCount}) مرة'
                        : 'Sold more than ${logic.productModel?.soldProductsCount} times',
                    color: Colors.grey.shade800,
                    fontSize: 10,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    if (AppConfig.isLowStockLabelEnabled)
                      if (logic.productModel?.quantity != null)
                        if (logic.productModel?.quantity != 0)
                          if (logic.productModel!.quantity! <=
                              Get.find<MainLogic>()
                                  .settingModel
                                  ?.settings
                                  ?.lowStockQuantityLimit)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                              decoration: BoxDecoration(
                                  color: const Color(0xfff8fafc),
                                  border: Border.all(
                                      color: const Color(0xff334155), width: 0.5),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(5))),
                              child: CustomText(
                                "الكمية المتوفرة : ${logic.productModel?.quantity}".tr,
                                fontSize: 7,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    if (logic.productModel?.quantity != null)
                      if (logic.productModel?.quantity != 0)
                        if (logic.productModel?.quantity! <=
                            Get.find<MainLogic>()
                                .settingModel
                                ?.settings
                                ?.lowStockQuantityLimit)
                          const SizedBox(
                            width: 5,
                          ),
                    if (AppConfig.isTaxableLabelEnabled)
                      if (logic.productModel?.isTaxable == false)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                          decoration: BoxDecoration(
                              color: const Color(0xfff8fafc),
                              border:
                                  Border.all(color: const Color(0xff334155), width: 0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(5))),
                          child: CustomText(
                            "معفى من الضريبة".tr,
                            fontSize: 7,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                  ],
                ),
              ),
              if (logic.productModel?.sku != null && AppConfig.showSku)
                CustomText(
                  "رمز المنتج: ".tr + logic.productModel!.sku.toString(),
                  fontSize: 10,
                ),
              if (logic.productModel?.weight?.value != null &&
                  AppConfig.showWeightInProductPage)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      'الوزن'.tr,
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomText(
                      '${logic.productModel?.weight?.value} ${logic.productModel?.weight?.unit}',
                      fontSize: 10,
                    ),
                  ],
                ),
              ProductDescriptionWidget(productId: productId),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (logic.productModel?.options?.isNotEmpty == true)
                GridView.builder(
                  itemCount: logic.productModel?.options?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) => ItemOption(
                      productId,
                      logic.productModel?.options?[index].choices,
                      logic.productModel?.options?[index]),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1.7, crossAxisSpacing: 15),
                ),
            ],
          ),
        ),
        buildCustomUserInputField(productId, logic.productModel!),
        /*     if (AppConfig.isLowStockLabelEnabled)
          if (logic.productModel?.quantity != null)
            if (logic.productModel?.quantity != 0)
              if (logic.productModel!.quantity! <=
                  Get.find<MainLogic>()
                      .settingModel
                      ?.settings
                      ?.lowStockQuantityLimit)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 1)),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  alignment: Alignment.center,
                  child:
                      CustomText('متبقى ${logic.productModel?.quantity} فقط'),

                ),*/
        if (AppConfig.currentThemeId == asayelThemeId)
          if (AppConfig.showTrustPaymentFromRemoteConfig)
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: TrustPayment(),
            ),
        const ProductWhatsWidget(),
        if (AppConfig.showRatingsButton)
          Center(
            child: InkWell(
              onTap: () => logic.goToReviews(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      "عرض جميع التقييمات".tr,
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RotationTransition(
                        turns: AlwaysStoppedAnimation((isArabicLanguage ? 180 : 0) / 360),
                        child: Image.asset(
                          iconBack,
                          scale: 2,
                          color: secondaryColor,
                        )),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(
          height: 5,
        ),
        ProductOfferWidget(
          productId: productId,
          backCount: backCount,
        ),
        ProductRelatedWidget(
          productId: productId,
          backCount: backCount,
          relatedProducts: logic.productModel?.relatedProducts ?? [],
        ),
      ],
    );
  }

  Widget buildCustomUserInputField(productId, ProductDetailsModel productDetailsModel) {
    if (productDetailsModel.customFields?.isNotEmpty == true) {
      return ListView.builder(
          itemCount: productDetailsModel.customFields?.length ?? 0,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ProductCustomField(
                productId: productId,
                customField: productDetailsModel.customFields![index]);
          });
    } else {
      return const SizedBox();
    }
  }
}
