import 'dart:developer';

import 'package:entaj/src/modules/_main/logic.dart';
import 'package:entaj/src/modules/_main/view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../main.dart';
import '../.env.dart';
import '../app_config.dart';
import '../binding.dart';

class NotificationHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notification
  Future initializeNotification() async {
    await _configureLocalTimeZone();
    DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) async {
      log(id.toString());
      if (payload == 'cart') {
        Get.find<MainLogic>().changeSelectedValue(2, false, backCount: 0);
        Get.to(const MainPage(), binding: Binding());
      }
    });

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("mipmap/ic_launcher");

    InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (n) async {
      log(n.toString());
      if (n.payload == 'cart') {
        Get.find<MainLogic>().changeSelectedValue(2, false, backCount: 0);
        Get.to(const MainPage(), binding: Binding());
      }
    });
  }

  /// Set right date and time for notifications
  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  /// Scheduled Notification
  scheduledNotification() async {
    if ((AppConfig.abandonedCartNotificationTextAr ?? '').isEmpty) {
      await getRemoteConfigValues();
    }
    if (AppConfig.abandonedCartHoursCount == 0) return;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      isArabicLanguage ? appNameAr : appNameEn,
      isArabicLanguage
          ? AppConfig.abandonedCartNotificationTextAr
          : AppConfig.abandonedCartNotificationTextEn,
      tz.TZDateTime.now(tz.local)
          .add(Duration(minutes: AppConfig.abandonedCartHoursCount ?? 24)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'abandoned_cart',
          'abandoned_cart',
          channelDescription: '',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      //  matchDateTimeComponents: DateTimeComponents.time,
      payload: 'cart',
    );
  }

  /// Request IOS permissions
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  cancelAll() async => await flutterLocalNotificationsPlugin.cancelAll();

  cancel(id) async => await flutterLocalNotificationsPlugin.cancel(id);
}
