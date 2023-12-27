import 'dart:async';

import 'package:entaj/src/.env.dart';
import 'package:entaj/src/modules/_main/widgets/asayel_slider_widget.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as y;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../entities/home_screen_model.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_indicator.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';
import '../logic.dart';
import '../tabs/home/logic.dart';

class SliderWidget extends StatefulWidget {
  List<Items> sliderItems;
  final bool hideDots;
  String? textColor;
  String? backgroundColor;

  SliderWidget(
      {required this.sliderItems,
      required this.hideDots,
      Key? key,
      required this.textColor,
      required this.backgroundColor})
      : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  void initState() {
    super.initState();
    startLoop();
  }

  int currentPage = 0;

  bool loopStarted = false;

  final PageController pageController = PageController(initialPage: 0);

  onPageChanged(page) {
    currentPage = page;
    setState(() {});
  }

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.sliderItems.length; i++) {
      list.add(
          i == currentPage ? const CustomIndicator(true) : const CustomIndicator(false));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (AppConfig.currentThemeId == asayelThemeId) {
      return AsayelSliderWidget(
          sliderItems: widget.sliderItems,
          hideDots: widget.hideDots,
          textColor: widget.textColor,
          backgroundColor: widget.backgroundColor);
    }
    return GetBuilder<MainLogic>(
        //  id: "slider",
        init: Get.find<MainLogic>(),
        builder: (logic) {
          return logic.isHomeLoading
              ? Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 180.h,
                  ))
              : GetBuilder<HomeLogic>(
                  init: Get.find<HomeLogic>(),
                  builder: (homeLogic) {
                    if (!AppConfig.isSoreUseNewTheme) {
                      widget.sliderItems = logic.slider?.items ?? [];
                    }
                    return !homeLogic.sliderDisplay || widget.sliderItems.isEmpty
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppConfig.paddingBetweenWidget),
                            child: widget.sliderItems.length == 1
                                ? buildSliderItem(0, true)
                                : AspectRatio(
                                    aspectRatio: AppConfig.sliderAspectRatio,
                                    child: Stack(
                                      children: [
                                        PageView.builder(
                                          onPageChanged: onPageChanged,
                                          itemCount: widget.sliderItems.length,
                                          itemBuilder: (context, index) =>
                                              buildSliderItem(index, false),
                                          controller: pageController,
                                          physics: const ClampingScrollPhysics(),
                                        ),
                                        if (!widget.hideDots)
                                          PositionedDirectional(
                                            start: 0,
                                            end: 0,
                                            bottom: 12,
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: buildPageIndicator(),
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                          );
                  });
        });
  }

  void startLoop() async {
    if (loopStarted) return;
    loopStarted = true;
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage < widget.sliderItems.length) {
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

  buildSliderItem(int index, bool free) {
    var sliderItem = widget.sliderItems[index];
    late VideoPlayerController? _controller;
    late YoutubePlayerController? _youtubeController;
    if (sliderItem.type == 'video' && sliderItem.link?.contains('youtube.com') == false) {
      _controller = VideoPlayerController.network(sliderItem.link ?? '')
        ..initialize().then((value) => null);
      _controller.play();
    } else if (sliderItem.type == 'video' &&
        sliderItem.link?.contains('youtube.com') == true) {
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: y.YoutubePlayer.convertUrlToId(sliderItem.link ?? '') ?? '',
        startSeconds: 10,
        params: const YoutubePlayerParams(
          // startAt: Duration(seconds: 10),
          showControls: true,
          showFullscreenButton: true,
        ),
      );
    }
    return GestureDetector(
      onTap: () => goToLink(sliderItem.link ?? ''),
      child: Stack(
        children: [
          sliderItem.type != 'video'
              ? CustomImage(
                  url: sliderItem.mobileImage ?? sliderItem.image,
                  width: double.infinity,
                  height: free
                      ? (sliderItem.mobileImage ?? sliderItem.image)?.contains('svg') ==
                              true
                          ? Get.width / 2.33
                          : null
                      : double.infinity,
                  size: 80,
                  showErrorImage: false,
                  fit: AppConfig.sliderFit,
                )
              : sliderItem.link?.contains('youtube.com') == true
                  ? YoutubePlayer(controller: _youtubeController!, gestureRecognizers: {}
                      //  showVideoProgressIndicator: true,
                      )
                  : VideoPlayer(_controller!),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (sliderItem.title != null)
                  CustomText(
                    sliderItem.title,
                    textAlign: TextAlign.center,
                    color: HexColor.fromHex(
                        widget.textColor ?? sliderItem.textColor ?? '#000000'),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                if (sliderItem.des != null || sliderItem.subtitle != null)
                  CustomText(
                    sliderItem.des ?? sliderItem.subtitle,
                    textAlign: TextAlign.center,
                    color: HexColor.fromHex(
                        widget.textColor ?? sliderItem.textColor ?? '#000000'),
                    fontSize: 14,
                  ),
                if ((AppConfig.currentThemeId == perfectThemeId &&
                        sliderItem.url != null) ||
                    sliderItem.btnText != null)
                  true
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.backgroundColor == null
                                ? primaryColor
                                : HexColor.fromHex(widget.backgroundColor ?? '#000000'),
                          ),
                          onPressed: () => goToLink(sliderItem.url),
                          child: CustomText(
                            sliderItem.btnText ?? '',
                            fontSize: 14,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            color: HexColor.fromHex(
                                widget.textColor ?? sliderItem.textColor ?? '#ffffff'),
                          ),
                        )
                      : CustomButtonWidget(
                          title: sliderItem.btnText ?? '',
                          width: 15 + (sliderItem.btnText!.length * 15),
                          height: null,
                          textSize: 12,
                          color: widget.backgroundColor == null
                              ? primaryColor
                              : HexColor.fromHex(widget.backgroundColor ?? '#000000'),
                          textColor: HexColor.fromHex(
                              widget.textColor ?? sliderItem.textColor ?? '#ffffff'),
                          onClick: () => goToLink(sliderItem.url))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
