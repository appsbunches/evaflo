import 'slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../colors.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../logic.dart';

class ProductImageWidget extends StatelessWidget {
  final String productId;

  const ProductImageWidget({required this.productId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsLogic>(
        init: Get.find<ProductDetailsLogic>(tag: productId),
        id: productId,
        tag: productId,
        builder: (logic) {
          return SliderWidget(productId:productId,sliderItems: logic.productModel?.images ?? []);
        });
  }

  Center buildImagesList(ProductDetailsLogic logic) {
    return Center(
      child: SizedBox(
        height: 45.h,
        width: (51 * (logic.productModel?.images?.length ?? 0)).w,
        child: ListView.builder(
          itemCount: logic.productModel?.images?.length ?? 0,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => InkWell(
            onTap: () => logic.changeSelectedImage(index),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          logic.selectedImageIndex == index ? secondaryColor : Colors.grey.shade300,
                      width: 2),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: CustomImage(
                url: logic.productModel?.images?[index].image?.thumbnail,
                height: double.infinity,
                width: 30.w,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
