import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:entaj/src/entities/module_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';
import '../logic.dart';
import '../tabs/home/logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BannerSliderWidget extends StatelessWidget {
  final Settings? banner;

  const BannerSliderWidget({Key? key, required this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(builder: (logic) {
      return !(banner?.bannerSliders?.isNotEmpty == true)
          ? const SizedBox()
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: HexColor.fromHex(
                    banner?.announcementBarBackgroundColor ?? yalowColor.toHex()),
              ),
              width: double.infinity,
              child: CarouselSlider(
                items: banner?.bannerSliders
                        ?.map((e) => GestureDetector(
                              onTap: () => goToLink(e.link),
                              child: CustomText(
                                e.text?.replaceAll('\n', ' '),
                                color: HexColor.fromHex(
                                    banner?.announcementBarTextColor ??
                                        Colors.black.toHex()),
                                fontSize: 11,
                              ),
                            ))
                        .toList() ??
                    [],
                options: CarouselOptions(
                    autoPlay: true,
                    reverse: true,
                    height: (banner?.bannerHeight ?? 40) - 10,
                    autoPlayInterval: const Duration(seconds: 0),
                    autoPlayAnimationDuration: const Duration(seconds: 3),
                    autoPlayCurve:Curves.fastOutSlowIn,
                    enableInfiniteScroll: true),
              ),
            );
    });
  }
}
