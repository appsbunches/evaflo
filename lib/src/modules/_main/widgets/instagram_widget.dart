import '../../../entities/home_screen_model.dart';
import '../../../images.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';
import 'package:flutter/material.dart';

import '../../../app_config.dart';

class InstagramWidget extends StatelessWidget {
  final List<Items> instagramList;
  final String? instagramAccount;
  final String? title;

  const InstagramWidget(
      {Key? key,
      required this.instagramList,
      required this.instagramAccount,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
      child: Column(
        children: [
          if (title != null)
            CustomText(
              title,
              fontSize: 16,
            ),
          if (instagramAccount != null)
            GestureDetector(
              onTap: () => goToLink('https://www.instagram.com/$instagramAccount'),
              child: CustomText(
                '@$instagramAccount',
                fontSize: 12,
                color: Colors.grey.shade800,
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          AspectRatio(
            aspectRatio: 1.5,
            child: ListView.builder(
                itemCount: instagramList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: () => goToLink(instagramList[index].url),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              children: [
                                CustomImage(url: instagramList[index].image),
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      color: Colors.black38,
                                    )),
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: Image.asset(
                                      iconInstagram,
                                      scale: 2,
                                      color: Colors.white,
                                    ))
                              ],
                            )),
                      ),
                    )),
          )
        ],
      ),
    );
  }
}
