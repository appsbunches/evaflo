import 'dart:async';

import 'package:entaj/src/.env.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';

import '../../app_config.dart';
import '../../colors.dart';
import '../../data/hive/wishlist/hive_controller.dart';
import '../../data/hive/wishlist/wishlist_model.dart';
import '../../data/shared_preferences/pref_manger.dart';
import '../../entities/product_details_model.dart';
import '../../images.dart';
import '../../modules/_auth/login/view.dart';
import '../../modules/_main/logic.dart';
import '../../modules/cart/logic.dart';
import '../../modules/wishlist/logic.dart';
import '../../services/app_events.dart';
import '../custom_widget/custom_image.dart';
import '../custom_widget/custom_indicator.dart';
import '../custom_widget/custom_text.dart';
import '../functions.dart';

class ItemProduct extends StatefulWidget {
  final ProductDetailsModel? product;
  final int backCount;
  final bool forWishlist;
  final bool horizontal;
  final double width;

  const ItemProduct(this.product,
      {Key? key,
      this.forWishlist = false,
      this.width = 140,
      required this.backCount,
      required this.horizontal})
      : super(key: key);

  @override
  State<ItemProduct> createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  @override
  void initState() {
    super.initState();
    if (AppConfig.currentThemeId != asayelThemeId) startLoop();
  }

  int currentPage = 0;

  bool loopStarted = false;

  final PageController pageController = PageController(initialPage: 0);

  onPageChanged(page) {
    currentPage = page;
    setState(() {});
  }

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.product!.images!.length; i++) {
      list.add(i == currentPage
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 5,
              width: 5,
              decoration: BoxDecoration(
                color: true
                    ? greenLightColor
                    : AppConfig.currentThemeId == asayelThemeId
                        ? Colors.grey.shade400
                        : Colors.grey.shade300,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            )
          : AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 5,
              width: 5,
              decoration: BoxDecoration(
                color: false
                    ? greenLightColor
                    : AppConfig.currentThemeId == asayelThemeId
                        ? Colors.grey.shade400
                        : Colors.grey.shade300,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ));
    }
    return list;
  }

  void startLoop() async {
    if (loopStarted) return;
    loopStarted = true;
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (currentPage < widget.product!.images!.length) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      try {
        pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      } catch (e) {}
    });
  }

  final AppEvents _appEvents = Get.find();

  bool isLoading = false;
  bool clicked = false;

  final List<double> matrixList = [
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: widget.horizontal ? 10 : 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.sp),
        onTap: () => widget.product == null
            ? () {}
            : Get.toNamed("/product-details/${widget.product!.id!}",
                preventDuplicates: false,
                arguments: {'backCount': widget.backCount.toString()}),
        child: buildContainer(),
      ),
    );
  }

  buildContainer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: widget.horizontal ? widget.width.w : null,
        decoration: const BoxDecoration(color: Colors.white),
        child: widget.product == null
            ? const SizedBox(
                height: double.infinity,
              )
            : Column(
                children: [
                  AspectRatio(
                    aspectRatio: AppConfig.productItemAspectRatio,
                    child: Container(
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(10.sp)),
                        width: double.infinity,
                        child: Stack(
                          children: [
                            AppConfig.currentThemeId == asayelThemeId
                                ? Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: ColorFiltered(
                                      colorFilter: widget.product?.quantity == 0
                                          ? ColorFilter.matrix(matrixList)
                                          : const ColorFilter.mode(
                                              Colors.transparent,
                                              BlendMode.saturation,
                                            ),
                                      child: widget.product?.images?.length == 1 ||
                                              widget.product?.images?.length == 0
                                          ? AspectRatio(
                                              aspectRatio:
                                                  AppConfig.productItemAspectRatio,
                                              child: ClipRRect(
                                                borderRadius: const BorderRadius.only(
                                                    topRight: Radius.circular(10),
                                                    topLeft: Radius.circular(10)),
                                                child: widget.product?.images?.length == 0
                                                    ? const CustomImage(url: iconLogoFull)
                                                    : CustomImage(
                                                        url: widget.product?.images
                                                                    ?.length ==
                                                                0
                                                            ? null
                                                            : widget.product?.images?[0]
                                                                .image?.small,
                                                        fit:
                                                            AppConfig.productItemImageFit,
                                                      ),
                                              ),
                                            )
                                          : Stack(
                                              children: [
                                                ExpandablePageView.builder(
                                                  onPageChanged: onPageChanged,
                                                  itemCount:
                                                      widget.product?.images?.length ?? 0,
                                                  itemBuilder: (context, index) =>
                                                      ClipRRect(
                                                    borderRadius: const BorderRadius.only(
                                                        topRight: Radius.circular(10),
                                                        topLeft: Radius.circular(10)),
                                                    child: CustomImage(
                                                      url: widget.product
                                                                  ?.images?[index] ==
                                                              0
                                                          ? null
                                                          : widget.product?.images?[index]
                                                              .image?.small,
                                                      fit: AppConfig.productItemImageFit,
                                                    ),
                                                  ),
                                                  controller: pageController,
                                                  physics: const ClampingScrollPhysics(),
                                                ),
                                                PositionedDirectional(
                                                  start: 0,
                                                  end: 0,
                                                  bottom: 4,
                                                  child: Container(
                                                    alignment: Alignment.bottomCenter,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 5, vertical: 5),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: buildPageIndicator(),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                    ),
                                  )
                                : Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: ColorFiltered(
                                      colorFilter: widget.product?.quantity == 0
                                          ? ColorFilter.matrix(matrixList)
                                          : const ColorFilter.mode(
                                              Colors.transparent,
                                              BlendMode.saturation,
                                            ),
                                      child: AspectRatio(
                                        aspectRatio: AppConfig.productItemAspectRatio,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10)),
                                          child: CustomImage(
                                            url: widget.product?.images?.length == 0
                                                ? null
                                                : widget.product?.images?[0].image?.small,
                                            fit: AppConfig.productItemImageFit,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            if (widget.product!.offerLabel != null)
                              PositionedDirectional(
                                end: 0,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    widget.product?.quantity == 0
                                        ? Colors.white
                                        : Colors.transparent,
                                    BlendMode.saturation,
                                  ),
                                  child: Container(
                                    width: widget.product!.offerLabel!.length > 30
                                        ? 150.w
                                        : null,
                                    margin:
                                        const EdgeInsets.only(top: 10, left: 3, right: 3),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(15.sp)),
                                    child: CustomText(
                                      widget.product?.offerLabel,
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.white,
                                      textAlign: TextAlign.center,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            if (AppConfig.isEnableWishlist)
                              PositionedDirectional(
                                  start: 5,
                                  width: 35.sp,
                                  height: 35.sp,
                                  bottom: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(100.sp)),
                                  )),
                            if (AppConfig.isEnableWishlist)
                              PositionedDirectional(
                                  start: -30.sp,
                                  width: 105.sp,
                                  height: 105.sp,
                                  bottom: -30.sp,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (!await PrefManger().getIsLogin()) {
                                        Get.to(LoginPage());
                                        return;
                                      }
                                      final AppEvents _appEvents = Get.find();

                                      _appEvents.logAddToWishlist(widget.product?.name,
                                          widget.product?.id, widget.product?.price);
                                      var model = WishlistModel(
                                        productId: widget.product?.id,
                                        productName: widget.product?.name,
                                        productImage:
                                            widget.product?.images?.isNotEmpty == true
                                                ? (widget
                                                    .product?.images?[0].image?.small)
                                                : null,
                                        productQuantity: widget.product?.quantity ?? 1,
                                        productPrice: widget.product?.price ?? 0,
                                        productSalePrice: widget.product?.salePrice ?? 0,
                                        productFormattedPrice:
                                            widget.product?.formattedPrice,
                                        productFormattedSalePrice:
                                            widget.product?.formattedSalePrice,
                                        productHasFields:
                                            widget.product?.hasFields ?? false,
                                        productHasOptions:
                                            widget.product?.hasOptions ?? false,
                                      );
                                      if (HiveController.getWishlist()
                                              .get(widget.product?.id) ==
                                          null) {
                                        await HiveController.getWishlist()
                                            .put(widget.product?.id, model);
                                        clicked = true;
                                        //  setState(() {});
                                      } else {
                                        await HiveController.getWishlist()
                                            .delete(widget.product?.id);
                                        if (widget.forWishlist) {
                                          final WishlistLogic logic = Get.find();
                                          logic.removeItem(widget.product?.id);
                                        }
                                      }
                                    },
                                    child: ValueListenableBuilder<Box<WishlistModel>>(
                                        valueListenable:
                                            HiveController.getWishlist().listenable(),
                                        builder: (context, box, _) {
                                          return !clicked
                                              ? Icon(
                                                  Icons.favorite,
                                                  size: 20.sp,
                                                  color: HiveController.getWishlist()
                                                              .get(widget.product?.id) ==
                                                          null
                                                      ? Colors.grey.shade400
                                                      : moveColor,
                                                )
                                              : Lottie.asset(
                                                  'assets/images/lf30_editor_omnqgnhv.json',
                                                  onLoaded: (LottieComposition l) {
                                                  Future.delayed(Duration(
                                                          milliseconds:
                                                              l.duration.inMilliseconds -
                                                                  1500))
                                                      .then((value) {
                                                    clicked = false;
                                                    setState(() {});
                                                  });
                                                }, repeat: false, animate: true);
                                        }),
                                  )),
                          ],
                        )),
                  ),
                  Expanded(
                    flex: 5,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        widget.product?.quantity == 0 ? Colors.white : Colors.transparent,
                        BlendMode.saturation,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(
                                    widget.product?.name,
                                    maxLines: AppConfig.currentThemeId == asayelThemeId &&
                                            widget.product?.isTaxable == false
                                        ? 1
                                        : 2,
                                    fontSize: 9,
                                  ),
                                  if (AppConfig.currentThemeId == asayelThemeId)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Divider(
                                          thickness: 2,
                                          color: Colors.grey.shade200,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              if (AppConfig.isLowStockLabelEnabled)
                                                if (widget.product?.quantity != null)
                                                  if (widget.product?.quantity != 0)
                                                    if (widget.product!.quantity! <=
                                                        Get.find<MainLogic>()
                                                            .settingModel
                                                            ?.settings
                                                            ?.lowStockQuantityLimit)
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                                horizontal: 2,
                                                                vertical: 2),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                const Color(0xfff8fafc),
                                                            border: Border.all(
                                                                color: const Color(
                                                                    0xff334155),
                                                                width: 0.5),
                                                            borderRadius:
                                                                const BorderRadius.all(
                                                                    Radius.circular(5))),
                                                        child: CustomText(
                                                          "الكمية المتوفرة : ${widget.product?.quantity}"
                                                              .tr,
                                                          fontSize: 7,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                              if (widget.product?.quantity != null)
                                                if (widget.product?.quantity != 0)
                                                  if (widget.product!.quantity! <=
                                                      Get.find<MainLogic>()
                                                          .settingModel
                                                          ?.settings
                                                          ?.lowStockQuantityLimit)
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                              if (widget.product?.isTaxable == false)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 2, vertical: 2),
                                                  decoration: BoxDecoration(
                                                      color: const Color(0xfff8fafc),
                                                      border: Border.all(
                                                          color: const Color(0xff334155),
                                                          width: 0.5),
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(5))),
                                                  child: CustomText(
                                                    "معفى من الضريبة".tr,
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                            ),
                            if (widget.product?.formattedSalePrice != null)
                              CustomText(
                                widget.product?.formattedPrice,
                                color: formattedSalePriceTextColor,
                                lineThrough: true,
                                height: 1,
                                fontSize: 9,
                                //fontWeight: FontWeight.w800,
                              ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    widget.product?.formattedSalePrice ??
                                        widget.product?.formattedPrice,
                                    color: widget.product?.formattedSalePrice != null
                                        ? formattedPriceTextColorWithSale
                                        : formattedPriceTextColorWithoutSale,
                                    fontSize: 11,
                                    height: 1,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                if (AppConfig.showDiscountPercentage &&
                                    widget.product?.formattedSalePrice != null)
                                  Container(
                                    decoration: BoxDecoration(
                                        color: moveColor.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(3)),
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3, vertical: 1),
                                    child: CustomText(
                                      calculateDiscount(
                                          salePriceTotal: widget.product?.salePrice ?? 0,
                                          priceTotal: widget.product?.price ?? 0),
                                      color: moveColor,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                              ],
                            ),

                            //if (widget.product?.hasOptions == true || widget.product?.hasFields == true)
                            //  CustomText('متوفر بعدة خيارات'.tr),
                            // if (widget.product?.quantity == 0) CustomText('نفذت الكمية'.tr),
                            const Divider(),
                            GetBuilder<CartLogic>(
                                id: 'addToCart${widget.product!.id!}',
                                init: Get.find<CartLogic>(),
                                autoRemove: false,
                                builder: (cartLogic) {
                                  return InkWell(
                                    onTap: () async {
                                      if (widget.product?.hasOptions == true ||
                                          widget.product?.hasFields == true ||
                                          widget.product?.quantity == 0) {
                                        Get.toNamed(
                                            "/product-details/${widget.product!.id!}",
                                            arguments: {
                                              'backCount': widget.backCount.toString()
                                            });
                                        return;
                                      }
                                      int quantity = 1;

                                      var minQty = widget.product?.purchaseRestrictions
                                          ?.minQuantityPerCart;
                                      if (minQty != null) {
                                        if (quantity < minQty) {
                                          quantity = minQty;
                                        }
                                      }
                                      isLoading = true;
                                      setState(() {});
                                      await cartLogic.addToCart(widget.product?.id,
                                          quantity: quantity.toString(),
                                          hasOptions: widget.product?.hasOptions ?? false,
                                          hasFields: widget.product?.hasFields ?? false);

                                      isLoading = false;
                                      _appEvents.logAddToCart(widget.product?.name,
                                          widget.product?.id, widget.product?.price);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppConfig.showButtonWithBorder
                                                  ? primaryColor
                                                  : Colors.white,
                                              width: AppConfig.showButtonWithBorder
                                                  ? 1
                                                  : 0.001),
                                          color: AppConfig.showButtonWithBorder
                                              ? Colors.white
                                              : primaryColor,
                                          borderRadius: BorderRadius.circular(15.sp)),
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: isLoading
                                          ? const Center(
                                              child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                    textAddToCartColor),
                                              ),
                                            ))
                                          : Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Row(
                                                children: [
                                                  if (widget.product?.quantity != 0 &&
                                                      !(widget.product?.hasOptions ==
                                                              true ||
                                                          widget.product?.hasFields ==
                                                              true))
                                                    Padding(
                                                      padding: const EdgeInsetsDirectional
                                                          .only(start: 10),
                                                      child: Image.asset(
                                                        iconAddToCart,
                                                        scale: 2.5,
                                                        color: textAddToCartColor,
                                                      ),
                                                    ),
                                                  Expanded(
                                                    child: Center(
                                                      child: CustomText(
                                                        widget.product?.quantity != 0
                                                            ? (widget.product
                                                                            ?.hasOptions ==
                                                                        true ||
                                                                    widget.product
                                                                            ?.hasFields ==
                                                                        true)
                                                                ? 'اختر أحد الخيارات'.tr
                                                                : 'أضف للسلة'.tr
                                                            : 'نبهني عند التوفر'.tr,
                                                        color: textAddToCartColor,
                                                        textAlign: TextAlign.center,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  if (widget.product?.quantity != 0 &&
                                                      !(widget.product?.hasOptions ==
                                                              true ||
                                                          widget.product?.hasFields ==
                                                              true))
                                                    const SizedBox(
                                                      width: 15,
                                                    )
                                                ],
                                              ),
                                            ),
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
