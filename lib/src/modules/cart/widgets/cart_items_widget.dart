import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../colors.dart';
import '../../../entities/cart_model.dart';
import 'item_cart.dart';
import '../logic.dart';

class CartItemsWidget extends StatelessWidget {
  const CartItemsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartLogic>(
        init: Get.find<CartLogic>(),
        id: 'cart',
        builder: (logic) {
          List<List<Products>> products = [];
          List<String?> bundleOfferIds = [];
          logic.cartModel?.products?.forEach((element) {
            if (element.meta?.bundleOffer?.id == null) {
              products.add([element]);
            } else if (!bundleOfferIds.contains(element.meta?.bundleOffer?.id)) {
              bundleOfferIds.add(element.meta?.bundleOffer?.id);
            }
          });
          for (var bundleOfferId in bundleOfferIds) {
            List<Products> productsOffer = [];
            logic.cartModel?.products?.forEach((element) {
              if (element.meta?.bundleOffer?.id == bundleOfferId) {
                productsOffer.add(element);
              }
            });

            productsOffer.sort((Products a, Products b) =>
                a.isDiscounted!.toString().compareTo(b.isDiscounted.toString()));
            products.add(productsOffer);
          }
          return ListView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200)),
                    child: Column(
                      children: products[index]
                          .map((e) => ItemCart(
                              e,
                              products[index].firstWhereOrNull(
                                      (element) => element.isDiscounted == true) !=
                                  null,
                              products[index].indexOf(e)))
                          .toList(),
                    ));
              });
        });
  }
}
