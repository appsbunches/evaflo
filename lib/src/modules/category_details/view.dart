import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../app_config.dart';
import '../../colors.dart';
import '../../images.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_sized_box.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import '../../utils/item_widget/item_category.dart';
import '../../utils/item_widget/item_home_category.dart';
import '../../utils/item_widget/item_product.dart';
import '../_main/widgets/my_bottom_nav.dart';
import '../no_Internet_connection_screen.dart';
import 'logic.dart';

class CategoryDetailsPage extends StatefulWidget {
  final bool hideHeaderFooter;

  const CategoryDetailsPage({this.hideHeaderFooter = false, Key? key}) : super(key: key);

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage>
    with WidgetsBindingObserver {
  late CategoryDetailsLogic logic;
  late String categoryId;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    categoryId = Get.parameters['categoryId'] ?? '';
    logic = Get.put(CategoryDetailsLogic(),
        tag: widget.hideHeaderFooter ? 'lite' : categoryId);
    if (categoryId != 'arguments') {
      logic.getProductsList(
          forPagination: false, mHideHeaderFooter: widget.hideHeaderFooter);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryDetailsLogic>(
        tag: widget.hideHeaderFooter ? 'lite' : categoryId,
        init: Get.find<CategoryDetailsLogic>(
            tag: widget.hideHeaderFooter ? 'lite' : categoryId),
        autoRemove: false,
        builder: (logic) {
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
            floatingActionButton:
                AppConfig.showGBAllApp ? const GlobalFloatingWhatsApp() : null,
            bottomNavigationBar: widget.hideHeaderFooter
                ? null
                : MyBottomNavigation(backCount: logic.getBackCount(categoryId)),
            appBar: widget.hideHeaderFooter
                ? null
                : AppBar(
                    backgroundColor: headerBackgroundColor,
                    foregroundColor: headerForegroundColor,
                    actions: [
                      InkWell(
                          onTap: () => logic.goToSearch(),
                          child: Image.asset(
                            iconSearch,
                            color: headerForegroundColor,
                            scale: 2,
                          )),
                    ],
                    title: CustomText(
                      categoryId == '*'
                          ? 'جميع المنتجات'.tr
                          : logic.categoryModel?.name ?? logic.name,
                      fontSize: 16,
                    ),
                  ),
            backgroundColor: categoryDetailsBackgroundColor,
            body: !logic.hasInternet
                ? const NoInternetConnectionScreen()
                : logic.isCategoryLoading || logic.isProductsLoading
                    ? const CustomProgressIndicator()
                    : RefreshIndicator(
                        onRefresh: () => logic.clearAndFetch(removeFilter: true),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: logic.scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildCategories(logic),
                                if (!(logic.productsList.isEmpty && !logic.filter))
                                  buildFilter(logic),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (logic.productsList.isEmpty &&
                                    logic.subCategories.isEmpty)
                                  buildEmptyProduct(),
                                if (logic.productsList.isNotEmpty) buildProducts(),
                              ],
                            ),
                          ),
                        ),
                      ),
          );
        });
  }

  GetBuilder<CategoryDetailsLogic> buildProducts() {
    return GetBuilder<CategoryDetailsLogic>(
        tag: widget.hideHeaderFooter ? 'lite' : categoryId,
        init: Get.find<CategoryDetailsLogic>(
            tag: widget.hideHeaderFooter ? 'lite' : categoryId),
        builder: (logic) {
          return Column(
            children: [
              logic.isProductsLoading
                  ? const CustomProgressIndicator()
                  : GridView.builder(
                      itemCount: logic.productsList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio:
                              AppConfig.productCategoryDetailsItemAspectRatio),
                      itemBuilder: (context, index) => ItemProduct(
                        logic.productsList[index],
                        backCount: logic.getBackCount(categoryId) + 1,
                        horizontal: false,
                        forWishlist: false,
                      ),
                    ),
              if (logic.isUnderLoading)
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
            ],
          );
        });
  }

  SizedBox buildEmptyProduct() {
    return SizedBox(
      height: 500.h,
      child: Center(
        child: SizedBox(
            width: double.infinity,
            child: CustomText(
              'لا يوجد منتجات حالياً'.tr,
              textAlign: TextAlign.center,
            )),
      ),
    );
  }

  buildFilter(CategoryDetailsLogic logic) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: InkWell(
                onTap: () => logic.openFilterDialog(categoryId),
                child: Container(
                  height: 44.h,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: filterBackgroundColor,
                      borderRadius: BorderRadius.circular(15.sp)),
                  child: Row(
                    children: [
                      CustomText(
                        AppConfig.newFiltrationMode ? "تصفية النتائج".tr : "السعر".tr,
                        fontWeight: FontWeight.bold,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: filterIconColor,
                      )
                    ],
                  ),
                ),
              )),
          /*
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: InkWell(
            onTap: () => logic.openCitesFilter(categoryId),
            child: Container(
              height: 44.h,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: filterBackgroundColor,
                  borderRadius: BorderRadius.circular(15.sp)),
              child: const Icon(
                Icons.location_pin,
                color: filterIconColor,
              ),
            ),
          )),*/
          const SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 2,
              child: Container(
                height: 44.h,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: filterBackgroundColor,
                    borderRadius: BorderRadius.circular(15.sp)),
                child: Row(
                  children: [
                    isArabicLanguage
                        ? Image.asset(
                            iconFilter,
                            color: filterIconColor,
                            scale: 2,
                          )
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: Image.asset(
                              iconFilter,
                              color: filterIconColor,
                              scale: 2,
                            ),
                          ),
                    Expanded(
                      child: GetBuilder<CategoryDetailsLogic>(
                          tag: widget.hideHeaderFooter ? 'lite' : categoryId,
                          init: Get.find<CategoryDetailsLogic>(
                              tag: widget.hideHeaderFooter ? 'lite' : categoryId),
                          builder: (logic) {
                            return DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                iconEnabledColor: filterIconColor,
                                onChanged: logic.onSortChanged,
                                value: logic.selectedSort,
                                hint: SizedBox(
                                  child: Row(
                                    children: [
                                      const CustomSizedBox(
                                        width: 5,
                                      ),
                                      CustomText(
                                        logic.sortList.first,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                                items: logic.sortList
                                    .map((e) => DropdownMenuItem(
                                          child: SizedBox(
                                            child: Row(
                                              children: [
                                                const CustomSizedBox(
                                                  width: 5,
                                                ),
                                                CustomText(
                                                  e,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                          ),
                                          value: e,
                                        ))
                                    .toList(),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  buildCategories(CategoryDetailsLogic logic) {
    return GetBuilder<CategoryDetailsLogic>(
        autoRemove: false,
        tag: widget.hideHeaderFooter ? 'lite' : categoryId,
        init: Get.find<CategoryDetailsLogic>(
            tag: widget.hideHeaderFooter ? 'lite' : categoryId),
        builder: (context) {
          return logic.isProductsLoading
              ? const SizedBox()
              : (logic.subCategories.isNotEmpty)
                  ? (AppConfig.showSubCategoriesAsGrid && logic.productsList.isEmpty ||
                              logic.productsList.isEmpty &&
                                  logic.subCategories.isNotEmpty) &&
                          !logic.filter
                      ? GridView.builder(
                          itemCount: logic.subCategories.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1),
                          itemBuilder: (context, index) => ItemCategory(
                              logic.subCategories[index], 100,
                              showCover: false))
                      : SizedBox(
                          height: logic.subCategories.isEmpty
                              ? 0
                              : AppConfig.showSubCategoriesAsGrid
                                  ? 170.h
                                  : 58.h,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: logic.subCategories.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return AppConfig.showSubCategoriesAsGrid
                                          ? ItemCategory(
                                              logic.subCategories[index],
                                              120,
                                              showCover: false,
                                            )
                                          : ItemHomeCategory(logic.subCategories[index]);
                                    }),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],
                          ),
                        )
                  : const SizedBox();
        });
  }
}
