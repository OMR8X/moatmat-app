import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Presentation/videos/view/video_player_v.dart';
import 'package:video_player/video_player.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/spacing_resources.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.link,
    this.onClose,
  });
  final String link;
  final VoidCallback? onClose;
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    initController();
    super.initState();
  }

  initController() {
    //
    var url = Uri.parse(widget.link);
    //
    _controller = VideoPlayerController.networkUrl(url)
      ..addListener(() {
        setState(() {});
      });
    //
    _controller.setLooping(false);
    //
    _controller.initialize();
    //
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: ShadowsResources.mainBoxShadow,
          color: ColorsResources.onPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        width: SpacingResources.mainWidth(context),
        child: GestureDetector(
          onPanDown: (details) {},
          child: VideoPlayerBody(
            controller: _controller,
            showActions: true,
            onPlay: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VideoPlayerView(
                    link: widget.link,
                  ),
                ),
              );
            },
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
    required this.onPlay,
  });
  final VideoPlayerController controller;
  final VoidCallback onPlay;
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
          IconButton(
            onPressed: onPlay,
            icon: const Icon(
              Icons.play_arrow_rounded,
              size: 50,
              color: Colors.white,
            ),
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
