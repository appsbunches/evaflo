import 'package:chewie/chewie.dart';
import '../../../app_config.dart';
import '../../../entities/module_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart' as y;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../.env.dart';
import '../../../colors.dart';
import '../../../utils/custom_widget/custom_text.dart';

class VideoWidget extends StatefulWidget {
  Settings? settings;

  VideoWidget({required this.settings, Key? key}) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  late YoutubePlayerController _youtubeController;
  ChewieController? _chewieController;

  @override
  void initState() {
    if (widget.settings?.video?.contains('youtube.com') != true) {
      _controller = VideoPlayerController.network(widget.settings?.video ?? '')
        ..initialize().then((value) {
          _chewieController = ChewieController(
              videoPlayerController: _controller,
              showControls: AppConfig.currentThemeId == softThemeId
                  ? widget.settings?.controls == true
                  : true,
              autoPlay: widget.settings?.autoplay == true,
              looping: false);
          setState(() {});
        });
    } else if (widget.settings?.video?.contains('youtube.com') == true) {
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: y.YoutubePlayer.convertUrlToId(widget.settings?.video ?? '') ?? '',
        startSeconds: 10,
        params: YoutubePlayerParams(
          showControls: widget.settings?.controls == true,
          showFullscreenButton: true,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.settings?.title != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomText(
                widget.settings?.title,
                fontSize: 17,
                color: primaryColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
          AspectRatio(
            aspectRatio: widget.settings?.video?.contains('youtube.com') != true
                ? _controller.value.aspectRatio + 0.2
                : 16 / 9,
            child: widget.settings?.video?.contains('youtube.com') == true
                ? YoutubePlayer(
                    controller: _youtubeController, gestureRecognizers: {},
                    //  showVideoProgressIndicator: true,
                  )
                : _chewieController == null
                    ? const SizedBox()
                    : Chewie(
                        controller: _chewieController!,
                      ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
