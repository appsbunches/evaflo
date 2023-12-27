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

import 'asayel_categories_grid_widget.dart';

class CategoriesGridWidget extends StatefulWidget {
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

  const CategoriesGridWidget(
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
      this.numberOnMd,
      this.numberOnLg,
      this.hideNav,
      this.number,
      required this.categories,
      required this.showAsColumn,
      required this.moreText})
      : super(key: key);

  @override
  State<CategoriesGridWidget> createState() => _CategoriesGridWidgetState();
}

class _CategoriesGridWidgetState extends State<CategoriesGridWidget> {
  int currentPage = 0;
  int currentPage2 = 0;
  bool loopStarted = false;
  bool showBottomMore = false;
  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    if (AppConfig.currentThemeId == asayelThemeId) {
      var num =
          (widget.categories?.length ?? 0) > 4 ? 4 : (widget.categories?.length ?? 0);
      return AsayelCategoriesGridWidget(
          title: widget.title,
          sectionSubTitle: widget.sectionSubTitle,
          titleColor: widget.titleColor,
          descColor: widget.descColor,
          bgSection: widget.bgSection,
          containerType: widget.containerType,
          moreClr: widget.moreClr,
          catStyle: widget.catStyle,
          hideDots: widget.hideDots,
          numberOnMd: widget.numberOnMd,
          numberOnLg: widget.numberOnLg,
          titleCenter: widget.titleCenter,
          hideNav: widget.hideNav,
          number: widget.number ?? checkDouble(num),
          categories: widget.categories,
          showAsColumn: widget.showAsColumn,
          moreText: widget.moreText);
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.title != null)
                        CustomText(
                          widget.title ?? '',
                          fontSize: widget.categories == null ? 11 : 14,
                          color: widget.categories == null ? Colors.black : primaryColor,
                          fontWeight: FontWeight.w900,
                        ),
                      if (widget.sectionSubTitle != null)
                        CustomText(
                          widget.sectionSubTitle ?? '',
                          fontSize: 12,
                          color: widget.categories == null ? Colors.black : primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                    ],
                  ),
                ),
                if (widget.moreText != null)
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                        onTap: () {
                          MainLogic mainLogic = Get.find();
                          mainLogic.changeSelectedValue(1, true, backCount: 0);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: CustomText(
                              widget.moreText ?? "عرض الكل".tr,
                              color: primaryColor,
                              textAlign: TextAlign.end,
                              maxLines: 1,
                            )),
                            const SizedBox(
                              width: 5,
                            ),
                            RotationTransition(
                                turns: AlwaysStoppedAnimation(
                                    (isArabicLanguage ? 180 : 0) / 360),
                                child:
                                    Image.asset(iconBack, color: primaryColor, scale: 2)),
                          ],
                        )),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (widget.categories != null)
            widget.showAsColumn
                ? GridView.custom(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverStairedGridDelegate(
                      pattern: widget.categories?.map((e) {
                            var index = widget.categories!.indexOf(e);
                            return (index == 0 || index == widget.categories!.length - 1)
                                ? const StairedGridTile(1, 2)
                                : const StairedGridTile(0.5, 1);
                          }).toList() ??
                          [],
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                      (context, index) => InkWell(
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
                          padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30)),
                                child: CustomImage(
                                  url: widget.categories?[index].image,
                                  size: 30,
                                ),
                              ),
                              Positioned(
                                bottom: 70,
                                left: 20,
                                right: 20,
                                child: Builder(builder: (context) {
                                  String? name = '';
                                  if (widget.categories?[index].name?.isNotEmpty ==
                                      true) {
                                    name = widget.categories?[index].name;
                                  } else {
                                    name = widget.categories?[index].sEOCategoryTitle;
                                  }
                                  return name?.isNotEmpty == true
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10)),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 10),
                                          child: CustomText(
                                            name,
                                            color: Colors.grey,
                                            maxLines: 1,
                                          ),
                                        )
                                      : const SizedBox();
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      childCount: widget.categories?.length ?? 0,
                    ),
                  )
                : Center(
                    child: SizedBox(
                      height: (AppConfig.currentThemeId != balsamThemeId) ? 120.h : 90.h,
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
                                        if (AppConfig.currentThemeId == naquaThemeId) {
                                          image = widget.categories?[index].icon;
                                        } else {
                                          image = widget.categories?[index].image;
                                        }
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              AppConfig.currentThemeId == naquaThemeId
                                                  ? 40.w
                                                  : 15),
                                          child: Container(
                                            width: 80.w,
                                            height: 80.w,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  AppConfig.currentThemeId == naquaThemeId
                                                      ? 40.w
                                                      : 15),
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
                                          if (widget
                                                  .categories?[index].name?.isNotEmpty ==
                                              true) {
                                            name = widget.categories?[index].name;
                                          } else {
                                            name = widget
                                                .categories?[index].sEOCategoryTitle;
                                          }
                                          return SizedBox(
                                            width: 90.w,
                                            child: CustomText(
                                              name,
                                              overflow: TextOverflow.visible,
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
        ],
      ),
    );
  }
}
