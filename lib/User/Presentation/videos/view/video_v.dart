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
import 'package:moatmat_app/User/Presentation/videos/view/video_player_w.dart';
import 'package:moatmat_app/User/Presentation/videos/widget/add_comment_bottom_sheet_w.dart';
import 'package:moatmat_app/User/Presentation/videos/widget/add_reply_bottom_sheet_w.dart';
import 'package:moatmat_app/User/Presentation/videos/widget/under_video_w.dart';
import 'package:moatmat_app/User/Presentation/videos/widget/video_comment_w.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key, required this.videoId});
  final int videoId;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => VideoBloc()
          ..add(LoadVideo(videoId: widget.videoId))
          ..add(LoadComments(videoId: widget.videoId)),
        //
        child: BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            //
            if (state.isLoading[Loading.video] == true || state.isLoading[Loading.rating] == true) {
              return Center(
                child: const CupertinoActivityIndicator(
                  color: ColorsResources.primary,
                ),
              );
            }
            //
            else if (state.errorMsg != null) {
              return ErrorView(error: state.errorMsg);
            }
            //
            else if (state.video != null && state.myRating != null) {
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
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    final videoBloc = context.read<VideoBloc>();
                    //
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) {
                        return BlocProvider.value(
                          value: videoBloc,
                          child: AddCommentBottomSheetWidget(),
                        );
                      },
                    );
                    //
                  },
                  shape: CircleBorder(),
                  backgroundColor: ColorsResources.darkPrimary,
                  foregroundColor: ColorsResources.onPrimary,
                  child: Icon(Icons.add_comment_outlined),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
                body: Padding(
                  padding: EdgeInsets.all(SizesResources.s2),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          // video player
                          ChewiePlayerWidget(videoUrl: state.video!.url),
                          //
                          Padding(padding: EdgeInsets.only(top: SizesResources.s3)),
                          // list of views ,your rating ,rating ,rating num
                          UnderVideoWidget(
                            views: state.video!.views,
                            videoId: state.video!.id,
                            rating: state.video!.rating,
                            ratingNum: state.video!.ratingNum,
                            myRate: state.myRating?.rating ?? -1,
                          ),
                          //
                          Padding(padding: EdgeInsets.only(top: SizesResources.s6)),
                        ],
                      ),
                      Expanded(
                        child: state.isLoading[Loading.comment] == true
                            ? Center(
                                child: CupertinoActivityIndicator(
                                  color: ColorsResources.primary,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // comment num
                                  Text(
                                    'التعليقات (${state.comments?.length})',
                                    style: FontsResources.styleExtraBold(size: 18),
                                  ),
                                  //
                                  Padding(padding: EdgeInsets.only(top: SizesResources.s3)),
                                  // commnet list,
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: state.comments?.length,
                                      itemBuilder: (context, commentIndex) {
                                        final videoBloc = context.read<VideoBloc>();
                                        return BlocProvider.value(
                                          value: videoBloc,
                                          child: VideoCommentWidget(
                                            username: state.comments![commentIndex].username,
                                            commentText: state.comments![commentIndex].comment,
                                            fromTime: timeAgo(state.comments![commentIndex].createdAt),
                                            buttonWidget: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                TextButton.icon(
                                                  icon: Icon(
                                                    Icons.arrow_forward,
                                                    color: ColorsResources.primary,
                                                  ),
                                                  iconAlignment: IconAlignment.end,
                                                  onPressed: () async {
                                                    context.read<VideoBloc>().add(LoadReplies(commentId: state.comments![commentIndex].id));
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      useSafeArea: true,
                                                      builder: (ctx) {
                                                        return BlocProvider.value(
                                                          value: videoBloc,
                                                          child: AddReplyBottomSheetWidget(
                                                            comment: state.comments![commentIndex],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  label: Text("الردود (${state.comments![commentIndex].repliesNum})"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              );
            }
            //
            return Scaffold(body: SizedBox());
          },
        ),
      ),
    );
  }
}
