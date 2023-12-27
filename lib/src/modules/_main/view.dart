import 'dart:core';
import 'dart:developer';
import 'dart:math' as math;

import 'package:entaj/src/modules/_main/widgets/bonat_widget.dart';
import 'package:entaj/src/modules/_main/widgets/plugin_chatbot.dart';
import 'package:entaj/src/modules/_main/widgets/plugin_livechat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_version/new_version.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uni_links/uni_links.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../main.dart';
import '../../app_config.dart';
import '../../colors.dart';
import '../../images.dart';
import '../../utils/functions.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import 'logic.dart';
import 'widgets/bonat_item.dart';
import 'widgets/my_bottom_nav.dart';
import 'widgets/my_drawer.dart';
import 'widgets/plugin_tidio.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

enum Availability { loading, available, unavailable }

class _MainPageState extends State<MainPage> {
  final MainLogic logic = Get.find();
  bool isLoading = true;

  get button => null;

  @override
  void initState() {
    super.initState();
    OneSignal.shared.setNotificationOpenedHandler(_handleNotificationOpened);
    checkNewAppVersion();
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    linkStream.listen((String? link) {
      goToLink(link,whenLaunchApp: true);
    }, onError: (err) {
      log('linkStream onError $err');
    });
  }

  void _handleNotificationOpened(OSNotificationOpenedResult result) {
    var additionalData = result.notification.additionalData;
    if (additionalData != null) {
      if (additionalData.containsKey("url")) {
        goToLink(result.notification.additionalData?['url'], whenLaunchApp: true);
      }
    }
  }

  void checkNewAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final newVersion = NewVersion(
      iOSId: packageInfo.packageName,
      androidId: packageInfo.packageName,
    );
    basicStatusCheck(newVersion);
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  bool showGradient = false;
  int removeType = 1;
  WebViewController controllerTidio = WebViewController();
  WebViewController controllerLiveChat = WebViewController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(builder: (logic) {
      return Stack(
        children: [
          Scaffold(
            backgroundColor: homeBackgroundColor,
            drawer: const MyDrawer(),
            appBar: logic.showAppBar || logic.tidioChatHeight != 0
                ? AppBar(
                    backgroundColor: headerBackgroundColor,
                    foregroundColor: headerForegroundColor,
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: isArabicLanguage
                            ? Image.asset(iconMenu,
                                scale: 2, color: headerForegroundColor)
                            : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: Image.asset(iconMenu,
                                    scale: 2, color: headerForegroundColor),
                              ),
                        alignment: AlignmentDirectional.centerStart,
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    actions: [
                      if (logic.navigatorValue == 0 &&
                          AppConfig.showBonatInAppBar &&
                          AppConfig.showBonatFromRemoteConfig &&
                          AppConfig.showBonat)
                        const BonatItem(),
                      InkWell(
                          onTap: () => logic.goToSearch(),
                          child: Image.asset(iconSearch,
                              scale: 2, color: headerForegroundColor)),
                    ],
                    title: Image.asset(
                      iconLogoAppBarCenter,
                      height: AppConfig.logoSizeInApBarHeight,
                      width: AppConfig.logoSizeInApBarWidth,
                      color: headerLogoColor,
                    ))
                : null,
            body: Stack(
              children: [
                logic.currentScreen,
                if (AppConfig.showTidio)
                  SizedBox(height: logic.tidioChatHeight, child: const PluginTidio()),
                if (AppConfig.showLiveChat)
                  SizedBox(height: logic.liveChatHeight, child: const PluginLiveChat()),
                if (AppConfig.showChatBot)
                  SizedBox(height: logic.chatBotHeight, child: const PluginChatBot()),
              ],
            ),
            bottomNavigationBar: const MyBottomNavigation(
              backCount: 0,
            ),
          ),
          if (showGradient)
            AnimatedSize(
              duration: const Duration(milliseconds: 0),
              curve: Curves.easeInOut,
              child: Container(
                width: double.infinity,
                height: showGradient ? double.infinity : 0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.7)
                    ])),
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white, width: 1.5)),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          PositionedDirectional(
            start: 10,
            bottom: 110,
            child: Column(
              children: [
                if (AppConfig.showTidioFromRemoteConfig &&
                    AppConfig.showTidio &&
                    logic.liveChatHeight == 0)
                  Material(
                    color: Colors.transparent,
                    child: Draggable(
                      onDragStarted: () {
                        removeType = 1;
                        showGradient = true;
                        setState(() {});
                      },
                      onDragEnd: (details) {
                        showGradient = false;
                        if (details.offset.dx > 130 && details.offset.dx < 210) {
                          if (details.offset.dy > (Get.height - 150) &&
                              details.offset.dx < (Get.height - 200)) {
                            logic.hideTidioIcon(removeType);
                          }
                        }
                        setState(() {});
                      },
                      onDraggableCanceled: (velocity, offset) {},
                      feedback: Material(
                          color: Colors.transparent, child: tidioChatIcon(logic)),
                      child: tidioChatIcon(logic),
                    ),
                  ),
                if (AppConfig.showLiveChatFromRemoteConfig &&
                    AppConfig.showLiveChat &&
                    logic.tidioChatHeight == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: Draggable(
                        onDragStarted: () {
                          removeType = 2;
                          showGradient = true;
                          setState(() {});
                        },
                        onDragEnd: (details) {
                          showGradient = false;
                          if (details.offset.dx > 130 && details.offset.dx < 210) {
                            if (details.offset.dy > (Get.height - 150) &&
                                details.offset.dx < (Get.height - 200)) {
                              logic.hideTidioIcon(removeType);
                            }
                          }
                          setState(() {});
                        },
                        onDraggableCanceled: (velocity, offset) {},
                        feedback: Material(
                            color: Colors.transparent, child: liveChatIcon(logic)),
                        child: liveChatIcon(logic),
                      ),
                    ),
                  ),
                if (AppConfig.showChatBotRemoteConfig &&
                    AppConfig.showChatBot &&
                    logic.chatBotHeight == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: Draggable(
                        onDragStarted: () {
                          removeType = 3;
                          showGradient = true;
                          setState(() {});
                        },
                        onDragEnd: (details) {
                          showGradient = false;
                          if (details.offset.dx > 130 && details.offset.dx < 210) {
                            if (details.offset.dy > (Get.height - 150) &&
                                details.offset.dx < (Get.height - 200)) {
                              logic.hideTidioIcon(removeType);
                            }
                          }
                          setState(() {});
                        },
                        onDraggableCanceled: (velocity, offset) {},
                        feedback: Material(
                            color: Colors.transparent, child: chatBotIcon(logic)),
                        child: chatBotIcon(logic),
                      ),
                    ),
                  ),
                if (AppConfig.showWhatsAppHome)
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: GlobalFloatingWhatsApp(),
                  )
              ],
            ),
          ),
          if (AppConfig.showBonat)
            SizedBox(height: logic.bonatHeight, child: const BonatWidget()),
        ],
      );
    });
  }

  tidioChatIcon(MainLogic logic) {
    return SizedBox(
      height: logic.tidioChatHeight == 0 ? null : 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'tidio',
            backgroundColor: primaryColor,
            child: const Icon(
              Icons.message,
              color: Colors.white,
            ),
            onPressed: () => logic.openTidioChat(),
          ),
        ],
      ),
    );
  }

  liveChatIcon(MainLogic logic) {
    return SizedBox(
      height: logic.liveChatHeight == 0 ? null : 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'livechat',
            backgroundColor: const Color.fromRGBO(32, 0, 240, 1),
            child: const Icon(
              Icons.message,
              color: Colors.white,
            ),
            onPressed: () => logic.openLiveChat(),
          ),
        ],
      ),
    );
  }

  chatBotIcon(MainLogic logic) {
    return SizedBox(
      height: logic.chatBotHeight == 0 ? null : 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'chatbot',
            backgroundColor: Colors.black,
            child: const Icon(
              Icons.message,
              color: Colors.white,
            ),
            onPressed: () => logic.openChatBot(),
          ),
        ],
      ),
    );
  }
}
