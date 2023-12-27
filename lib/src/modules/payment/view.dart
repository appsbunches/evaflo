import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_config.dart';
import '../../binding.dart';
import '../../colors.dart';
import '../../data/remote/api_requests.dart';
import '../../data/shared_preferences/pref_manger.dart';
import '../../images.dart';
import '../../utils/error_handler/error_handler.dart';
import '../delivery_option/view.dart';
import '../success_order/view.dart';

class PaymentScreen extends StatefulWidget {
  final String url;

  const PaymentScreen({Key? key, required this.url}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PrefManger _prefManger = Get.find();
  final ApiRequests _apiRequests = Get.find();


  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        applePayAPIEnabled: true,
        allowsInlineMediaPlayback: true,
      ));

  double progress = 0;
  String url = '';


  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) webb.WebView.platform = AndroidWebView();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      isLoading = !isLoading;
      setState(() {});
    });
    url = widget.url;
  }

  Future<void> getSession() async {
    try {
      var response = await _apiRequests.createSession();
      var session = response.data['payload']['cart_session_id'];
      log("new session => $session");
      await _prefManger.setSession(session);
      await _apiRequests.onInit();
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: headerBackgroundColor,
          foregroundColor: headerForegroundColor,
          title: Image.asset(
            iconLogoAppBarCenter,
            height: AppConfig.logoSizeInApBarHeight,
            width: AppConfig.logoSizeInApBarWidth,
            color: headerLogoColor,
          )),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
            initialOptions: options,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url!;
              log('url => $uri');
              if (uri.toString().contains('order-completed')) {
                var orderId = uri.toString().substring(
                    uri.toString().length - 18, uri.toString().length - 8);
                await getSession();
                Get.off(
                    SuccessOrderPage(
                      orderId: orderId,
                    ),
                    binding: Binding());
              }
              if (uri.toString().contains('cart/view')) {
                Get.back();
              }
              if (url.contains('shipping-and-payment')) {
                Get.to(DeliveryOptionPage(), binding: Binding());
                return NavigationActionPolicy.CANCEL;
              }
              if (![
                "http",
                "https",
                "file",
                "chrome",
                "data",
                "javascript",
                "about"
              ].contains(uri.scheme)) {
                if (await canLaunch(url)) {
                  // Launch the App
                  await launch(
                    url,
                  );
                  // and cancel the request
                  return NavigationActionPolicy.CANCEL;
                }
              }

              return NavigationActionPolicy.ALLOW;
            },
            onConsoleMessage: (controller, consoleMessage) {
              print(consoleMessage);
            },
          ),
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container(),
          if (isLoading)
            Visibility(
                visible: isLoading,
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                    child: const Center(child: CircularProgressIndicator()))),
        ],
      ),
    );
  }
}
