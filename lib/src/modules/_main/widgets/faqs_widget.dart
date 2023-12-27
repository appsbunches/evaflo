import 'dart:developer';

import 'package:entaj/src/colors.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as y;
import 'package:entaj/src/entities/module_model.dart';
import 'package:entaj/src/utils/custom_widget/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../utils/custom_widget/custom_text.dart';

class FaqsWidget extends StatefulWidget {
  final Settings? model;

  const FaqsWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<FaqsWidget> createState() => _FaqsWidgetState();
}

class _FaqsWidgetState extends State<FaqsWidget> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: y.YoutubePlayer.convertUrlToId(widget.model?.detailsVideo ?? '') ?? '',
      params: const YoutubePlayerParams(
      //  startAt: Duration(seconds: 10),
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor.fromHex(widget.model?.detailsBg ?? 'ffffff'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          if (widget.model?.detailsVideoImg != null)
            Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                      left: 10,
                      bottom: 12,
                      child: CustomImage(
                        url: widget.model?.detailsVideoImg ?? '',
                        height: 160,
                      )),
                  GestureDetector(
                    onTap: () {
                      Get.dialog(youtubePlayer());
                    },
                    child: const CustomImage(
                      url:
                          'https://assets.zid.store/themes/9d949f7a-271a-48d8-9b17-05317049bea4/faq_tv.png',
                      height: 230,
                    ),
                  )
                ],
              ),
            ),
          const SizedBox(height: 20),
          if (widget.model?.detailsDesc != null)
            CustomText(
              widget.model?.detailsDesc ?? '',
              fontSize: 14,
              color: const Color(0xff0a303a),
              fontWeight: FontWeight.w900,
            ),
          const SizedBox(height: 30),
          if (widget.model?.faqsStoreFeatures != null)
            ...widget.model?.faqsStoreFeatures
                    ?.map((e) => Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ExpansionTile(
                            textColor: Colors.black,
                            childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                            title: CustomText(e?.title ?? ''),
                            children: [CustomText(e?.answer)],
                          ),
                        ))
                    .toList() ??
                [],
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget youtubePlayer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(
              controller: _youtubeController,
              gestureRecognizers: {},
            )),
      ],
    );
  }
}
