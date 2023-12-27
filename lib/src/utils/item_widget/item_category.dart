import '../../app_config.dart';

import '../../colors.dart';
import '../../entities/category_model.dart';
import '../custom_widget/custom_image.dart';
import '../custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ItemCategory extends StatelessWidget {
  final CategoryModel? categoryModel;
  final double? width;
  final bool showCover;

  const ItemCategory(this.categoryModel, this.width, {Key? key, required this.showCover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.sp),
      onTap: () => categoryModel == null
          ? null
          : Get.toNamed("/category-details/${categoryModel?.id}"),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.sp),
        child: Container(
          width: width,
          color: categoryBackgroundColor,
          child: Column(
            children: [
              Expanded(
                  flex: 3,
                  child: CustomImage(
                    url: showCover
                        ? categoryModel?.coverImage ?? categoryModel?.image
                        : categoryModel?.image ?? categoryModel?.coverImage,
                    width: double.infinity,
                    fit: AppConfig.categoryImageFit,
                    size: 30,
                  )),
              if (AppConfig.showCategoryName || AppConfig.showCategoryDescription)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        if (AppConfig.showCategoryName)
                          CustomText(
                            categoryModel?.name == null || categoryModel?.name == ''
                                ? categoryModel?.sEOCategoryTitle
                                : categoryModel?.name,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: categoryTextColor,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        if (AppConfig.showCategoryDescription)
                          CustomText(
                            categoryModel?.description ??
                                categoryModel?.sEOCategoryDescription,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: categoryTextColor,
                            maxLines: 1,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
