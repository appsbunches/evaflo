import '../../../.env.dart';
import '../../../colors.dart';
import '../../../entities/module_model.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app_config.dart';

class AsayelFeaturesWidget extends StatelessWidget {
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

  const AsayelFeaturesWidget({
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
    return Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppConfig.paddingBetweenWidget, horizontal: 8),
        color: bgColor != null ? HexColor.fromHex(bgColor!) : featuresBackgroundColor,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: AppConfig.currentThemeId == asayelThemeId
                ? positionTitle == "center"
                    ? CrossAxisAlignment.center
                    : positionTitle == "start"
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end
                : CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  if (title != null)
                    CustomText(
                      title,
                      fontSize: 17,
                      color: HexColor.fromHex(mainTitleClr ?? primaryColor.toHex()),
                      fontWeight: FontWeight.w900,
                    ),
                  if (desc != null)
                    CustomText(
                      desc,
                      fontSize: 12,
                      color: HexColor.fromHex(mainTitleClr ?? primaryColor.toHex()),
                      fontWeight: FontWeight.w500,
                    ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GridView.builder(
                itemCount: storeFeatures.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.6),
                itemBuilder: (context, index) => buildItem(index),
              )
            ],
          ),
        ));
  }

  buildItem(int index) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: HexColor.fromHex(bgClrFeature ?? primaryColor.toHex())),
      child: Column(
        crossAxisAlignment: AppConfig.currentThemeId == asayelThemeId
            ? positionContent == "center"
                ? CrossAxisAlignment.center
                : positionContent == "start"
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end
            : CrossAxisAlignment.center,
        children: [
          if (storeFeatures[index].image != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22), topRight: Radius.circular(22)),
                child: CustomImage(
                  url: storeFeatures[index].image,
                  showErrorImage: false,
                  width: AppConfig.featureSize,
                  height: AppConfig.featureSize,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (storeFeatures[index].title != null)
                  CustomText(storeFeatures[index].title,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      color: HexColor.fromHex(titleFeatureClr ?? primaryColor.toHex())),
                if (storeFeatures[index].des != null)
                  CustomText(storeFeatures[index].des,
                      fontSize: 10,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      color: HexColor.fromHex(contentFeatureClr ?? primaryColor.toHex())),
              ],
            ),
          )
        ],
      ),
    );
  }
}
