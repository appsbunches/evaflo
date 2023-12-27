import 'package:entaj/src/app_config.dart';

import '../logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/item_widget/item_product.dart';

class ProductOfferWidget extends StatelessWidget {
  final int backCount;
  final String productId;

  const ProductOfferWidget({required this.productId, required this.backCount, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsLogic>(
        init: Get.find<ProductDetailsLogic>(tag: productId),
        tag: productId,
        id: productId,
        builder: (logic) {
          return Container(
            color: Colors.grey.shade50,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: logic.offerProductsList.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 3, color: Colors.grey.shade300),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.wallet_giftcard,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    logic.discountResponseModel?.name,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  CustomText(
                                    logic.discountResponseModel?.description,
                                    fontSize: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: AppConfig.productsOffersAspectRatio,
                        child: ListView.builder(
                            itemCount: logic.offerProductsList.length,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => ItemProduct(
                                logic.offerProductsList[index],
                                backCount: backCount + 1,
                                forWishlist: false,
                                horizontal: true)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : const SizedBox(),
          );
        });
  }
}
