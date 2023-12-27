import 'dart:async';
import 'dart:ui';

import 'package:get/get.dart';

import '../../../.env.dart';
import '../../../utils/custom_widget/custom_indicator.dart';
import '../../../utils/functions.dart';

import '../../../app_config.dart';
import '../../../entities/home_screen_model.dart';
import '../../../utils/custom_widget/custom_image.dart';
import 'package:flutter/material.dart';
import '../../../colors.dart';
import '../../../utils/custom_widget/custom_text.dart';

class AsayelPartnersWidget extends StatefulWidget {
  final String? title;
  final String? desc;
  final String? backgroundColor;
  final String? mainColorTitle;
  final String? positionTitle;
  final double? number;
  final bool hideDots;
  final bool? hideNav;
  final List<Items>? gallery;

  const AsayelPartnersWidget(
      {Key? key,
      required this.title,
      this.desc,
      this.backgroundColor,
      this.mainColorTitle,
      this.positionTitle,
      this.number,
      this.hideDots = false,
      this.hideNav,
      required this.gallery})
      : super(key: key);

  @override
  State<AsayelPartnersWidget> createState() => _AsayelPartnersWidgetState();
}

class _AsayelPartnersWidgetState extends State<AsayelPartnersWidget> {
  int currentPage = 0;
  int currentPage2 = 0;
  bool loopStarted = false;
  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    if (!widget.hideDots) {
      startLoop();
    }
/*      pageController.addListener(() {
        setState(() {
          currentPage = pageController.page?.round() ?? 0;
        });
      });*/
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
    for (int i = 0; i < widget.gallery!.length / widget.number!.round(); i++) {
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

  void startLoop() async {
    if (loopStarted) return;
    loopStarted = true;
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage < widget.gallery!.length / widget.number!.round()) {
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
    return (widget.gallery == null || widget.gallery?.length == 0)
        ? const SizedBox()
        : Container(
            padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
            margin: const EdgeInsets.only(top: 10),
            color: HexColor.fromHex(widget.backgroundColor ?? Colors.white.toHex()),
            child: Column(
              crossAxisAlignment: widget.positionTitle == "center"
                  ? CrossAxisAlignment.center
                  : widget.positionTitle == "start"
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
              children: [
                if (widget.title != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          widget.title,
                          fontSize: 17,
                          color: HexColor.fromHex(
                              widget.mainColorTitle ?? primaryColor.toHex()),
                          fontWeight: FontWeight.w900,
                        ),
                        CustomText(
                          widget.desc,
                          fontSize: 12,
                          color: HexColor.fromHex(
                              widget.mainColorTitle ?? primaryColor.toHex()),
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                Column(
                  children: [
                    SizedBox(
                        width: double.infinity,
                        height: widget.number == 1
                            ? Get.height * 0.43
                            : widget.number == 2
                                ? Get.height * 0.202
                                : widget.number == 3
                                    ? Get.height * 0.13
                                    : widget.number == 4
                                        ? Get.height * 0.09
                                        : 50,
                        child: ListView.builder(
                          itemCount: widget.gallery?.length ?? 0,
                          scrollDirection: Axis.horizontal,
                          controller: pageController,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () => goToLink(widget.gallery?[index].url),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: CustomImage(
                                url: widget.gallery?[index].image,
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    if (!widget.hideDots)
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
                )
              ],
            ),
          );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
