import 'package:entaj/src/modules/_main/widgets/asayel_products_wigget.dart';
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

class ProductsWidget extends StatefulWidget {
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

  const ProductsWidget({
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
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  final PageController controller = PageController();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        _currentIndex = controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (AppConfig.currentThemeId == asayelThemeId) {
      return AsayelProductsWidget(
          featuredProducts: widget.featuredProducts,
          title: widget.title,
          fixedProducts: widget.fixedProducts,
          moreText: widget.moreText,
          containerType: widget.containerType,
          bgSectionColor: widget.bgSectionColor,
          titleColor: widget.titleColor,
          desc: widget.desc,
          descColor: widget.descColor,
          titleCenter: widget.titleCenter,
          moreTextColor: widget.moreTextColor,
          hideDots: widget.hideDots,
          displayMore: widget.displayMore,
          numberOfSm: widget.numberOfSm,
          quantity: widget.quantity);
    }
    return (widget.featuredProducts?.display == false ||
            widget.featuredProducts?.items == null ||
            widget.featuredProducts?.items?.length == 0)
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
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
                          flex: 3,
                          child: CustomText(
                            widget.featuredProducts?.title ?? widget.title,
                            fontSize: 14,
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                          ),

                        ),
                        if (!AppConfig.showMoreTextInButton)
                          if (widget.featuredProducts?.moreButton != null ||
                              widget.moreText != null)
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
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: CustomText(
                                            widget.moreText ?? "عرض الكل".tr,
                                            textAlign: TextAlign.end,
                                            maxLines: 1,
                                            color: primaryColor)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    RotationTransition(
                                        turns: AlwaysStoppedAnimation(
                                            (isArabicLanguage ? 180 : 0) / 360),
                                        child: Image.asset(iconBack,
                                            color: primaryColor, scale: 2)),
                                  ],
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
                    : AspectRatio(
                        aspectRatio: widget.featuredProducts?.items?.length == 2 ||
                                widget.featuredProducts?.items?.length == 1
                            ? AppConfig.productsLessThenThreeWidthAspectRatio
                            : AppConfig.productsHomeAspectRatio,
                        child: ListView.builder(
                            itemCount: widget.featuredProducts?.items?.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => ItemProduct(
                                widget.featuredProducts!.items![index],
                                width: widget.featuredProducts?.items?.length == 2 ||
                                        widget.featuredProducts?.items?.length == 1
                                    ? AppConfig.productItemHomeLessThenThreeWidth
                                    : AppConfig.productItemHomeWidth,
                                backCount: 1,
                                horizontal: true)),
                      ),
                if (AppConfig.currentThemeId == duvetThemeId)
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                              (widget.featuredProducts!.items!.length / 2)
                                  .roundToDouble()
                                  .toInt(),
                              (index) => true)
                          .map((e) => Container(
                                width: 15,
                                height: 1,
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                color: Colors.grey,
                              ))
                          .toList(),
                    ),
                  ),
                if (AppConfig.showMoreTextInButton)
                  if (widget.featuredProducts?.moreButton != null ||
                      widget.moreText != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: ElevatedButton(
                        child: CustomText(
                          widget.moreText ?? "عرض الكل".tr,
                          color: primaryColor,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade50,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(color: primaryColor, width: 1),
                                borderRadius: BorderRadius.circular(2))),
                        onPressed: () {
                          if (AppConfig.isSoreUseNewTheme) {
                            if (widget.featuredProducts?.url != null) {
                              goToLink(widget.featuredProducts?.url);
                            } else if (widget.featuredProducts?.id != null &&
                                widget.featuredProducts?.id != 'null') {
                              Get.toNamed(
                                  '/category-details/${widget.featuredProducts?.id}');
                            } else {
                              Get.toNamed('/category-details/arguments', arguments: {
                                'name': widget.featuredProducts?.title ?? '',
                                'filter': widget.featuredProducts?.moduleType,
                              });
                            }
                          } else {
                            Get.toNamed('/category-details/arguments', arguments: {
                              'name': widget.featuredProducts?.title ?? '',
                              'filter': widget.featuredProducts?.moreButton?.url,
                            });
                          }
                        },
                      ),
                    ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
  }
}
