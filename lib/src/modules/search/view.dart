import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../app_config.dart';
import '../../colors.dart';
import '../../images.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import '../../utils/item_widget/item_product.dart';
import 'logic.dart';

class SearchPage extends StatefulWidget {
  final String? searchQ;

  const SearchPage({Key? key, this.searchQ}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchLogic logic = Get.put(SearchLogic());

  late ScrollController scrollController;

  void _reviewsScrollListener() async {
    try {
      var scrollable = Platform.isAndroid
          ? !scrollController.position.outOfRange
          : scrollController.position.outOfRange;
      if (scrollController.offset >= scrollController.position.maxScrollExtent &&
          scrollable &&
          logic.isUnderLoading == false) {
        if (logic.next != null) {
          logic.isUnderLoading = true;
          ++logic.mPage;
          logic.getProductsList(
              q: logic.lastValue, page: logic.mPage, forPagination: true);
        }
      }
    } catch (e) {}
  }

  @override
  initState() {
    if (widget.searchQ != null) {
      logic.searchController.text = widget.searchQ ?? '';
      logic.getProductsList(page: 1, forPagination: false, q: widget.searchQ);
    } else {
      logic.searchController.text = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scrollController = ScrollController();
    scrollController.addListener(_reviewsScrollListener);

    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: AppConfig.showGBAllApp ? GlobalFloatingWhatsApp() : null,
        appBar: AppBar(
          backgroundColor: headerBackgroundColor,
          foregroundColor: headerForegroundColor,
          title: CustomText(
            "البحث".tr,
            fontSize: 16,
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 15),
              child: Image.asset(
                iconLogoAppBarEnd,
                alignment: AlignmentDirectional.centerEnd,
                height: AppConfig.logoSizeInApBarHeight,
                width: AppConfig.logoSizeInApBarWidth,
                color: headerLogoColor,
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            logic.mPage = 1;
            return logic.getProductsList(
                q: logic.lastValue, page: logic.mPage, forPagination: false);
          },
          child: SizedBox(
            height: double.infinity,
            child: GetBuilder<SearchLogic>(
                id: "products",
                builder: (logic) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      (logic.isProductsLoading)
                          ? const CustomProgressIndicator()
                          : const SizedBox(
                              height: 4,
                            ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        margin: const EdgeInsets.fromLTRB(10, 6, 10, 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20.sp)),
                        child: TextFormField(
                          controller: logic.searchController,
                          textInputAction: TextInputAction.search,
                          //  onChanged: logic.onChangeSearchField,
                          autofocus: true,
                          onTap: () {
                            if (logic.searchController.text.isEmpty) return;
                            if (logic.searchController
                                    .text[logic.searchController.text.length - 1] !=
                                ' ') {
                              logic.searchController.text =
                                  (logic.searchController.text + ' ');
                            }
                            if (logic.searchController.selection ==
                                TextSelection.fromPosition(TextPosition(
                                    offset: logic.searchController.text.length - 1))) {
                              logic.update();
                            }
                          },
                          onFieldSubmitted: (val) {
                            logic.mPage = 1;
                            logic.getProductsList(
                                q: val, page: logic.mPage, forPagination: false);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'ابحث هنا'.tr,
                              suffixIcon: GestureDetector(
                                  onTap: () => logic.clearResult(),
                                  child: const Icon(
                                    Icons.highlight_remove_outlined,
                                    color: primaryColor,
                                  )),
                              icon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                      iconSearch,
                                      scale: 2,
                                    )),
                              )),
                        ),
                      ),
                      Expanded(
                        child: logic.productsList.isNotEmpty
                            ? SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  children: [
                                    GridView.builder(
                                      itemCount: logic.productsList.length,
                                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              childAspectRatio:
                                                  AppConfig.productSearchItemAspectRatio),
                                      itemBuilder: (context, index) => ItemProduct(
                                        logic.productsList[index],
                                        backCount: 2,
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
                                ),
                              )
                            : logic.isProductsLoading
                                ? const SizedBox()
                                : Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                        left: 50, right: 50, bottom: 100),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.search,
                                          color: Colors.grey,
                                          size: 80.sp,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        CustomText(
                                          "لم نعثر على نتائج بحث".tr,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                      ),
                    ],
                  );
                }),
          ),
        ));
  }
}
