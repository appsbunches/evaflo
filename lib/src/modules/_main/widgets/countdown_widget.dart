import 'dart:developer';

import 'package:entaj/src/app_config.dart';
import 'package:entaj/src/utils/custom_widget/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../colors.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';

class CountdownWidget extends StatelessWidget {
  final String? image;
  final String? countdownDate;

  const CountdownWidget({Key? key, this.image, this.countdownDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (countdownDate == null) return const SizedBox.shrink();
    int endTime =
        DateFormat('yyyy/M/d').parse(countdownDate!).millisecondsSinceEpoch + 1000 * 30;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: AppConfig.paddingBetweenWidget),
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(16), child: CustomImage(url: image)),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Center(
              child: CountdownTimer(
                endTime: endTime,
                widgetBuilder: (_, CurrentRemainingTime? time) {
                  if (time == null) {
                    return const Text('');
                  }
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /*Column(
                          children: [
                            CustomText(
                              daysToMonths(time.days ?? 0)[0].toString(),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              'شهر'.tr,
                              color: Colors.white,
                            )
                          ],
                        ),
                        const SizedBox(width: 8),*/
                        Column(
                          children: [
                            CustomText(
                              (time.days ?? 0).toString(),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              'يوم'.tr,
                              color: Colors.white,
                            )
                          ],
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            CustomText(
                              (time.hours ?? 0).toString(),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              'ساعة'.tr,
                              color: Colors.white,
                            )
                          ],
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            CustomText(
                              (time.min ?? 0).toString(),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              'دقيقة'.tr,
                              color: Colors.white,
                            )
                          ],
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            CustomText(
                              (time.sec ?? 0).toString(),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              'ثانية'.tr,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                  return Text(
                      'days: [ ${time.days} ], hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
