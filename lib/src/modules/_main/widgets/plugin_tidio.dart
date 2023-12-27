import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../.env.dart';
import '../logic.dart';

class PluginTidio extends StatelessWidget {
  const PluginTidio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(
        init: Get.find<MainLogic>(),
        id: "chat",
        builder: (logic) {
          return SizedBox(
            height: 200,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: Stack(
                  children: [
                    WebViewWidget(
                      controller: logic.controllerTidio,
                    ),
                    if (logic.isTidioLoading)
                      Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator()),
                    Positioned(
                      left: 1,
                      top: 1,
                      child: Container(
                        height: 80,
                        width: 50,
                        color: Colors.transparent,
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 18,
                      child: InkWell(
                        onTap: () => logic.openTidioChat(),
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
