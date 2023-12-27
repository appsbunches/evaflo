import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../app_config.dart';
import '../../colors.dart';
import '../../images.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import '../_main/logic.dart';
import 'logic.dart';

class AboutUsPage extends StatelessWidget {
  final AboutUsLogic logic = Get.put(AboutUsLogic());

  AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Image.asset(
              iconLogo,
              color: iconLogoFullColor,
              height: AppConfig.logoSizeInAccount,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15.sp)),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                        child: GetBuilder<MainLogic>(
                            init: Get.find<MainLogic>(),
                            builder: (logic) {
                              return logic.isStoreSettingLoading
                                  ? const CircularProgressIndicator()
                                  : AppConfig.isSoreUseNewTheme
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            HtmlWidget(
                                              logic.footerSettings
                                                      ?.about_us_title ??
                                                  '',
                                            ),
                                            HtmlWidget(
                                              logic.footerSettings
                                                      ?.about_us_des ??
                                                  '',
                                            )
                                          ],
                                        )
                                      : HtmlWidget(logic.settingModel?.footer
                                              ?.aboutUs?.text ??
                                          '');
                            })),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton:
          AppConfig.showGBAllApp ? GlobalFloatingWhatsApp() : null,
    );
  }
}
