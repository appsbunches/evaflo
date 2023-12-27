import 'package:flutter/material.dart';

import '../../../.env.dart';
import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../entities/product_details_model.dart';
import '../../../entities/products_categories_model.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/item_widget/item_product.dart';

class CustomProductsWidget extends StatefulWidget {
  final List<ProductsCategories> productsCategories;
  final bool fixedProducts;
  final String? title;
  final String? moreText;

  const CustomProductsWidget({
    Key? key,
    required this.productsCategories,
    this.title,
    this.fixedProducts = false,
    this.moreText,
  }) : super(key: key);

  @override
  State<CustomProductsWidget> createState() => _CustomProductsWidgetState();
}

class _CustomProductsWidgetState extends State<CustomProductsWidget> {
  List<ProductDetailsModel> list = [];

  @override
  void initState() {
    if (widget.productsCategories.isNotEmpty) {
      list = widget.productsCategories[0].category?.products ?? [];
    }
    print(widget.productsCategories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getWidgetCustom();
  }

  Widget getWidgetCustom() {
    if (widget.productsCategories.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppConfig.paddingBetweenWidget),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!(widget.title == null))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomText(
                  widget.title ?? '',
                  fontSize: 15,
                  color: AppConfig.currentThemeId == naquaThemeId
                      ? const Color(0xffe60000)
                      : primaryColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.productsCategories
                  .map((e) => GestureDetector(
                        onTap: () {
                          setState(() {
                            list = e.category?.products ?? [];
                          });
                        },
                        child: Container(
                            margin: const EdgeInsetsDirectional.only(start: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (list == (e.category?.products ?? []))
                                    ? primaryColor
                                    : null),
                            child: CustomText(
                              e.category?.name ?? '',
                              color: (list == (e.category?.products ?? []))
                                  ? Colors.white
                                  : primaryColor,
                              fontSize: 10,
                            )),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: list.length == 2 || list.length == 1 ? 1.18 : 1.32,
              child: ListView.builder(
                  itemCount: list.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => ItemProduct(list[index],
                      width: list.length == 2 || list.length == 1
                          ? 166
                          : AppConfig.currentThemeId == duvetThemeId
                              ? 166
                              : 140,
                      backCount: 1,
                      horizontal: true)),
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }
}

/*
         AspectRatio(
                        aspectRatio: widget.productsCategories.length == 2 ||
                                widget.productsCategories.length == 1
                            ? 1.18
                            : 1.32,
                        child: ListView.builder(
                            itemCount: widget.productsCategories.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => ItemProduct(
                                widget.productsCategories[index].category.products,
                                width: widget.productsCategories.length == 2 ||
                                        widget.productsCategories.length == 1
                                    ? 166
                                    : AppConfig.currentThemeId == duvetThemeId
                                    ? 166
                                    : 140,
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
                          (featuredProducts!.items!.length / 2)
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
                  if (featuredProducts?.moreButton != null || widget.moreText != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: ElevatedButton(
                        child: CustomText(
                          widget.moreText ?? "عرض الكل".tr,
                          color: primaryColor,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade50,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(color: primaryColor, width: 1),
                                borderRadius: BorderRadius.circular(2))),
                        onPressed: () {
                          if (AppConfig.isSoreUseNewTheme) {
                            if (featuredProducts?.url != null) {
                              goToLink(featuredProducts?.url);
                            } else if (featuredProducts?.id != null &&
                                featuredProducts?.id != 'null') {
                              Get.toNamed('/category-details/${featuredProducts?.id}');
                            } else {
                              Get.toNamed('/category-details/arguments', arguments: {
                                'name': featuredProducts?.title ?? '',
                                'filter': featuredProducts?.moduleType,
                              });
                            }
                          } else {
                            Get.toNamed('/category-details/arguments', arguments: {
                              'name': featuredProducts?.title ?? '',
                              'filter': featuredProducts?.moreButton?.url,
                            });
                          }
                        },
                      ),
                    ),
                const SizedBox(
                  height: 15,
                ),
 */
