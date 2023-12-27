import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_config.dart';
import '../../colors.dart';
import '../../images.dart';
import '../../services/app_events.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import '../../utils/item_widget/item_order.dart';
import 'logic.dart';

class OrdersPage extends StatelessWidget {
  final OrdersLogic logic = Get.put(OrdersLogic());
  final AppEvents _appEvents = Get.find();

  OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _appEvents.logScreenOpenEvent('OrdersTab');
    logic.selected = null;
    logic.getOrders();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: AppConfig.showGBAllApp ? GlobalFloatingWhatsApp() : null,
      appBar: AppBar(
        backgroundColor: headerBackgroundColor,
        foregroundColor: headerForegroundColor,
        title: CustomText(
          "طلباتي".tr,
          fontSize: 16,
          color: headerForegroundColor,
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
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => logic.getOrders(),
              child: SizedBox(
                height: Get.height,
                child: Column(
                  children: [
                    GetBuilder<OrdersLogic>(
                        builder: (logic) => !logic.isLogin
                            ? Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 500.h,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(left: 50, right: 50),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 100.h,
                                      ),
                                      Image.asset(
                                        iconLogoFull,
                                        color: iconLogoFullColor,
                                        height: AppConfig.logoSizeInAccount.h,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      SizedBox(
                                        height: 40.h,
                                      ),
                                      CustomButtonWidget(
                                        title: "تسجيل / دخول مستخدم".tr,
                                        onClick: () => logic.goToLogin(),
                                        color: greenLightColor,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : logic.loading
                                ? const CustomProgressIndicator()
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                                    child: logic.orderList.isEmpty
                                        ? const SizedBox()
                                        : buildDropdownButton(logic),
                                  )),
                    const SizedBox(
                      height: 15,
                    ),
                    GetBuilder<OrdersLogic>(builder: (logic) {
                      return Expanded(
                          child: logic.loading
                              ? Shimmer.fromColors(
                                  baseColor: baseColor,
                                  highlightColor: highlightColor,
                                  child: ListView.builder(
                                      itemCount: 20,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) =>
                                          ItemOrder(index, null)))
                              : logic.orderList.isEmpty && logic.isLogin
                                  ? Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(left: 50, right: 50),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            iconOrders,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          CustomText(
                                            "لا يوجد لديك طلبات سابقة".tr,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: logic.orderList.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) =>
                                          ItemOrder(index, logic.orderList[index])));
                    })
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  DropdownButtonHideUnderline buildDropdownButton(OrdersLogic logic) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        iconStyleData: const IconStyleData(
          iconSize: 0,
        ),
        menuItemStyleData: MenuItemStyleData(padding: EdgeInsets.zero, height: 60.h),
        dropdownStyleData: DropdownStyleData(
            padding: EdgeInsets.zero,
            scrollbarTheme: ScrollbarThemeData(
                thumbVisibility: MaterialStateProperty.all<bool>(true),
                trackVisibility: MaterialStateProperty.all(true),
                thickness: MaterialStateProperty.all<double>(0))),
        isExpanded: true,
        selectedItemBuilder: (con) {
          return logic.orderStatusList.map((selectedType) {
            return Container(
                height: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15.sp)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        selectedType,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ));
          }).toList();
        },
        hint: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15.sp)),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Image.asset(
                iconOrders,
                scale: 2,
                color: primaryColor,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                "طلباتي".tr,
                color: primaryColor,
              ),
              const Spacer(),
              const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
              )
            ],
          ),
        ),
        onChanged: (newValue) {
          logic.setSelected(newValue);
        },
        value: logic.selected,
        items: logic.orderStatusList.map((selectedType) {
          return DropdownMenuItem(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomText(
                    selectedType,
                    textAlign: TextAlign.center,
                    fontSize: 10,
                    color: dropdownTextColorNew,
                  ),
                ),
                const Spacer(),
                if (selectedType !=
                    logic.orderStatusList[logic.orderStatusList.length - 1])
                  Container(
                    height: 1,
                    color: dropdownDividerLineColor,
                  )
              ],
            ),
            value: selectedType,
          );
        }).toList(),
      ),
    );
  }
}
