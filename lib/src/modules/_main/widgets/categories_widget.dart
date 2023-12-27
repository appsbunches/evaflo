import '../../../app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../colors.dart';
import '../../../utils/item_widget/item_home_category.dart';
import '../logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesWidget extends StatelessWidget {
  CategoriesWidget({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return !AppConfig.showCategoriesInHome
        ? const SizedBox(
            height: 5,
          )
        : GetBuilder<MainLogic>(
            id: "categories",
            init: Get.find<MainLogic>(),
            builder: (logic) {
              return logic.isCategoriesLoading
                  ? Shimmer.fromColors(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      child: SizedBox(
                        height: 38.h,
                        child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) =>
                                const ItemHomeCategory(null)),
                      ))
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: AppConfig.paddingBetweenWidget),
                      height: logic.mainMenuList.isNotEmpty ? 38.h : 0,
                      child: Row(
                        children: [
                          Expanded(
                              child: ListView.builder(
                                  itemCount: logic.mainMenuList.length,
                                  controller: scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return ItemHomeCategory(logic.mainMenuList[index]);
                                  })),
                          if (AppConfig.showScrollDownIconInHomeCategories)
                            GestureDetector(
                                onTap: () {
                                  scrollController.animateTo(
                                    scrollController.offset + 200,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                                },
                                child: const Center(child: Icon(Icons.arrow_forward))),
                        ],
                      ),
                    );
            });
  }
}
