import 'package:entaj/src/modules/_main/widgets/asayel_banner_widget.dart';

import '../../../.env.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../entities/module_model.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';

class BannerWidget extends StatelessWidget {
  final Settings? banner;
  final String? containerType;
  final BannerImage? bannerImage;
  final String? backgroundBanner;
  final String? url;

  const BannerWidget(
      {Key? key,
      required this.banner,
      this.containerType,
      this.url,
      this.backgroundBanner,
      this.bannerImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (AppConfig.currentThemeId == asayelThemeId) {
      return AsayelBannerWidget(
        banner: banner,
        containerType: containerType,
        url: url,
        backgroundBanner: backgroundBanner,
        bannerImage: bannerImage,
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
      child: InkWell(
          onTap: () => goToLink(banner?.url ?? ''),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: HexColor.fromHex(banner?.color ?? '#ffffff'),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
                    ),
                    child: CustomImage(
                      url: banner?.mobileImage ?? banner?.image,
                    )),
                AppConfig.currentThemeId == duvetThemeId
                    ? Padding(
                        padding: const EdgeInsets.all(15),
                        child: HtmlWidget(
                          banner?.title ?? '',
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: AppConfig.fontName,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : PositionedDirectional(
                        top: 0,
                        bottom: 0,
                        width: Get.width,
                        child: Container(
                          color: Colors.black45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (banner?.title != null)
                                CustomText(
                                  banner?.title,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor.fromHex(banner?.textColor ?? 'ffffff'),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (banner?.subtitle != null || banner?.des != null)
                                CustomText(
                                  banner?.subtitle ?? banner?.des,
                                  fontSize: 14,
                                  color: HexColor.fromHex(banner?.textColor ?? '#ffffff'),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (banner?.showButton == true ||
                                  (banner?.buttonText != null &&
                                      banner?.showButton == null))
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 5),
                                  child: CustomButtonWidget(
                                      title: banner?.buttonText ?? '',
                                      width: (banner?.buttonText?.length ?? 0) * 20,
                                      textColor: HexColor.fromHex(
                                          banner?.buttonTextColor ?? '#ffffff'),
                                      color: HexColor.fromHex(
                                          banner?.buttonBgColor ?? primaryColor.toHex()),
                                      textSize: 16,
                                      radius: 3,
                                      onClick: () => goToLink(banner?.url)),
                                )
                            ],
                          ),
                        ),
                      )
              ],
            ),
          )),
    );
  }
}
