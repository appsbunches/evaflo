import 'package:entaj/src/app_config.dart';

import '../../../entities/product_details_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/item_widget/item_product.dart';

class ProductRelatedWidget extends StatelessWidget {
  final int backCount;
  final String productId;
  final List<ProductDetailsModel> relatedProducts;

  const ProductRelatedWidget(
      {required this.productId,
      required this.backCount,
      required this.relatedProducts,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: relatedProducts.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 3, color: Colors.grey.shade300),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomText(
                    "منتجات مشابهة".tr,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Builder(builder: (context) {
                  return AspectRatio(
                    aspectRatio:
                        relatedProducts.length == 2 || relatedProducts.length == 1
                            ? AppConfig.productsRelatedLessThenThreeAspectRatio
                            : AppConfig.productsRelatedAspectRatio,
                    child: ListView.builder(
                        itemCount: relatedProducts.length,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => ItemProduct(
                            relatedProducts[index],
                            width:
                                relatedProducts.length == 2 || relatedProducts.length == 1
                                    ? AppConfig.productsRelatedLessThenThreeWidth
                                    : AppConfig.productsRelatedWidth,
                            backCount: backCount + 1,
                            forWishlist: false,
                            horizontal: true)),
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
              ],
            )
          : const SizedBox(),
    );
  }
}
