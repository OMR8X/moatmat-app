// import 'package:flutter/material.dart';
// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:video_player/video_player.dart';

// class SamplePlayer extends StatefulWidget {
//   const SamplePlayer({super.key, required this.url});
//   final String url;
//   @override
//   State<SamplePlayer> createState() => _SamplePlayerState();
// }

// class _SamplePlayerState extends State<SamplePlayer> {
//   late FlickManager flickManager;

//   @override
//   void initState() {
//     super.initState();
//     flickManager = FlickManager(
//         videoPlayerController: VideoPlayerController.networkUrl(
//       Uri.parse(widget.url),
//     ));
//   }

//   @override
//   void dispose() {
//     flickManager.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: FlickVideoPlayer(flickManager: flickManager),
//     );
//   }
// }
