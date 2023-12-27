import 'package:entaj/src/modules/_main/widgets/asayel_features_widget.dart';

import '../../../.env.dart';
import '../../../colors.dart';
import '../../../entities/module_model.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app_config.dart';

class FeaturesWidget extends StatelessWidget {
  final List<StoreFeatures> storeFeatures;
  final String? bgColor;
  final String? title;
  final String? desc;
  final String? mainTitleClr;
  final String? titleFeatureClr;
  final String? contentFeatureClr;
  final String? positionTitle;
  final String? bgClrFeature;
  final String? positionContent;

  const FeaturesWidget({
    Key? key,
    required this.storeFeatures,
    this.bgColor,
    this.title,
    this.desc,
    this.mainTitleClr,
    this.titleFeatureClr,
    this.contentFeatureClr,
    this.positionTitle,
    this.bgClrFeature,
    this.positionContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (AppConfig.currentThemeId == asayelThemeId) {
      return AsayelFeaturesWidget(
          storeFeatures: storeFeatures,
          bgColor: bgColor,
          title: title,
          desc: desc,
          mainTitleClr: mainTitleClr,
          titleFeatureClr: titleFeatureClr,
          contentFeatureClr: contentFeatureClr,
          positionTitle: positionTitle,
          positionContent: positionContent,
          bgClrFeature: bgClrFeature);
    }
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppConfig.paddingBetweenWidget, horizontal: 8),
      color: bgColor != null ? HexColor.fromHex(bgColor!) : featuresBackgroundColor,
      width: double.infinity,
      child: AppConfig.currentThemeId == duvetThemeId
          ? Column(
              children: storeFeatures
                  .map((e) => Row(
                        children: [
                          Container(
                            width: 50,
                            padding: const EdgeInsets.all(15.0),
                            child: CustomImage(
                              url: e.image,
                              showErrorImage: false,
                              width: 30,
                              height: 30,
                            ),
                          ),
                          SizedBox(
                            width: 10.h,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  e.title,
                                  fontSize: 14,
                                  textAlign: TextAlign.center,
                                  color: Colors.black,
                                ),
                                CustomText(
                                  e.des,
                                  fontSize: 10,
                                  textAlign: TextAlign.center,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            )
          : AppConfig.showFeatureAsColumn
              ? Column(
                  children: storeFeatures
                      .map((e) => Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomImage(
                                      url: e.image,
                                      showErrorImage: false,
                                      width: AppConfig.featureSize,
                                      height: AppConfig.featureSize,
                                    ),
                                    CustomText(
                                      e.title,
                                      fontSize: 14,
                                      textAlign: TextAlign.center,
                                      color: Colors.black,
                                    ),
                                    CustomText(
                                      e.des,
                                      fontSize: 10,
                                      textAlign: TextAlign.center,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                )
              : Row(
                  children: storeFeatures
                      .map((e) => Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xff739070), Color(0xff3a4d39)],
                                  // You can also specify stops and tileMode if needed
                                  // stops: [0.3, 0.7],
                                  // tileMode: TileMode.clamp,
                                ),
                              ),
                              child: Column(
                                children: [
                                  if (e.image != null)
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                  if (e.image != null)
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: CustomImage(
                                        url: e.image,
                                        showErrorImage: false,
                                        width: AppConfig.featureSize,
                                        height: AppConfig.featureSize,
                                      ),
                                    ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  CustomText(
                                    e.title,
                                    fontSize: 12,
                                    textAlign: TextAlign.center,
                                    color: e.textColor != null
                                        ? HexColor.fromHex(e.textColor!)
                                        : featuresForegroundColor,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
    );
  }
}
