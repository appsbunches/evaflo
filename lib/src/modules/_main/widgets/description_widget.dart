import 'package:entaj/src/app_config.dart';
import 'package:entaj/src/utils/custom_widget/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../.env.dart';
import '../../../colors.dart';
import '../../../images.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../logic.dart';

class DescriptionWidget extends StatelessWidget {
  final String? title;
  final String? desc;
  final String? color;
  final bool? justDisplaySocialMedia;
  final MainAxisAlignment? mainAxisAlignment;
  final bool displaySocialMedia;

  const DescriptionWidget(
      {Key? key,
      this.title,
      this.desc,
      this.color,
      this.justDisplaySocialMedia,
      this.mainAxisAlignment,
      required this.displaySocialMedia})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(builder: (logic) {
      return logic.isHomeLoading
          ? Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20.sp)),
                width: double.infinity,
                child: SizedBox(
                  height: 100.h,
                ),
              ))
          : Container(
              padding: AppConfig.currentThemeId == asayelThemeId
                  ? EdgeInsets.zero
                  : const EdgeInsets.all(20),
              margin: EdgeInsets.only(
                  left: justDisplaySocialMedia == true ? 0 : 15,
                  right: justDisplaySocialMedia == true ? 0 : 15,
                  top: AppConfig.paddingBetweenWidget,
                  bottom: AppConfig.paddingBetweenWidget),
              decoration: BoxDecoration(
                  color: AppConfig.currentThemeId == asayelThemeId
                      ? null
                      : HexColor.fromHex(logic.homeScreenModel?.storeDescription?.style
                              ?.backgroundColor ??
                          backgroundDescriptionColor),
                  borderRadius: AppConfig.currentThemeId == asayelThemeId
                      ? BorderRadius.circular(10.sp)
                      : BorderRadius.circular(20.sp)),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (title != null)
                    CustomText(
                      title,
                      fontWeight: FontWeight.bold,
                      color: HexColor.fromHex(logic.homeScreenModel?.storeDescription
                              ?.style?.foregroundColor ??
                          foregroundDescriptionColor),
                      textAlign: TextAlign.center,
                    ),
                  if (desc != null)
                    CustomText(
                      desc,
                      textAlign: TextAlign.center,
                      color: HexColor.fromHex(logic.homeScreenModel?.storeDescription
                              ?.style?.foregroundColor ??
                          foregroundDescriptionColor),
                      fontSize: 10,
                    ),
                  if (displaySocialMedia)
                    const SizedBox(
                      height: 5,
                    ),
                  if (displaySocialMedia)
                    Row(
                      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
                      children: [
                        if (logic.settingModel?.footer?.socialMedia?.items?.tiktok !=
                            null)
                          InkWell(
                            onTap: () => logic.goToTiktok(
                                tiktok: logic
                                    .settingModel?.footer?.socialMedia?.items?.tiktok),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomImage(
                                url: iconTiktokSvg,
                                color: AppConfig.currentThemeId == asayelThemeId
                                    ? HexColor.fromHex(
                                        color ?? foregroundDescriptionColor)
                                    : HexColor.fromHex(logic.homeScreenModel
                                            ?.storeDescription?.style?.foregroundColor ??
                                        foregroundDescriptionColor),
                                height: 22,
                              ),
                            ),
                          ),
                        if (logic.settingModel?.footer?.socialMedia?.items?.twitter !=
                            null)
                          InkWell(
                            onTap: () => logic.goToTwitter(
                                twitter: logic
                                    .settingModel?.footer?.socialMedia?.items?.twitter),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomImage(
                                url: iconTwitterSvg,
                                color: AppConfig.currentThemeId == asayelThemeId
                                    ? HexColor.fromHex(
                                        color ?? foregroundDescriptionColor)
                                    : HexColor.fromHex(logic.homeScreenModel
                                            ?.storeDescription?.style?.foregroundColor ??
                                        foregroundDescriptionColor),
                                height: 22,
                              ),
                            ),
                          ),
                        if (logic.settingModel?.footer?.socialMedia?.items?.snapchat !=
                            null)
                          InkWell(
                            onTap: () => logic.goToSnapchat(
                                snapchat: logic
                                    .settingModel?.footer?.socialMedia?.items?.snapchat),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomImage(
                                url: iconSnapchatSvg,
                                color: AppConfig.currentThemeId == asayelThemeId
                                    ? HexColor.fromHex(
                                        color ?? foregroundDescriptionColor)
                                    : HexColor.fromHex(logic.homeScreenModel
                                            ?.storeDescription?.style?.foregroundColor ??
                                        foregroundDescriptionColor),
                                height: 22,
                              ),
                            ),
                          ),
                        if (logic.settingModel?.footer?.socialMedia?.items?.instagram !=
                            null)
                          InkWell(
                            onTap: () => logic.goToInstagram(
                                instagram: logic
                                    .settingModel?.footer?.socialMedia?.items?.instagram),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomImage(
                                url: iconInstagramSvg,
                                color: AppConfig.currentThemeId == asayelThemeId
                                    ? HexColor.fromHex(
                                        color ?? foregroundDescriptionColor)
                                    : HexColor.fromHex(logic.homeScreenModel
                                            ?.storeDescription?.style?.foregroundColor ??
                                        foregroundDescriptionColor),
                                height: 22,
                              ),
                            ),
                          ),
                        if (logic.settingModel?.footer?.socialMedia?.items?.facebook !=
                            null)
                          InkWell(
                            onTap: () => logic.goToFacebook(
                                facebook: logic
                                    .settingModel?.footer?.socialMedia?.items?.facebook),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomImage(
                                url: iconFacebookSvg,
                                color: AppConfig.currentThemeId == asayelThemeId
                                    ? HexColor.fromHex(
                                        color ?? foregroundDescriptionColor)
                                    : HexColor.fromHex(logic.homeScreenModel
                                            ?.storeDescription?.style?.foregroundColor ??
                                        foregroundDescriptionColor),
                                height: 22,
                              ),
                            ),
                          ),
                        if (logic.settingModel?.footer?.socialMedia?.items?.phone != null)
                          InkWell(
                            onTap: () => logic.goToPhone(
                                phone: logic
                                    .settingModel?.footer?.socialMedia?.items?.phone),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomImage(
                                url: iconPhoneSvg,
                                color: AppConfig.currentThemeId == asayelThemeId
                                    ? HexColor.fromHex(
                                        color ?? foregroundDescriptionColor)
                                    : HexColor.fromHex(logic.homeScreenModel
                                            ?.storeDescription?.style?.foregroundColor ??
                                        foregroundDescriptionColor),
                                height: 22,
                              ),
                            ),
                          ),
                        if (logic.settingModel?.footer?.socialMedia?.items?.email != null)
                          InkWell(
                            onTap: () => logic.goToEmail(
                                email: logic
                                    .settingModel?.footer?.socialMedia?.items?.email),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomImage(
                                url: iconMessage,
                                color: AppConfig.currentThemeId == asayelThemeId
                                    ? HexColor.fromHex(
                                        color ?? foregroundDescriptionColor)
                                    : HexColor.fromHex(logic.homeScreenModel
                                            ?.storeDescription?.style?.foregroundColor ??
                                        foregroundDescriptionColor),
                                height: 20,
                              ),
                            ),
                          ),
                      ],
                    )
                ],
              ),
            );
    });
  }
}
