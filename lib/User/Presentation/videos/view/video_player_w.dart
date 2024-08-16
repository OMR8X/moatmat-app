import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/spacing_resources.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.flickManager,
    this.width,
  });
  final FlickManager flickManager;
  final double? width;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: ShadowsResources.mainBoxShadow,
          color: ColorsResources.blackText1,
          borderRadius: BorderRadius.circular(12),
        ),
        width: widget.width ?? SpacingResources.mainWidth(context),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: SafeArea(
            child: Center(
              child: FlickVideoPlayer(
                flickManager: widget.flickManager,
                flickVideoWithControls: FlickVideoWithControls(
                  controls: IconTheme(
                    data: const IconThemeData(color: ColorsResources.onPrimary),
                    child: AspectRatio(
                      aspectRatio: widget.flickManager.flickVideoManager
                              ?.videoPlayerController?.value.aspectRatio ??
                          16 / 9,
                      child: FlickPortraitControls(
                        progressBarSettings: FlickProgressBarSettings(
                          bufferedColor: ColorsResources.borders,
                          playedColor: ColorsResources.darkPrimary,
                          handleColor: ColorsResources.darkPrimary,
                          backgroundColor: ColorsResources.borders,
                        ),
                      ),
                    ),
                  ),
                ),
                flickVideoWithControlsFullscreen: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    color: Colors.black,
                    child: SafeArea(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: widget.flickManager.flickVideoManager
                                  ?.videoPlayerController?.value.aspectRatio ??
                              16 / 9,
                          child: FlickVideoWithControls(
                            controls: IconTheme(
                              data: const IconThemeData(
                                  color: ColorsResources.onPrimary),
                              child: FlickPortraitControls(
                                progressBarSettings: FlickProgressBarSettings(
                                  bufferedColor: ColorsResources.borders,
                                  playedColor: ColorsResources.darkPrimary,
                                  handleColor: ColorsResources.darkPrimary,
                                  backgroundColor: ColorsResources.borders,
                                  padding: const EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
