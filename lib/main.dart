import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uni_links/uni_links.dart';

import 'src/.env.dart';
import 'src/app_config.dart';
import 'src/binding.dart';
import 'src/colors.dart';
import 'src/data/hive/wishlist/wishlist_model.dart';
import 'src/data/shared_preferences/pref_manger.dart';
import 'src/localization/translations.dart';
import 'src/modules/category_details/view.dart';
import 'src/modules/product_details/view.dart';
import 'src/splash/view.dart';
import 'src/utils/dismiss_keyboard.dart';
import 'src/utils/notification_helper.dart';

bool isArabicLanguage = true;
bool isWeb = false;
late FirebaseRemoteConfig remoteConfig;
String? notificationUrl;
String versionNumber = '1.4.7+8';

NotificationHelper notificationHelper = NotificationHelper();

void main() async {
  isWeb = kIsWeb;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: !isWeb
          ? null
          : const FirebaseOptions(
              apiKey: "AIzaSyDZ6_ApxbKJC1jh8t7fiHqt1xkF0LDr3lQ",
              authDomain: "entaj-99888.firebaseapp.com",
              projectId: "entaj-99888",
              storageBucket: "entaj-99888.appspot.com",
              messagingSenderId: "849666711107",
              appId: "1:849666711107:web:c8a91b730771b4b4af3ef6",
              measurementId: "G-DE03DT8PYL"));
  await Hive.initFlutter();
  await Hive.openBox('general_box');

  try {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  } catch (e) {}

  await getRemoteConfigValues();

  if (AppConfig.isEnglishLanguageEnable) {
    isArabicLanguage = await PrefManger().getIsArabic();
  }
  if (AppConfig.isEnableWishlist) {
    Hive.registerAdapter(WishlistModelAdapter());
    await Hive.openBox<WishlistModel>('wishlist_box');
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Binding().dependencies();

  OneSignal.shared.setAppId(OneSignalAppId);
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    log("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationOpenedHandler(_handleNotificationOpened);
  notificationHelper.initializeNotification().then((value) async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await notificationHelper.flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    String? payload =
        notificationAppLaunchDetails?.notificationResponse?.payload;

    if (payload == 'cart') {
      notificationUrl = 'cart';
    }
  });

  initUniLinks();
  runApp(const MyApp());
}

Future<void> getRemoteConfigValues() async {
  remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(minutes: 1),
  ));
  await remoteConfig.ensureInitialized();
  try {
    await remoteConfig.fetchAndActivate();
    remoteConfig.getAll().forEach((key, value) {
      log('$key ==> ${value.asString()}');
    });
    AppConfig.abandonedCartHoursCount = remoteConfig.getInt(ABANDONED_CART_KEY);
    AppConfig.abandonedCartNotificationTextAr =
        remoteConfig.getString(ABANDONED_CART_NOTIFICATION_TEXT_AR_KEY);
    AppConfig.abandonedCartNotificationTextEn =
        remoteConfig.getString(ABANDONED_CART_NOTIFICATION_TEXT_EN_KEY);
    AppConfig.showWhatsAppIconInProductPage =
        remoteConfig.getString(WA_PRODUCT_KEY).isNotEmpty;
    AppConfig.showWhatsApp = remoteConfig.getBool(WA_ACCOUNT_ENABLE_KEY);
    AppConfig.showBonatFromRemoteConfig = remoteConfig.getBool(BONAT_KEY);
    AppConfig.showTidioFromRemoteConfig = remoteConfig.getBool(TIDIO_KEY);
    AppConfig.showLiveChatFromRemoteConfig = remoteConfig.getBool(LIVECHAT_KEY);
    AppConfig.showWhatsAppRemoteConfig =
        remoteConfig.getBool(SHOW_WHATSAPP_KEY);
    AppConfig.multiInventoryVersion =
        remoteConfig.getBool(IS_MULTI_INVENTORY_ENABLE_KEY);
    AppConfig.showGBAllApp = remoteConfig.getBool(GB_All_App_KEY);
    AppConfig.disableApplePay = remoteConfig.getBool(DISABLE_APPLE_PAY);
    AppConfig.showTrustPaymentFromRemoteConfig = remoteConfig.getBool(TRUST_PAYMENT_FORM_PRODUCT);
    AppConfig.giftCartEnable = remoteConfig.getBool(HIDE_CART_GIFT_KEY) != true;

  } catch (e) {}
}

Future<void> initUniLinks() async {
  try {
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      notificationUrl = initialLink;
    }
  } on PlatformException {}
}

void _handleNotificationOpened(OSNotificationOpenedResult result) {
  var additionalData = result.notification.additionalData;
  if (additionalData != null) {
    if (additionalData.containsKey("url")) {
      notificationUrl = result.notification.additionalData?['url'];
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        designSize: const Size(375, 812),
        builder: (context, widget) => GetMaterialApp(
          builder: (context, widget) {
            //add this line
            ScreenUtil.init(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
          ],
          debugShowCheckedModeBanner: false,
          title: isArabicLanguage ? appNameAr : appNameEn,
          locale: Locale(isArabicLanguage ? 'ar' : 'en'),
          fallbackLocale: Locale(isArabicLanguage ? 'ar' : 'en'),
          initialBinding: Binding(),
          translations: Translation(),
          theme: ThemeData(
              fontFamily: AppConfig.fontName,
              //   textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
              primarySwatch: mainColor,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
              )),
          getPages: [
            GetPage(
                name: '/product-details/:productId',
                page: () => ProductDetailsPage()),
            GetPage(
                name: '/category-details/:categoryId',
                page: () => const CategoryDetailsPage()),
          ],
          home: widget,
        ),
        child: const SplashPage(),
      ),
    );
  }
}
