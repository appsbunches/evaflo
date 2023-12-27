import 'package:entaj/src/utils/custom_widget/custom_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../.env.dart';
import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../entities/home_screen_model.dart';
import '../../../images.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';
import '../../../utils/item_widget/item_product.dart';

class AsayelProductsWidget extends StatefulWidget {
  final FeaturedProducts? featuredProducts;
  final bool fixedProducts;
  final String? title;
  final String? desc;
  final String? descColor;
  final String? titleColor;
  final String? moreText;
  final String? moreTextColor;
  final bool? titleCenter;
  final bool? hideDots;
  final bool? displayMore;
  final double? numberOfSm;
  final String? containerType;
  final String? bgSectionColor;
  final String? quantity;

  const AsayelProductsWidget({
    Key? key,
    required this.featuredProducts,
    this.title,
    this.fixedProducts = false,
    this.moreText,
    this.containerType,
    this.bgSectionColor,
    this.titleColor,
    this.desc,
    this.descColor,
    this.titleCenter = false,
    this.moreTextColor,
    this.hideDots,
    this.displayMore,
    this.numberOfSm,
    this.quantity,
  }) : super(key: key);

  @override
  State<AsayelProductsWidget> createState() => _AsayelProductsWidgetState();
}

class _AsayelProductsWidgetState extends State<AsayelProductsWidget> {
  final PageController controller = PageController();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        _currentIndex = controller.page?.ceil() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.featuredProducts?.display == false ||
            widget.featuredProducts?.items == null ||
            widget.featuredProducts?.items?.length == 0)
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: widget.bgSectionColor != null
                      ? HexColor.fromHex(widget.bgSectionColor ?? '#ffffff')
                      : Colors.transparent,
                  borderRadius: widget.containerType == "container"
                      ? BorderRadius.circular(10)
                      : null),
              margin: widget.containerType == "container"
                  ? const EdgeInsets.all(AppConfig.paddingBetweenWidget)
                  : EdgeInsets.zero,
              padding:
                  const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
              child: Column(
                children: [
                  if (!(widget.featuredProducts?.title == null &&
                      widget.title == null &&
                      widget.featuredProducts?.moreButton == null &&
                      widget.moreText == null))
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: widget.titleCenter == true
                                  ? CrossAxisAlignment.center
                                  : CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  widget.featuredProducts?.title ?? widget.title,
                                  fontSize: 14,
                                  color: widget.titleColor != null
                                      ? HexColor.fromHex(widget.titleColor ?? '#000000')
                                      : primaryColor,
                                  fontWeight: FontWeight.w900,
                                ),
                                CustomText(
                                  widget.desc ?? '',
                                  fontSize: 14,
                                  color: widget.descColor != null
                                      ? HexColor.fromHex(widget.descColor ?? '#000000')
                                      : primaryColor,
                                  fontWeight: FontWeight.w900,
                                ),
                              ],
                            ),
                          ),
                          if (widget.displayMore == true &&
                              widget.titleCenter != true &&
                              widget.moreText?.isNotEmpty == true &&
                              !AppConfig.showMoreTextInButton)
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  if (AppConfig.isSoreUseNewTheme) {
                                    if (widget.featuredProducts?.url != null) {
                                      goToLink(widget.featuredProducts?.url);
                                    } else if (widget.featuredProducts?.id != null &&
                                        widget.featuredProducts?.id != 'null') {
                                      Get.toNamed(
                                          '/category-details/${widget.featuredProducts?.id}');
                                    } else {
                                      Get.toNamed('/category-details/arguments',
                                          arguments: {
                                            'name': AppConfig.currentThemeId ==
                                                    royalThemeId
                                                ? 'جميع المنتجات'.tr
                                                : widget.featuredProducts?.title ?? '',
                                            'filter':
                                                AppConfig.currentThemeId == royalThemeId
                                                    ? 'popularity_order'
                                                    : widget.featuredProducts?.moduleType,
                                          });
                                    }
                                  } else {
                                    Get.toNamed('/category-details/arguments',
                                        arguments: {
                                          'name': widget.featuredProducts?.title ?? '',
                                          'filter':
                                              widget.featuredProducts?.moreButton?.url,
                                        });
                                  }
                                },
                                child: Container(
                                  padding: AppConfig.currentThemeId == asayelThemeId
                                      ? const EdgeInsets.all(5)
                                      : null,
                                  decoration: AppConfig.currentThemeId == asayelThemeId
                                      ? const ShapeDecoration(
                                          color: primaryColor, shape: StadiumBorder()
                                          // borderRadius: StadiumBorder(),
                                          )
                                      : null,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        widget.moreText ?? "عرض الكل".tr,
                                        textAlign: TextAlign.end,
                                        maxLines: 1,
                                        color: widget.moreTextColor != null
                                            ? HexColor.fromHex(widget.moreTextColor ??
                                                Colors.white.toHex())
                                            : Colors.white,
                                      ),
                                      if (AppConfig.currentThemeId != asayelThemeId) ...[
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        RotationTransition(
                                            turns: AlwaysStoppedAnimation(
                                                (isArabicLanguage ? 180 : 0) / 360),
                                            child: Image.asset(iconBack,
                                                color: widget.moreTextColor != null
                                                    ? HexColor.fromHex(
                                                        widget.moreTextColor ??
                                                            Colors.white.toHex())
                                                    : Colors.white,
                                                scale: 2)),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  widget.fixedProducts
                      ? GridView.builder(
                          itemCount: widget.featuredProducts?.items?.length ?? 0,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: AppConfig.productItemHomeAspectRatio),
                          itemBuilder: (context, index) => ItemProduct(
                                widget.featuredProducts!.items![index],
                                backCount: 1,
                                horizontal: false,
                                forWishlist: false,
                              ))
                      : Column(
                          children: [
                            AspectRatio(
                              aspectRatio: AppConfig.productsHomeAsayelAspectRatio,
                              child: ListView.builder(
                                  controller: controller,
                                  itemCount: widget.featuredProducts?.items?.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => ItemProduct(
                                      widget.featuredProducts!.items![index],
                                      width: AppConfig.productsHomeAsayelWidth,
                                      backCount: 1,
                                      horizontal: true)),
                            ),
                            if (widget.hideDots == false)
                              const SizedBox(
                                height: 10,
                              ),
                            if (widget.hideDots == false)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  (widget.featuredProducts!.items!.length /
                                          widget.numberOfSm!)
                                      .ceil(),
                                  (index) => GestureDetector(
                                    onTap: () {
                                      controller.animateToPage(index,
                                          duration: const Duration(milliseconds: 400),
                                          curve: Curves.easeInOut);
                                    },
                                    child: CustomIndicator(_currentIndex == index),
                                  ),
                                ),
                              ),
                          ],
                        ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (widget.displayMore == true &&
                      widget.titleCenter == true &&
                      widget.moreText?.isNotEmpty == true &&
                      !AppConfig.showMoreTextInButton)
                    GestureDetector(
                      onTap: () {
                        if (AppConfig.isSoreUseNewTheme) {
                          if (widget.featuredProducts?.url != null) {
                            goToLink(widget.featuredProducts?.url);
                          } else if (widget.featuredProducts?.id != null &&
                              widget.featuredProducts?.id != 'null') {
                            Get.toNamed(
                                '/category-details/${widget.featuredProducts?.id}');
                          } else {
                            Get.toNamed('/category-details/arguments', arguments: {
                              'name': AppConfig.currentThemeId == royalThemeId
                                  ? 'جميع المنتجات'.tr
                                  : widget.featuredProducts?.title ?? '',
                              'filter': AppConfig.currentThemeId == royalThemeId
                                  ? 'popularity_order'
                                  : widget.featuredProducts?.moduleType,
                            });
                          }
                        } else {
                          Get.toNamed('/category-details/arguments', arguments: {
                            'name': widget.featuredProducts?.title ?? '',
                            'filter': widget.featuredProducts?.moreButton?.url,
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const ShapeDecoration(
                            color: primaryColor, shape: StadiumBorder()),
                        child: CustomText(
                          widget.moreText ?? "عرض الكل".tr,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          color: widget.moreTextColor != null
                              ? HexColor.fromHex(widget.moreTextColor ?? '#000000')
                              : Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
  }
}
