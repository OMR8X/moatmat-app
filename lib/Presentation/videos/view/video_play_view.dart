import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';
import 'package:moatmat_app/Presentation/videos/view/chewie_player_widget.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({super.key, required this.link});
  final String link;
  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late FlickManager flickManager;
  @override
  void initState() {
    //
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.link),
      ),
    );
    //
    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        //
        final NavigatorState navigator = Navigator.of(context);
        //
        if (didPop) {
          return;
        }
        //
        final bool shouldPop = flickManager.flickControlManager?.isFullscreen ?? false;
        if (shouldPop) {
          flickManager.flickControlManager?.exitFullscreen();
        } else {
          navigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: ColorsResources.blackText1,
        appBar: AppBar(
          backgroundColor: ColorsResources.blackText1,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ChewiePlayerWidget(videoUrl: widget.link),
            ],
          ),
        ),
      ),
    );
  }
}
