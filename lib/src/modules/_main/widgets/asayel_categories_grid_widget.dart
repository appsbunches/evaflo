import 'dart:async';

import '../../../.env.dart';
import '../../../app_config.dart';
import '../../../utils/custom_widget/custom_indicator.dart';
import '../../../utils/functions.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../entities/category_model.dart';

import '../../../colors.dart';
import '../../../images.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AsayelCategoriesGridWidget extends StatefulWidget {
  final String? title;
  final String? sectionSubTitle;
  final String? titleColor;
  final String? descColor;
  final String? bgSection;
  final String? catStyle;
  final String? containerType;
  final String? moreText;
  final String? moreClr;
  final bool? hideDots;
  final bool? hideNav;
  final bool? titleCenter;
  final double? number;
  final double? numberOnMd;
  final double? numberOnLg;
  final bool showAsColumn;
  final List<CategoryModel>? categories;

  const AsayelCategoriesGridWidget(
      {Key? key,
      required this.title,
      this.sectionSubTitle,
      this.titleColor,
      this.descColor,
      this.bgSection,
      this.containerType,
      this.moreClr,
      this.catStyle,
      this.hideDots,
      this.titleCenter,
      this.hideNav,
      this.number,
      this.numberOnMd,
      this.numberOnLg,
      required this.categories,
      required this.showAsColumn,
      required this.moreText})
      : super(key: key);

  @override
  State<AsayelCategoriesGridWidget> createState() => _AsayelCategoriesGridWidgetState();
}

class _AsayelCategoriesGridWidgetState extends State<AsayelCategoriesGridWidget> {
  int currentPage = 0;
  int currentPage2 = 0;
  bool loopStarted = false;
  bool showBottomMore = false;
  final PageController pageController = PageController(initialPage: 0);


  onPageChanged(page) {
    currentPage = page;
    setState(() {});
  }

  List<Widget> buildPageIndicator() {
    pageController.addListener(() {
      setState(() {
        currentPage2 = pageController.page?.ceil() ?? 0;
      });
    });

    List<Widget> list = [];
    for (int i = 0; i < widget.categories!.length / widget.number!.ceil(); i++) {
      list.add(i == currentPage2
          ? const CustomIndicator(true)
          : GestureDetector(
              onTap: () {
                pageController.animateToPage(i,
                    duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
              },
              child: const CustomIndicator(false)));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
      margin: widget.containerType == "container"
          ? const EdgeInsets.all(12)
          : const EdgeInsets.symmetric(vertical: 10),
      decoration: widget.containerType == "container"
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(25.sp),
              color: HexColor.fromHex(widget.bgSection ?? Colors.white.toHex()),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: HexColor.fromHex(widget.bgSection ?? Colors.white.toHex()),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: widget.titleCenter == true
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      if (widget.title != null)
                        CustomText(
                          widget.title ?? '',
                          fontSize: widget.categories == null ? 11 : 14,
                          color:
                              HexColor.fromHex(widget.titleColor ?? primaryColor.toHex()),
                          fontWeight: FontWeight.w900,
                        ),
                      if (widget.sectionSubTitle != null)
                        CustomText(
                          widget.sectionSubTitle ?? '',
                          fontSize: 12,
                          color:
                              HexColor.fromHex(widget.descColor ?? primaryColor.toHex()),
                          fontWeight: FontWeight.w500,
                        ),
                    ],
                  ),
                ),
                if (widget.moreText != null)
                  widget.titleCenter == true
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () {
                            MainLogic mainLogic = Get.find();
                            mainLogic.changeSelectedValue(1, true, backCount: 0);
                          },
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.sp),
                                  color: primaryColor),
                              child: CustomText(
                                widget.moreText ?? "عرض الكل".tr,
                                color: HexColor.fromHex(
                                    widget.moreClr ?? Colors.white.toHex()),
                                textAlign: TextAlign.end,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                              ))),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (widget.categories != null)
            Column(
              children: [
                Center(
                  child: SizedBox(
                    height: widget.number! < 3 ? 180.h : 120.h,
                    child: ListView.builder(
                        itemCount: widget.categories?.length ?? 0,
                        padding: EdgeInsets.zero,
                        controller: pageController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                if (widget.categories?[index].id != 'null' &&
                                    widget.categories?[index].id != null) {
                                  Get.toNamed(
                                      '/category-details/${widget.categories?[index].id}');
                                } else {
                                  goToLink(widget.categories?[index].url);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: 10,
                                    end: index == ((widget.categories?.length ?? 0) - 1)
                                        ? 10
                                        : 0),
                                child: Column(
                                  children: [
                                    Builder(builder: (context) {
                                      String? image;
                                      image = widget.categories?[index].image;
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            widget.catStyle == "square" ? 15.w : 100),
                                        child: Container(
                                          width:
                                              ((Get.width - 32) / (widget.number ?? 6)) -
                                                  10,
                                          height:
                                              ((Get.width - 32) / (widget.number ?? 6)) -
                                                  10,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                widget.catStyle == "square" ? 15.w : 100),
                                            color: widget.sectionSubTitle != null
                                                ? Colors.white
                                                : (image?.contains('svg') ?? false)
                                                    ? const Color(0xff369DDD)
                                                    : null,
                                          ),
                                          child: Padding(
                                            padding: (image?.contains('svg') ?? false)
                                                ? const EdgeInsets.all(8)
                                                : EdgeInsets.zero,
                                            child: CustomImage(
                                              url: image,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                    if (AppConfig.currentThemeId != balsamThemeId)
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    if (AppConfig.currentThemeId != balsamThemeId)
                                      Builder(builder: (context) {
                                        String? name = '';
                                        if (widget.categories?[index].name?.isNotEmpty ==
                                            true) {
                                          name = widget.categories?[index].name;
                                        } else {
                                          name =
                                              widget.categories?[index].sEOCategoryTitle;
                                        }
                                        return SizedBox(
                                          width:
                                              ((Get.width - 32) / (widget.number ?? 6)) -
                                                  10,
                                          child: CustomText(
                                            name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            color: HexColor.fromHex(widget.titleColor ??
                                                categoryTextColor.toHex()),
                                          ),
                                        );
                                      }),
                                  ],
                                ),
                              ),
                            )),
                  ),
                ),
                if (widget.moreText != null)
                  widget.titleCenter == true
                      ? GestureDetector(
                          onTap: () {
                            MainLogic mainLogic = Get.find();
                            mainLogic.changeSelectedValue(1, true, backCount: 0);
                          },
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.sp),
                                  color: primaryColor),
                              child: CustomText(
                                widget.moreText ?? "عرض الكل".tr,
                                color: HexColor.fromHex(
                                    widget.moreClr ?? primaryColor.toHex()),
                                textAlign: TextAlign.end,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                              )))
                      : const SizedBox(),
                if (widget.hideDots != null)
                  if (!widget.hideDots!)
                    const SizedBox(
                      height: 10,
                    ),
                if (widget.hideDots != null)
                  if (!widget.hideDots!)
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: buildPageIndicator(),
                      ),
                    )
              ],
            ),
        ],
      ),
    );
  }
}
