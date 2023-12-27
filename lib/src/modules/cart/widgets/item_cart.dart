import 'package:flutter/cupertino.dart' as cup;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../../colors.dart';
import '../../../entities/cart_model.dart';
import '../../../images.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../logic.dart';

class ItemCart extends cup.StatefulWidget {
  final Products product;
  final bool hasDiscount;
  final int length;

  const ItemCart(this.product, this.hasDiscount, this.length, {Key? key})
      : super(key: key);

  @override
  cup.State<ItemCart> createState() => _ItemCartState();
}

class _ItemCartState extends cup.State<ItemCart> {
  final CartLogic _cartLogic = Get.find();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    const itemCartOfferTextColor = Color(0xff1C8B89);

    return GetBuilder<CartLogic>(
        id: widget.product.id,
        autoRemove: false,
        builder: (logic) {
          return Dismissible(
            direction:
                isLoading ? DismissDirection.none : DismissDirection.endToStart,
            resizeDuration: const Duration(milliseconds: 200),
            key: UniqueKey(),
            onDismissed: (direction) {
              if (isLoading) return;
              _cartLogic.deleteItem(widget.product.id!);
            },
            child: GestureDetector(
              onTap: () {
                if (widget.product.isOriginalProductAvailable == false) {
                  logic.goToHome();
                } else {
                  Get.toNamed('/product-details/${widget.product.productId}',
                      arguments: {'backCount': '1'});
                }
              },
              child: Column(
                children: [
                  if (widget.product.isDiscounted == true)
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsetsDirectional.only(start: 20),
                          child: Icon(
                            Icons.add,
                            size: 40,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            color: Colors.grey.shade200,
                          ),
                        )
                      ],
                    ),
                  if (widget.product.meta?.bundleOffer != null &&
                      widget.product.isDiscounted != true &&
                      widget.length == 0)
                    Container(
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.card_giftcard),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomText(
                              widget.product.meta?.bundleOffer?.name,
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  cup.Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CustomImage(
                                    url: widget.product.images?.isNotEmpty ==
                                            true
                                        ? widget.product.images?.first.origin
                                                    ?.contains(
                                                        'missing_image') ==
                                                true
                                            ? ''
                                            : widget.product.images?.first
                                                    .origin ??
                                                ''
                                        : '',
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 4,
                              child: CustomText(
                                widget.product.name,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    children: [
                                      CustomText(
                                        widget.product.totalString,
                                        color: secondaryColor,
                                        overflow: TextOverflow.visible,
                                        fontWeight: FontWeight.bold,
                                        maxLines: 2,
                                        fontSize: 10,
                                      ),
                                      if (widget.product.totalBeforeString
                                              ?.isNotEmpty ==
                                          true)
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      CustomText(
                                        widget.product.totalBeforeString,
                                        color: moveColor,
                                        fontSize: 10,
                                        maxLines: 2,
                                        lineThrough: true,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  if ((widget.product.quantity ?? 0) > 1)
                                    CustomText(
                                      isArabicLanguage
                                          ? '(للواحد ${widget.product.priceString})'
                                          : '(each ${widget.product.priceString})',
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //  if (widget.product.isPublished == true)
                        Row(
                          children: [
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1)),
                              height: 35.h,
                              child: widget.product.isPublished != true
                                  ? InkWell(
                                      onTap: () async {
                                        if (isLoading) return;
                                        isLoading = true;
                                        setState(() {});
                                        await _cartLogic
                                            .deleteItem(widget.product.id!);
                                        isLoading = false;
                                        setState(() {});
                                      },
                                      child: cup.SizedBox(
                                        width: 40.w,
                                        child: isLoading
                                            ? const cup
                                                .CupertinoActivityIndicator()
                                            : Image.asset(
                                                iconRemoveRed,
                                                color: deleteIconColor,
                                                scale: 2,
                                              ),
                                      ))
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: widget.product.quantity == 1 ||
                                                  widget.product
                                                          .isProductPriceUpdated ==
                                                      true ||
                                                  widget.product
                                                          .isOriginalQuantityFinished ==
                                                      true
                                              ? InkWell(
                                                  onTap: () async {
                                                    if (isLoading) return;
                                                    isLoading = true;
                                                    setState(() {});
                                                    await _cartLogic.deleteItem(
                                                        widget.product.id!);
                                                    isLoading = false;
                                                    setState(() {});
                                                  },
                                                  child: cup.SizedBox(
                                                    width: 40.w,
                                                    child: isLoading
                                                        ? const cup
                                                            .CupertinoActivityIndicator()
                                                        : Image.asset(
                                                            iconRemoveRed,
                                                            color:
                                                                deleteIconColor,
                                                            scale: 2,
                                                          ),
                                                  ))
                                              : GestureDetector(
                                                  onTap: () =>
                                                      logic.decreaseQuantity(
                                                          widget.product),
                                                  child: Container(
                                                      height: double.infinity,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 10.w),
                                                      child: const Icon(
                                                        Icons.remove,
                                                        color: Colors.black,
                                                      )),
                                                ),
                                        ),
                                        Container(
                                            height: double.infinity,
                                            width: 40.w,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Center(
                                                child: CustomText(
                                              widget.product
                                                          .isOriginalQuantityFinished ==
                                                      true
                                                  ? '0'
                                                  : widget.product.quantity
                                                      .toString(),
                                              fontWeight: FontWeight.bold,
                                            ))),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: GestureDetector(
                                            onTap: () => logic.increaseQuantity(
                                                widget.product),
                                            child: Container(
                                                height: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(
                                                              isArabicLanguage
                                                                  ? 0
                                                                  : 15.sp),
                                                      topLeft: Radius.circular(
                                                          isArabicLanguage
                                                              ? 0
                                                              : 15.sp),
                                                      bottomRight:
                                                          Radius.circular(
                                                              isArabicLanguage
                                                                  ? 15.sp
                                                                  : 0),
                                                      topRight: Radius.circular(
                                                          isArabicLanguage
                                                              ? 15.sp
                                                              : 0),
                                                    )),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10.w),
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                        if (widget.product.isDiscounted == true) buildOffer(),
                        if (widget.product.isProductPriceUpdated == true ||
                            widget.product.isOriginalQuantityFinished == true ||
                            widget.product.isRequestedQuantityEnough == false ||
                            widget.product.isOriginalProductAvailable == false)
                          Container(
                            width: double.infinity,
                            decoration: cup.BoxDecoration(
                                color: moveColor.withOpacity(0.4),
                                borderRadius: cup.BorderRadius.circular(8)),
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            child: cup.Column(
                              crossAxisAlignment: cup.CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  widget.product.isOriginalQuantityFinished ==
                                          true
                                      ? 'نفذت الكمية'.tr
                                      : widget.product.isProductPriceUpdated ==
                                              true
                                          ? 'تم تغيير سعر هذا المنتج'.tr
                                          : widget.product
                                                      .isRequestedQuantityEnough ==
                                                  false
                                              ? 'لا توجد كمية إضافية كافية من هذا المنتج'
                                                  .tr
                                              : 'هذا المنتج لم يعد متوفراً'.tr,
                                  color: Colors.red.shade900,
                                  fontSize: 10,
                                ),
                                CustomText(
                                  widget.product.isOriginalQuantityFinished ==
                                          true
                                      ? 'احذف المنتج لإتمام عملية الشراء'.tr
                                      : widget.product.isProductPriceUpdated ==
                                              true
                                          ? 'قم بإضافته مرة أخرى بالضغط على المنتج'
                                              .tr
                                          : widget.product
                                                      .isRequestedQuantityEnough ==
                                                  false
                                              ? 'المتبقي هو - @quantity - من هذا المنتج'
                                                  .trParams({
                                                  "quantity": widget.product
                                                      .originalProductQuantity
                                                      .toString()
                                                })
                                              : 'احذف المنتج لإتمام عملية الشراءً'
                                                  .tr,
                                  color: Colors.red.shade900,
                                  fontSize: 10,
                                ),
                              ],
                            ),
                          ),
                        ListView.builder(
                            itemCount: widget.product.customFields?.length ?? 0,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var customField =
                                  widget.product.customFields?[index];
                              return cup.Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: CustomText(
                                      customField?.groupName ??
                                          customField?.realName,
                                      color: primaryColor,
                                    )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    (widget.product.customFields?[index].type ==
                                            'IMAGE')
                                        ? Flexible(
                                            child: CustomImage(
                                            url: widget
                                                .product
                                                .customFields?[index]
                                                .formattedValue,
                                            height: 70,
                                            width: 70,
                                          ))
                                        : (widget.product.customFields?[index]
                                                    .type ==
                                                'FILE')
                                            ? Flexible(
                                                child: cup.GestureDetector(
                                                onTap: () => launch(widget
                                                        .product
                                                        .customFields?[index]
                                                        .formattedValue ??
                                                    ''),
                                                child: CustomText(
                                                  'تحميل'.tr,
                                                  color: Colors.blue,
                                                ),
                                              ))
                                            : Flexible(
                                                child: CustomText(
                                                    customField?.value)),
                                    if ((customField?.type == 'DROPDOWN' ||
                                        customField?.type == 'CHECKBOX'))
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    if ((customField?.type == 'DROPDOWN' ||
                                        customField?.type == 'CHECKBOX'))
                                      Flexible(
                                          child: CustomText(
                                              customField?.realName)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    if (customField?.additionsPrice != null &&
                                        customField?.additionsPrice != 0)
                                      Flexible(
                                          child: CustomText(customField
                                              ?.additionsPriceString))
                                  ],
                                ),
                              );
                            }),
                        if (!widget.hasDiscount)
                          if (widget.product.meta?.bundleOffer != null &&
                              widget.product.isDiscounted != true)
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 12),
                              decoration: BoxDecoration(
                                  color: Colors.yellow.shade50,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: CustomText(
                                      widget.product.meta?.bundleOffer
                                                  ?.discountPercentage ==
                                              100
                                          ? 'عند شرائك لهذا المنتج ستحصل على عرض مجاني لمنتجات محددة'
                                              .tr
                                          : 'عند شرائك لهذا المنتج ستحصل على خصم @discountPercentage% لمنتجات محددة'
                                              .trParams({
                                              'discountPercentage': (widget
                                                          .product
                                                          .meta
                                                          ?.bundleOffer
                                                          ?.discountPercentage ??
                                                      0)
                                                  .floor()
                                                  .toString()
                                            }),
                                      fontSize: 10,
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: const BorderSide(
                                                  color: primaryColor))),
                                      child: CustomText(
                                        'احصل على العرض'.tr,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        Get.toNamed(
                                            '/product-details/${widget.product.productId}',
                                            arguments: {'backCount': '1'});
                                      })
                                ],
                              ),
                            ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  buildOffer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          color: Colors.grey.shade200,
          margin: const EdgeInsets.symmetric(vertical: 10),
        ),
        CustomText(
          widget.product.meta?.bundleOffer?.discountPercentage == 100
              ? 'حزمة تسويقية - منتج مجاني'.tr
              : 'حزمة تسويقية بقيمة @discountPercentage%'.trParams({
                  'discountPercentage':
                      (widget.product.meta?.bundleOffer?.discountPercentage ??
                              0)
                          .floor()
                          .toString()
                }),
          color: primaryColor,
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
