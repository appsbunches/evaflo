import 'package:entaj/src/modules/_main/widgets/description_widget.dart';

import '../../../utils/custom_widget/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../entities/module_model.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';

class AsayelBannerWidget extends StatelessWidget {
  final Settings? banner;
  final String? containerType;
  final BannerImage? bannerImage;
  final String? backgroundBanner;
  final String? url;

  const AsayelBannerWidget(
      {Key? key,
      required this.banner,
      this.containerType,
      this.url,
      this.backgroundBanner,
      this.bannerImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
      child: InkWell(onTap: () => goToLink(banner?.url ?? ''), child: buildContainer()),
    );
  }

  buildContainer() {
    if (banner?.containerType == 'no-container' && bannerImage?.image != null) {
      return InkWell(
        onTap: () => goToLink(bannerImage?.url ?? ""),
        child: CustomImage(
          url: bannerImage?.image,
        ),
      );
    }
    if (banner?.containerType == 'container' && banner?.bannerType == null) {
      return Container(
        margin: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () => goToLink(bannerImage?.url ?? ""),
          child: CustomImage(
            url: bannerImage?.image,
          ),
        ),
      );
    }
    return Container(
      color: banner?.bannerType == 'banner_2'
          ? Colors.white
          : HexColor.fromHex(banner?.bgColor ?? '#ffffff'),
      padding: banner?.containerType == "container" && banner?.bannerType == 'banner_1'
          ? const EdgeInsets.all(15)
          : EdgeInsets.zero,
      margin: banner?.containerType == "container"
          ? const EdgeInsets.all(10)
          : EdgeInsets.zero,
      child: Stack(
        children: [
          banner?.bannerType == 'banner_2'
              ? AspectRatio(
                  aspectRatio: 1.5,
                  child: Container(
                      decoration: BoxDecoration(
                        color: HexColor.fromHex(banner?.bgColor ?? '#ffffff'),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30)),
                      ),
                      child: CustomImage(
                        url: banner?.mobileImage ?? banner?.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )),
                )
              : banner?.bannerType == 'banner_1' && banner?.bgColor == null
                  ? CustomImage(
                      url: backgroundBanner,
                      fit: BoxFit.fitHeight,
                      height: Get.height * 0.65,
                    )
                  : SizedBox(),
          banner?.bannerType == 'banner_2'
              ? PositionedDirectional(
                  top: 0,
                  bottom: 0,
                  start: 0,
                  end: 0,
                  child: Container(
                    //   color: Colors.black45,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: banner?.position_title == "center"
                          ? CrossAxisAlignment.center
                          : banner?.position_title == "start"
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                      children: [
                        if (banner?.title != null)
                          CustomText(
                            banner?.title,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: HexColor.fromHex(banner?.textColor ?? 'ffffff'),
                          ),
                        if (banner?.subtitle != null || banner?.des != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: CustomText(
                              banner?.subtitle ?? banner?.des,
                              fontSize: 14,
                              color: HexColor.fromHex(banner?.textColor ?? '#ffffff'),
                            ),
                          ),
                        if (banner?.showSocial ?? false)
                          DescriptionWidget(
                            displaySocialMedia: banner?.showSocial ?? false,
                            justDisplaySocialMedia: true,
                            mainAxisAlignment: banner?.position_title == "center"
                                ? MainAxisAlignment.center
                                : banner?.position_title == "start"
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                            color: banner?.textColor ?? '#ffffff',
                          ),
                        if (banner?.showButton == true ||
                            (banner?.buttonText != null && banner?.showButton == null))
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
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
              : Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: banner?.position_title == "center"
                            ? CrossAxisAlignment.center
                            : banner?.position_title == "start"
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                        children: [
                          if (banner?.title != null)
                            CustomText(
                              banner?.title,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: HexColor.fromHex(banner?.textColor ?? 'ffffff'),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (banner?.subtitle != null || banner?.des != null)
                            CustomText(
                              banner?.subtitle ?? banner?.des,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: HexColor.fromHex(banner?.textColor ?? '#ffffff'),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (banner?.showSocial ?? false)
                            DescriptionWidget(
                              displaySocialMedia: true,
                              mainAxisAlignment: banner?.position_title == "center"
                                  ? MainAxisAlignment.center
                                  : banner?.position_title == "start"
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                              justDisplaySocialMedia: true,
                              color: banner?.textColor,
                            ),
                          if (banner?.showButton == true ||
                              (banner?.buttonText != null && banner?.showButton == null))
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
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
                    const SizedBox(
                      height: 0,
                    ),
                    if (banner?.image != null || banner?.mobileImage != null)
                      Container(
                          //padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: HexColor.fromHex(banner?.bgColor ?? Colors.transparent.toHex()),
                            //   borderRadius: const BorderRadius.only(topRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
                          ),
                          child: CustomImage(
                            url: banner?.mobileImage ?? banner?.image,
                          ))
                  ],
                )
        ],
      ),
    );
  }
}
