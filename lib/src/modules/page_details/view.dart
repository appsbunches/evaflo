import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_config.dart';
import '../../entities/page_model.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/functions.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import 'logic.dart';

class PageDetailsPage extends StatefulWidget {
  int type;
  final PageModel? pageModel;
  final String? title;
  final String? url;

  PageDetailsPage(
      {this.pageModel,
      required this.type,
      required this.title,
      this.url,
      Key? key})
      : super(key: key);

  @override
  State<PageDetailsPage> createState() => _PageDetailsPageState();
}

class _PageDetailsPageState extends State<PageDetailsPage> {
  final PageDetailsLogic logic = Get.put(PageDetailsLogic());

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

  @override
  initState() {
    log(widget.type.toString());
    log(widget.pageModel.toString());
    log(widget.title.toString());
    log(widget.url.toString());
    logic.pageModel = widget.pageModel;
    if (widget.pageModel?.content == null) {
      if (widget.type == 1) {
        if (widget.pageModel == null) logic.getPrivacyPolicy();
      } else if (widget.type == 2) {
        if (widget.pageModel == null) logic.getRefundPolicy();
      } else if (widget.type == 3) {
        if (widget.pageModel == null) logic.getTermsAndConditions();
      } else if (widget.type == 6) {
        if (widget.pageModel == null) logic.getComplaintsAndSuggestions();
      } else if (widget.type == 7) {
        if (widget.pageModel == null) logic.getLicense();
      } else if (widget.type == 4) {
        logic.getPageDetails(widget.pageModel?.id);
      } else {
        if (widget.url?.contains('shipping-and-payment') == true) {
        } else if (widget.url?.contains('privacy-policy') == true &&
            widget.url?.contains('blogs') == false) {
          widget.type = 1;
          logic.getPrivacyPolicy();
        } else if (widget.url?.contains('refund-exchange-policy') == true &&
            widget.url?.contains('blogs') == false) {
          widget.type = 2;
          logic.getRefundPolicy();
        } else if (widget.url?.contains('terms-and-conditions') == true &&
            widget.url?.contains('blogs') == false) {
          widget.type = 3;
          logic.getTermsAndConditions();
        } else if (widget.url?.contains('complaints-and-suggestions') == true &&
            widget.url?.contains('blogs') == false) {
          widget.type = 6;
          logic.getComplaintsAndSuggestions();
        } else if (widget.url?.contains('license') == true &&
            widget.url?.contains('blogs') == false) {
          widget.type = 7;
          logic.getLicense();
        } else if (widget.url?.contains('https://') == true &&
            widget.url?.contains('blogs') == false) {
          goToLink(widget.url);
        } else {
          logic.getPageDetailsSlug(widget.url);
        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PageDetailsLogic>(builder: (logic) {
      return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton:
              AppConfig.showGBAllApp ? GlobalFloatingWhatsApp() : null,
          appBar: AppBar(
            title: CustomText(
              widget.title ?? logic.pageModel?.title,
              fontSize: 16,
            ),
            elevation: 3,
          ),
          body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  if (widget.type == 1) {
                    await logic.getPrivacyPolicy();
                  } else if (widget.type == 2) {
                    await logic.getRefundPolicy();
                  } else if (widget.type == 3) {
                    await logic.getTermsAndConditions();
                  } else if (widget.type == 6) {
                    await logic.getComplaintsAndSuggestions();
                  } else {
                    //   logic.getPageDetails(pageModel?.id);
                  }
                },
                child: /* (logic.pageModel?.contentWithoutTags?.length ?? 0) < 1
                    ? SizedBox(
                        height: 700.h,
                        child: Center(
                          child: CustomText(
                              'نعتذر ، لا يوجد محتوى لهذة الصفحة حاليا'.tr),
                        ),
                      )
                    : */
                    logic.pageModel?.content?.contains('iframe') == true &&
                            logic.pageModel?.id != 42832
                        ? FutureBuilder<bool>(
                            future: Future.delayed(const Duration(seconds: 2))
                                .then((value) => true),
                            builder: (context, AsyncSnapshot<bool> snapshot) {
                              return Stack(
                                children: [
                                  Opacity(
                                    opacity: snapshot.data == true ? 1 : 0,
                                    child: InAppWebView(
                                      initialOptions: options,
                                      initialData: InAppWebViewInitialData(
                                          data: logic.pageModel?.content ??
                                              logic.pageModel
                                                  ?.sEOPageDescription ??
                                              ''),
                                    ),
                                  ),
                                  if (snapshot.data != true)
                                    const Center(
                                        child: CircularProgressIndicator())
                                ],
                              );
                            })
                        : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: buildHtml(widget.type > 2),
                            ),
                          ),
              ),
              if (logic.isLoading)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: double.infinity,
                      child: const CustomProgressIndicator()),
                ),
            ],
          ));
    });
  }

  Widget buildHtml(bool additional) {
    return AppConfig.useHtmlPackage
        ? Html(
            data: logic.pageModel?.content ??
                logic.pageModel?.sEOPageDescription ??
                '',
            onLinkTap: (String? url, attributes, element) {
              launch(url ?? '');
            })
        : HtmlWidget(
            logic.pageModel?.content ??
                logic.pageModel?.sEOPageDescription ??
                '',
            onErrorBuilder: (context, element, error) {
              return Html(
                  data: logic.pageModel?.content ??
                      logic.pageModel?.sEOPageDescription ??
                      '',
                  onLinkTap: (String? url, attributes, element) {
                    launch(url ?? '');
                  });
            },
            onTapUrl: (url) => launch(url),
          );
  }
}
