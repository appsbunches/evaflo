import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../.env.dart';
import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../entities/home_screen_model.dart';
import '../../../utils/custom_widget/custom_indicator.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/item_widget/item_testimonial.dart';
import '../logic.dart';

class TestimonialWidget extends StatefulWidget {
  final String? title;
  final String? desc;
  final String? bgClr;
  final String? titleClr;
  final String? positionTitle;
  final bool display;
  final bool? hideDots;
  final List<Items> items;

  const TestimonialWidget(
      {Key? key,
      required this.title,
      required this.display,
      this.desc,
      this.bgClr,
      this.titleClr,
      this.positionTitle,
      this.hideDots,
      required this.items})
      : super(key: key);

  @override
  State<TestimonialWidget> createState() => _TestimonialWidgetState();
}

class _TestimonialWidgetState extends State<TestimonialWidget> {
  int currentPage = 0;
  int currentPage2 = 0;
  bool loopStarted = false;
  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    AppConfig.currentThemeId == asayelThemeId && !widget.hideDots! ? startLoop():null;
  }

  onPageChanged(page) {
    currentPage = page;
    setState(() {});
  }

  List<Widget> buildPageIndicator() {
    pageController.addListener(() {
      setState(() {
        currentPage2 = pageController.page?.round() ?? 0;
      });
    });

    List<Widget> list = [];
    for (int i = 0; i < widget.items!.length; i++) {
      list.add(i == currentPage2
          ? const CustomIndicator(true)
          : GestureDetector(
              onTap: () {
                pageController.animateToPage(i,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeIn);
              },
              child: const CustomIndicator(false)));
    }

    return list;
  }

  void startLoop() async {
    if (loopStarted) return;
    loopStarted = true;
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage < widget.items!.length) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      try {
        pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(
        init: Get.find<MainLogic>(),
        builder: (logic) {
          return logic.isHomeLoading
              ? Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CustomText(
                          logic.testimonials?.title ?? '',
                          fontSize: 17,
                          color: primaryColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 200.h,
                        child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) =>
                                const ItemTestimonial()),
                      ),
                    ],
                  ))
              : !widget.display || widget.items.isEmpty
                  ? const SizedBox()
                  : Container(
                      color: HexColor.fromHex(
                          widget.bgClr ?? const Color(0xffF8FAFC).toHex()),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppConfig.paddingBetweenWidget),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment:
                              AppConfig.currentThemeId == asayelThemeId
                                  ? widget.positionTitle == "center"
                                      ? CrossAxisAlignment.center
                                      : widget.positionTitle == "start"
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  if (widget.title != null)
                                    CustomText(
                                      widget.title,
                                      fontSize: 17,
                                      color: HexColor.fromHex(widget.titleClr ??
                                          primaryColor.toHex()),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  if (widget.desc != null)
                                    CustomText(
                                      widget.desc,
                                      color: HexColor.fromHex(widget.titleClr ??
                                          primaryColor.toHex()),
                                      fontWeight: FontWeight.w900,
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: pageController,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: widget.items
                                        .map((e) => ItemTestimonial(
                                              item: e,
                                            ))
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if(widget.hideDots != null)
                                  if (!widget.hideDots!)
                                  AppConfig.currentThemeId == asayelThemeId
                                      ? Container(
                                        alignment: Alignment.bottomCenter,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: buildPageIndicator(),
                                        ),
                                      )
                                      : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
        });
  }
}
