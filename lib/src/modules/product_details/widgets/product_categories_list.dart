import '../../../colors.dart';
import '../../../entities/category_model.dart';

import '../logic.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductCategoriesList extends StatefulWidget {
  final String mProductId;

  const ProductCategoriesList({
    required this.mProductId,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductCategoriesList> createState() => _ProductCategoriesListState();
}

class _ProductCategoriesListState extends State<ProductCategoriesList> {
  bool clicked = false;
  List<GlobalKey> listGlobalKey = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsLogic>(
            init: Get.find<ProductDetailsLogic>(tag: widget.mProductId),
            tag: widget.mProductId,
            builder: (logic) {
              calculateRemCategories(logic.productModel?.categories ?? [], logic);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText('التصنيفات'.tr),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: logic.productModel?.categories
                                  ?.sublist(
                                      0,
                                      ((logic.productModel?.categories?.length ?? 0) > 3)
                                          ? 3
                                          : logic.productModel?.categories?.length)
                                  .map(
                                    (e) => Flexible(
                                      child: GestureDetector(
                                        onTap: () => Get.toNamed("/category-details/${e.id}"),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15.sp),
                                                color: categoryProductDetailsBackgroundColor),
                                            margin: const EdgeInsetsDirectional.only(end: 10),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            child: CustomText(
                                              '${e.name}',
                                              color: categoryProductDetailsTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            )),
                                      ),
                                    ),
                                  )
                                  .toList() ??
                              [],
                        ),
                      ),
                      if (false)
                        Expanded(
                          child: RichText(
                            maxLines: 1,
                            text: TextSpan(
                                children: logic.productModel?.categories
                                        ?.map((e) => WidgetSpan(
                                              child: GestureDetector(
                                                onTap: () =>
                                                    Get.toNamed("/category-details/${e.id}"),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15.sp),
                                                        color:
                                                            categoryProductDetailsBackgroundColor),
                                                    margin:
                                                        const EdgeInsetsDirectional.only(end: 10),
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 10, vertical: 4),
                                                    child: CustomText(
                                                      e.name,
                                                      color: categoryProductDetailsTextColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                    )),
                                              ),
                                            ))
                                        .toList() ??
                                    []),
                          ),
                        ),
                      if (categoriesNum != 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PopupMenuButton(
                              color: primaryColor,
                              padding: EdgeInsets.zero,
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              itemBuilder: (context) {
                                return List.generate(categoriesNum, (index) {
                                  var e = logic.productModel?.categories?[index +
                                      ((logic.productModel?.categories?.length ?? 0) -
                                          categoriesNum)];
                                  return PopupMenuItem(
                                    padding: EdgeInsets.zero,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () => Get.toNamed("/category-details/${e?.id}"),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CustomText(
                                              e?.name,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        if (index != categoriesNum - 1)
                                          Container(
                                              height: 1,
                                              color: Colors.white30,
                                              width: double.infinity)
                                      ],
                                    ),
                                  );
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.sp),
                                      color: categoryProductDetailsBackgroundColor),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  child: CustomText(
                                    '$categoriesNum+',
                                    color: categoryProductDetailsTextColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              );
            });
  }

  int categoriesNum = 0;

  double calculateRemCategories(List<CategoryModel> categories, logic) {
    double width = 0;
    categoriesNum = 0;
    for (var element in categories) {
      width += 20;
      var length = element.name?.length ?? 0;
      width += (length * 3.5);
      if (width > 200) {
        categoriesNum++;
        continue;
      }
    }
    categoriesNum = (logic.productModel?.categories?.length ?? 0) > 3
        ? (logic.productModel?.categories?.length ?? 0) - 3
        : 0;
    return width;
  }
}
