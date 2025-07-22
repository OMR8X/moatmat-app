import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/functions/parsers/time_ago.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/fonts_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Presentation/auth/view/error_v.dart';
import 'package:moatmat_app/User/Presentation/videos/state/VideoBloc/video_bloc.dart';
import 'package:moatmat_app/User/Presentation/videos/view/chewie_player_widget.dart';
import 'package:moatmat_app/User/Presentation/videos/widget/add_comment_bottom_sheet_w.dart';
import 'package:moatmat_app/User/Presentation/videos/widget/add_reply_bottom_sheet_w.dart';
import 'package:moatmat_app/User/Presentation/videos/widget/under_video_w.dart';
import 'package:moatmat_app/User/Presentation/videos/widget/video_comment_w.dart';

import '../../../Features/video/domain/entites/comment.dart';

class OfflineVideoView extends StatefulWidget {
  const OfflineVideoView({super.key, required this.videoPath});
  final String videoPath;

  @override
  State<OfflineVideoView> createState() => _OfflineVideoViewState();
}

class _OfflineVideoViewState extends State<OfflineVideoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.onPrimary,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close_sharp),
        ),
        backgroundColor: ColorsResources.onPrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(SizesResources.s2),
        child: Center(
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5, // Max 35% of screen height
                  minWidth: MediaQuery.of(context).size.width * 0.95, // Max 35% of screen height
                ),
                child: ChewiePlayerWidget(videoPath: widget.videoPath),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
