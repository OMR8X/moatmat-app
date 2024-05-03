import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Presentation/videos/view/test_video.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    super.key,
    required this.link,
  });
  final String link;
  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _controller;
  late Timer _timer;
  late Duration counter;
  final bool showActions = false;

  @override
  void initState() {
    initController();
    super.initState();
  }

  initController() {
    //
    counter = const Duration(seconds: -5);
    //
    var url = Uri.parse(widget.link);
    //
    _controller = VideoPlayerController.networkUrl(
      url,
      videoPlayerOptions: VideoPlayerOptions(),
    )..addListener(() {
        setState(() {});
      });
    //
    _controller.setLooping(false);
    //
    _controller.initialize().then((value) async {
      await _controller.play();
      initTimer();
    });
    //
  }

  initTimer() {
    counter = const Duration(seconds: -5);
    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        counter = Duration(
          milliseconds: counter.inMilliseconds + 100,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return SamplePlayer(url: wid);
    return Scaffold(
      backgroundColor: ColorsResources.blackText1,
      appBar: AppBar(
        backgroundColor: ColorsResources.blackText1,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: GestureDetector(
        onPanDown: (details) {
          counter = Duration.zero;
          setState(() {});
        },
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: VideoPlayerBody(
                  controller: _controller,
                  showActions: counter.inSeconds <= 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayerBody extends StatelessWidget {
  const VideoPlayerBody({
    super.key,
    required this.controller,
    required this.showActions,
  });
  final VideoPlayerController controller;
  final bool showActions;
  @override
  Widget build(BuildContext context) {
    if (controller.value.isInitialized) {
      return Stack(
        alignment: Alignment.center,
        children: [
          //
          _buildVideo(),
          //
          if (showActions)
            VideoControllersButtons(
              controller: controller,
            ),
        ],
      );
    } else {
      return const Center(child: CupertinoActivityIndicator());
    }
  }

  _buildVideo() => AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      );
}

class VideoControllersButtons extends StatelessWidget {
  const VideoControllersButtons({
    super.key,
    required this.controller,
  });
  final VideoPlayerController controller;
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: Row(),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                  icon: Icon(
                    controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow_rounded,
                    size: SizesResources.s10,
                    color: ColorsResources.background,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: SizesResources.s1,
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Slider(
                inactiveColor: ColorsResources.blackText2,
                thumbColor: ColorsResources.primary,
                value: currentValue(),
                onChangeStart: (value) {},
                onChangeEnd: (value) {},
                onChanged: (v) {
                  controller.seekTo(
                    Duration(
                      seconds:
                          (v * controller.value.duration.inSeconds).toInt(),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  double currentValue() {
    final full = controller.value.duration;
    final current = controller.value.position;
    double value = current.inSeconds / full.inSeconds;
    return value;
  }
}
