import 'package:entaj/src/app_config.dart';
import 'package:entaj/src/utils/functions.dart';

import '../../colors.dart';
import '../../entities/category_model.dart';
import '../custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemHomeCategory extends StatelessWidget {
  final CategoryModel? categoryModel;

  const ItemHomeCategory(this.categoryModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.sp),
      onTap: () {
        if (categoryModel?.url?.isNotEmpty == true) {
          goToLink(categoryModel?.url);
        } else {
          Get.toNamed("/category-details/${categoryModel?.id}", preventDuplicates: false);
        }
      },
      child: Container(
        margin: const EdgeInsetsDirectional.only(end: 10),
        width: categoryModel == null ? 100 : null,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
            color: categoryHomeBackgroundColor,
            borderRadius: BorderRadius.circular(20.sp)),
        child: Center(
            child: CustomText(
          categoryModel?.name == null || categoryModel?.name == ''
              ? categoryModel?.sEOCategoryTitle
              : categoryModel?.name,
          fontWeight: FontWeight.normal,
          color: categoryHomeTextColor,
        )),
      ),
    );
  }
}
