import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../colors.dart';
import '../../images.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/validation/validation.dart';
import '../_main/logic.dart';
import 'logic.dart';

class StoreClosePage extends StatelessWidget {
  const StoreClosePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<MainLogic>(
          init: Get.find<MainLogic>(),
          builder: (logic) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    CircleAvatar(
                        radius: 80,
                        backgroundColor: primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(iconStoreClosed),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomText(
                      isArabicLanguage
                          ? logic
                              .settingModel?.settings?.availability?.title?.ar
                          : logic
                              .settingModel?.settings?.availability?.title?.en,
                      color: Colors.grey.shade800,
                      fontSize: 18,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomText(
                      isArabicLanguage
                          ? logic
                              .settingModel?.settings?.availability?.message?.ar
                          : logic.settingModel?.settings?.availability?.message
                              ?.en,
                      color: Colors.grey.shade800,
                      textAlign: TextAlign.center,
                      fontSize: 14,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (logic.settingModel?.settings?.availability
                            ?.isTimeCounterDisplayed ==
                        true)
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            child: Column(
                              children: [
                                if (logic.settingModel?.settings?.availability
                                        ?.activatingData?.date !=
                                    null)
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: CountdownTimer(
                                      widgetBuilder:
                                          (_, CurrentRemainingTime? time) {
                                        if (time == null) {
                                          return const Text('');
                                        }
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                CustomText(
                                                  daysToMonths(
                                                          time.days ?? 0)[0]
                                                      .toString(),
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                CustomText('شهر'.tr)
                                              ],
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              children: [
                                                CustomText(
                                                  daysToMonths(
                                                          time.days ?? 0)[1]
                                                      .toString(),
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                CustomText('يوم'.tr)
                                              ],
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              children: [
                                                CustomText(
                                                  (time.hours ?? 0).toString(),
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                CustomText('ساعة'.tr)
                                              ],
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              children: [
                                                CustomText(
                                                  (time.min ?? 0).toString(),
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                CustomText('دقيقة'.tr)
                                              ],
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              children: [
                                                CustomText(
                                                  (time.sec ?? 0).toString(),
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                CustomText('ثانية'.tr)
                                              ],
                                            ),
                                          ],
                                        );
                                        return Text(
                                            'days: [ ${time.days} ], hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
                                      },
                                      endTime: DateTime.parse(logic
                                                      .settingModel
                                                      ?.settings
                                                      ?.availability
                                                      ?.activatingData
                                                      ?.date ??
                                                  '')
                                              .millisecondsSinceEpoch +
                                          1000 * 30,
                                    ),
                                  )
                              ],
                            ),
                          ),
                          PositionedDirectional(
                            start: 20,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              color: Colors.white,
                              child: CustomText(
                                'يفتح المتجر بعد'.tr,
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    GetBuilder<StoreCloseLogic>(
                        init: Get.put(StoreCloseLogic()),
                        builder: (logic) {
                          return Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: TextFormField(
                                        controller: logic.closeEmailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: Validation.emailValidate,
                                        style: const TextStyle(fontSize: 12),
                                        decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                            hintText: "البريد الإلكتروني".tr),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                        flex: 1,
                                        child: CustomButtonWidget(
                                            title: 'ارسال'.tr,
                                            radius: 5,
                                            loading: logic.isLoading,
                                            onClick: () =>
                                                logic.addAvailability()))
                                  ],
                                ),
                              ),
                              PositionedDirectional(
                                start: 20,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  color: Colors.white,
                                  child: CustomText(
                                    'نبهني عند توفر المتجر'.tr,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                  ],
                ),
              ),
            );
          }),
    );
  }

/*
  int daysToMonths(int days) {
    double daysPerMonth = 365.2425 / 12;
    int months = (days / daysPerMonth).floor();
    int remainingDays = (days % daysPerMonth).round();

    if (remainingDays > 0) {
      months += 1;
    }

    return months;
  }
*/

  List<int> daysToMonths(int days, {double daysPerMonth = 365.2425 / 12}) {
    int months = days ~/ daysPerMonth;
    int remainingDays = (days % daysPerMonth).ceil();

    return [months, remainingDays];
  }
}
