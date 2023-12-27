import 'dart:async';

import 'package:entaj/src/.env.dart';

import '../../../entities/product_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../data/hive/wishlist/hive_controller.dart';
import '../../../data/hive/wishlist/wishlist_model.dart';
import '../../../data/shared_preferences/pref_manger.dart';
import '../../../services/app_events.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_indicator.dart';

import '../../_auth/login/view.dart';
import '../logic.dart';

class SliderWidget extends StatefulWidget {
  final String productId;
  List<Images> sliderItems;

  SliderWidget({required this.productId,required this.sliderItems, Key? key}) : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  final LoopPageController pageController = LoopPageController(initialPage: 0);
  final PrefManger _prefManger = Get.find();
  bool loopStarted = false;
  bool clicked = false;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (AppConfig.currentThemeId != asayelThemeId) startLoop();
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

  onPageChanged(page) {
    currentPage = page;
    setState(() {});
  }

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.sliderItems.length; i++) {
      list.add(i == currentPage ? const CustomIndicator(true) : const CustomIndicator(false));
    }
    return list;
  }

  changedPage(int indexOf) {
    pageController.jumpToPage(indexOf);
    onPageChanged(indexOf);
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsLogic>(
        tag:widget. productId,
        init: Get.find<ProductDetailsLogic>(tag: widget.productId),
        id: widget.productId,
        builder: (logic) {

          var sliderItems = logic.productModel?.images ?? [];

          return AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  bottom: 0,
                  top: 0,
                  child: widget.sliderItems.isEmpty
                      ? const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: CustomImage(
                      url: "",
                      width: double.infinity,
                      size: 50,
                    ),
                  )
                      : LoopPageView.builder(
                    onPageChanged: onPageChanged,
                    itemCount: widget.sliderItems.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => logic.goToImages(logic.productModel?.images, index),
                        child: CustomImage(
                          url: widget.sliderItems[index].image?.fullSize ?? '',
                          width: double.infinity,
                          size: 80,
                          fit: BoxFit.contain,
                        )
                        //  showVideoProgressIndicator: true,
                        ,
                      );
                    },
                    controller: pageController,
                    physics: const ClampingScrollPhysics(),
                  ),
                ),

                AppConfig.currentThemeId == asayelThemeId ?
                PositionedDirectional(
                  start: 16,
                  bottom: 100,
                  top: sliderItems.length > 4 ? 50 : null,
                  height: sliderItems.length < 5
                      ? (sliderItems.length * 46) + 4
                      : null,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    width: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color:  Colors.grey.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8)),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children:  sliderItems
                          .map((e) => GestureDetector(
                        onTap: () => changedPage(sliderItems.indexOf(e)),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: currentPage != sliderItems.indexOf(e)
                                    ? Colors.transparent
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.only(bottom: 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomImage(
                              url: e.image?.small,
                              fit: BoxFit.cover,
                              height: 40,
                            ),
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ):const SizedBox(),
                if (AppConfig.isEnableWishlist)
                  PositionedDirectional(
                      start: 10.sp,
                      width: 40.sp,
                      height: 40.sp,
                      bottom: 9.sp,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(100.sp)),
                      )),
                if (AppConfig.isEnableWishlist)
                  PositionedDirectional(
                      start: -30.sp,
                      width: 120.sp,
                      height: 120.sp,
                      bottom: -31.5.sp,
                      child: GestureDetector(
                        onTap: () async {
                          if (!await _prefManger.getIsLogin()) {
                            Get.to(LoginPage());
                            return;
                          }
                          final AppEvents _appEvents = Get.find();

                          _appEvents.logAddToWishlist(logic.productModel?.name,
                              logic.productModel?.id, logic.productModel?.price);
                          var model = WishlistModel(
                            productId: logic.productModel?.id,
                            productName: logic.productModel?.name,
                            productImage: logic.productModel?.images?.isNotEmpty == true
                                ? (logic.productModel?.images?[0].image?.small)
                                : null,
                            productQuantity: logic.productModel?.quantity ?? 1,
                            productPrice: logic.productModel?.price ?? 0,
                            productSalePrice: logic.productModel?.salePrice ?? 0,
                            productFormattedPrice: logic.productModel?.formattedPrice,
                            productFormattedSalePrice: logic.productModel?.formattedSalePrice,
                            productHasFields: logic.productModel?.hasFields ?? false,
                            productHasOptions: logic.productModel?.hasOptions ?? false,
                          );
                          if (HiveController.getWishlist().get(logic.productModel?.id) == null) {
                            await HiveController.getWishlist().put(logic.productModel?.id, model);
                            clicked = true;
                            setState(() {});
                          } else {
                            await HiveController.getWishlist().delete(logic.productModel?.id);
                            setState(() {});
                          }
                        },
                        child: !clicked
                            ? Icon(
                          Icons.favorite,
                          size: 20.sp,
                          color:
                          HiveController.getWishlist().get(logic.productModel?.id) == null
                              ? Colors.grey.shade400
                              : moveColor,
                        )
                            : Lottie.asset('assets/images/lf30_editor_omnqgnhv.json',
                            onLoaded: (LottieComposition l) {
                              Future.delayed(
                                  Duration(milliseconds: l.duration.inMilliseconds - 1500))
                                  .then((value) {
                                clicked = false;
                                setState(() {});
                              });
                            }, repeat: false, animate: true),
                      )),
                PositionedDirectional(
                    bottom: 5,
                    start: 0,
                    end: 0,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: buildPageIndicator(),
                      ),
                    ))
              ],
            ),
          );
        });
  }
}
