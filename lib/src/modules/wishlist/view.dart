import 'dart:math' as math;

import '../../../main.dart';
import '../../app_config.dart';
import '../../colors.dart';
import '../../data/shared_preferences/pref_manger.dart';
import '../../images.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/item_widget/item_product.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../_auth/login/view.dart';
import 'logic.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final WishlistLogic logic = Get.put(WishlistLogic());

  @override
  Widget build(BuildContext context) {
    logic.getProductsList();
    return Column(
      children: [
        AppBar(
          backgroundColor: headerBackgroundColor,
          leading: Builder(
            builder: (context) => IconButton(
              icon: isArabicLanguage
                  ? Image.asset(iconMenu, scale: 2, color: headerForegroundColor)
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child:
                          Image.asset(iconMenu, scale: 2, color: headerForegroundColor),
                    ),
              alignment: AlignmentDirectional.centerStart,
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: CustomText(
            "المفضلة".tr,
            color: headerForegroundColor,
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
        Expanded(
          child: FutureBuilder<bool>(
              future: PrefManger().getIsLogin(),
              builder: (context, snap) {
                return snap.data != true
                    ? Container(
                        width: double.infinity,
                        height: 500.h,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              iconLogoFull,
                              color: iconLogoFullColor,
                              height: AppConfig.logoSizeInAccount.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            CustomButtonWidget(
                              title: "تسجيل / دخول مستخدم".tr,
                              onClick: () => Get.to(LoginPage())?.then((value) {
                                setState(() {});
                              }),
                              color: greenLightColor,
                            )
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          logic.getProductsList();
                        },
                        child: SizedBox(
                          height: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: GetBuilder<WishlistLogic>(
                                    id: "products",
                                    builder: (context) {
                                      return logic.isProductsLoading
                                          ? const CustomProgressIndicator()
                                          : logic.productsList.isNotEmpty
                                              ? SingleChildScrollView(
                                                  physics:
                                                      const AlwaysScrollableScrollPhysics(),
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      GridView.builder(
                                                        itemCount:
                                                            logic.productsList.length,
                                                        padding:
                                                            const EdgeInsets.fromLTRB(
                                                                15, 10, 15, 0),
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount: 2,
                                                                crossAxisSpacing: 10,
                                                                mainAxisSpacing: 10,
                                                                childAspectRatio: AppConfig
                                                                    .productWishlistItemAspectRatio),
                                                        itemBuilder: (context, index) =>
                                                            ItemProduct(
                                                          logic.productsList[index],
                                                          backCount: 2,
                                                          horizontal: false,
                                                          forWishlist: true,
                                                        ),
                                                      ),
                                                      if (logic.isUnderLoading)
                                                        Container(
                                                          alignment: Alignment.center,
                                                          margin: const EdgeInsets.only(
                                                              bottom: 10),
                                                          child:
                                                              const CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.only(
                                                      left: 50, right: 50, bottom: 100),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.favorite,
                                                        color: Colors.grey,
                                                        size: 50.sp,
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      RichText(
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      AppConfig.fontName,
                                                                  color: Colors.grey,
                                                                  fontSize: (14 +
                                                                          AppConfig
                                                                              .fontDecIncValue)
                                                                      .sp),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      "لا يوجد منتجات في القائمة، أضف منتجات لقائمة التفضيل من خلال الضغط على أيقونة"
                                                                          .tr,
                                                                ),
                                                                const WidgetSpan(
                                                                    child: Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal: 4),
                                                                  child: Icon(
                                                                    Icons.favorite,
                                                                    color: moveColor,
                                                                  ),
                                                                )),
                                                                TextSpan(
                                                                    text:
                                                                        "في بطاقة المنتج"
                                                                            .tr),
                                                              ]))
                                                    ],
                                                  ),
                                                );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
              }),
        ),
      ],
    );
  }
}
/*
import '../../colors.dart';
import '../../data/hive/wishlist/hive_controller.dart';
import '../../data/shared_preferences/pref_manger.dart';
import '../../images.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../app_config.dart';
import '../../data/hive/wishlist/wishlist_model.dart';
import '../../utils/item_widget/item_wishlist.dart';
import '../_auth/login/view.dart';
import 'logic.dart';

class WishlistPage extends StatefulWidget {

  WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final WishlistLogic logic = Get.put(WishlistLogic());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.grey.shade50,
          foregroundColor: Colors.black,
          title: CustomText(
            "المفضلة".tr,
            fontSize: 16,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Image.asset(iconLogoText),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder<bool>(
              future: PrefManger().getIsLogin(),
              builder: (context, snap) {
                return snap.data != true
                    ? Container(
                        width: double.infinity,
                        height: 500.h,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           Image.asset(
                              iconLogo,
                              height: 85.h,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            CustomButtonWidget(
                              title: "تسجيل / دخول مستخدم".tr,
                              onClick: () => Get.to(LoginPage())?.then((value) {
                                setState(() {

                                });
                              }),
                              color: greenLightColor,
                            )
                          ],
                        ),
                      )
                    : ValueListenableBuilder<Box<WishlistModel>>(
                        valueListenable: HiveController.getWishlist().listenable(),
                        builder: (context, box, _) {
                          final wishlist = box.values.toList().cast<WishlistModel>();
                          if (wishlist.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 50, right: 50, bottom: 100),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.grey,
                                    size: 50.sp,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontFamily: AppConfig.fontName,
                                              color: Colors.grey,
                                              fontSize: (14 + AppConfig.fontDecIncValue).sp),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "لا يوجد منتجات في القائمة، أضف منتجات لقائمة التفضيل من خلال الضغط على أيقونة في بطاقة المنتج"
                                                      .tr,
                                            ),
                                            const WidgetSpan(
                                                child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 4),
                                              child: Icon(
                                                Icons.favorite,
                                                color: moveColor,
                                              ),
                                            )),
                                            TextSpan(text: "في بطاقة المنتج".tr),
                                          ]))
                                ],
                              ),
                            );
                          }
                          return Container(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: GridView.builder(
                              itemCount: wishlist.length,
                              padding: const EdgeInsets.only(bottom: 20),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.55),
                              itemBuilder: (context, index) => ItemWishlist(
                                wishlist[index],
                                index,
                                backCount: 1,
                              ),
                            ),
                          );
                        });
              }),
        ),
      ],
    );
  }
}
*/
