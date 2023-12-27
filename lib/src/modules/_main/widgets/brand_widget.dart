import '../../../colors.dart';

import '../../../app_config.dart';
import '../../../entities/home_screen_model.dart';
import 'package:flutter/material.dart';

import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/functions.dart';

class BrandWidget extends StatelessWidget {
  final Brands? brands;

  const BrandWidget({required this.brands, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return brands?.display != true || brands?.items == null || brands?.items?.length == 0
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (brands?.title != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomText(
                      brands?.title,
                      fontSize: 17,
                      color: primaryColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                if (brands?.title != null)
                  const SizedBox(
                    height: 10,
                  ),
                brands?.items?.length == 1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: GestureDetector(
                            onTap: () {
                              goToLink(brands?.items?.first.url);
                            },
                            child: CustomImage(
                              url: brands?.items?.first.image,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 100.h,
                        child: ListView.builder(
                            itemCount: brands?.items?.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var brand = brands?.items?[index];
                              return GestureDetector(
                                onTap: () {
                                  goToLink(brand?.url);
                                },
                                child: CustomImage(
                                  url: brand?.image,
                                  width: 100.w,
                                  height: 90.h,
                                ),
                              );
                            })),
              ],
            ),
          );
  }
}
