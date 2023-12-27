import '../../../../main.dart';
import '../../../app_config.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../colors.dart';
import '../../../images.dart';
import '../../cart/logic.dart';
import '../logic.dart';

class MyBottomNavigation extends StatelessWidget {
  final int backCount;

  const MyBottomNavigation({Key? key, required this.backCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(builder: (logic) {
      double iconSize = isWeb?40: 20.sp;
      return Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                backgroundColor: bottomBackgroundColor,
                unselectedItemColor: bottomUnselectedIconColor,
                selectedItemColor: bottomSelectedIconColor,
                elevation: 50,
                currentIndex: logic.navigatorValue,
                selectedLabelStyle: TextStyle(
                    fontSize: (10 + AppConfig.fontDecIncValue).sp, overflow: TextOverflow.ellipsis),
                unselectedLabelStyle: TextStyle(
                    fontSize: (10 + AppConfig.fontDecIncValue).sp, overflow: TextOverflow.ellipsis),
                onTap: (index) => logic.changeSelectedValue(index, true, backCount: backCount),
                items: [
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 5.h),
                        child: Image.asset(
                          iconHome,
                          width: iconSize,
                          height: iconSize,
                          color: logic.navigatorValue == 0
                              ? bottomSelectedIconColor
                              : bottomUnselectedIconColor,
                        ),
                      ),
                      label: "المتجر".tr),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 5.h),
                        child: Image.asset(
                          iconCategories,
                          width: iconSize,
                          height: iconSize,
                          color: logic.navigatorValue == 1
                              ? bottomSelectedIconColor
                              : bottomUnselectedIconColor,
                        ),
                      ),
                      label: AppConfig.categoriesName.tr),
                  BottomNavigationBarItem(
                      icon: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: Center(
                              child: Image.asset(
                                iconCart,
                                width: iconSize,
                                height: iconSize,
                                color: logic.navigatorValue == 2
                                    ? bottomSelectedIconColor
                                    : bottomUnselectedIconColor,
                              ),
                            ),
                          ),
                          GetBuilder<CartLogic>(
                              init: Get.find<CartLogic>(),
                              id: 'cart',
                              builder: (logic) {
                                if ((logic.cartModel?.productsCount ?? 0) > 0) {
                                  return Positioned(
                                    top: 0.0,
                                    left: logic.cartModel!.productsCount! > 99 ? 10.w : 18.0.w,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: moveColor,
                                            borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: CustomText(
                                          logic.cartModel!.productsCount.toString(),
                                          fontSize: 10,
                                          color: Colors.white,
                                        )),
                                  );
                                }
                                return const SizedBox();
                              })
                        ],
                      ),
                      label: "السلة".tr),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 5.h),
                        child: Icon(
                          Icons.favorite,
                          size: iconSize,
                          color: logic.navigatorValue == 3
                              ? bottomSelectedIconColor
                              : bottomUnselectedIconColor,
                        ),
                      ),
                      label: "المفضلة".tr),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 5.h),
                        child: Image.asset(
                          iconAccount,
                          width: iconSize,
                          height: iconSize,
                          color: logic.navigatorValue == 4
                              ? bottomSelectedIconColor
                              : bottomUnselectedIconColor,
                        ),
                      ),
                      label: "حسابي".tr),
                ],
              ),
      );
    });
  }
}
