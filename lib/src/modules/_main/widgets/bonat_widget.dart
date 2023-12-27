import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart' as webb;
import 'package:webview_flutter/webview_flutter.dart';

import '../logic.dart';

late webb.WebViewController bonatController = WebViewController();

class BonatWidget extends StatelessWidget {
  const BonatWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(
        init: Get.find<MainLogic>(),
        builder: (logic) {
          return logic.bonatUrl == null
              ? const SizedBox()
              : Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        logic.openBonat();
                      },
                    ),
                  ),
                  body: Stack(
                    children: [
                      Visibility(
                          visible: logic.isBonatLoading,
                          child: const Center(child: CircularProgressIndicator())),
                      Opacity(
                        opacity: !logic.isBonatLoading ? 1 : 0,
                        child: WebViewWidget(
                          controller: bonatController
                            ..loadRequest(Uri.parse(logic.bonatUrl ?? ''))
                            ..setJavaScriptMode(JavaScriptMode.unrestricted)
                            ..setNavigationDelegate(
                                NavigationDelegate(onPageFinished: (value) async {
/*                              try {
                                await bonatController.runJavaScript("""
                                    document.getElementById("bonat_iframe_box").style.display = null;
                                """);
                                Future.delayed(const Duration(milliseconds: 500))
                                    .then((value) => bonatController.runJavaScript("""
                                      document.getElementById("bonat_div").style.left="0px";
                                      """));
                              } catch (e) {}*/
                            })),
                        ),
                      ),
                    ],
                  ),
                );
        },
        id: 'bonat');
  }
}
