import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../app_config.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import '../_main/logic.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton:
          AppConfig.showGBAllApp ? GlobalFloatingWhatsApp() : null,
      appBar: AppBar(
        elevation: 5,
        title: CustomText(
          "الأسئلة الشائعة".tr,
          fontSize: 16,
        ),
      ),
      body: GetBuilder<MainLogic>(
          init: Get.find<MainLogic>(),
          id: 'faq',
          builder: (logic) {
            return logic.isFaqLoading
                ? const CustomProgressIndicator()
                : RefreshIndicator(
                    onRefresh: () async {
                      await logic.mainData.getFaqs();
                    },
                    child: ListView.builder(
                        itemCount: logic.faqList.length,
                        padding: const EdgeInsets.only(top: 20),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => logic.openTap(index),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(10),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            child: CustomText(
                                          logic.faqList[index].question,
                                          textAlign: TextAlign.start,
                                        )),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          logic.selectedIndex == index
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  child: (logic.selectedIndex != index)
                                      ? const SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: HtmlWidget(
                                            logic.faqList[index].answer ?? '',
                                          ),
                                        ),
                                )
                              ],
                            ),
                          );
                        }),
                  );
          }),
    );
  }
}
