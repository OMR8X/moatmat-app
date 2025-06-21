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
import 'package:moatmat_app/User/Presentation/videos/widget/add_comment_bottom_sheet_w.dart';
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
    return BlocProvider(
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
                color: Colors.white,
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
                title: Text("عنوان الفيديو"),
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
                        Container(
                          height: SpacingResources.mainWidth(context) * (9.0 / 16.0),
                          width: SpacingResources.mainWidth(context),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 13, 36),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Icon(
                                Icons.play_circle,
                                color: ColorsResources.onPrimary,
                              ),
                            ),
                          ),
                        ),
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
                                      return VideoCommentWidget(
                                        username: state.comments![commentIndex].username,
                                        commentText: state.comments![commentIndex].comment,
                                        fromTime: timeAgo(state.comments![commentIndex].createdAt),
                                        repliesNum: state.comments![commentIndex].repliesNum,
                                        onTapOnReplies: () {
                                          // TODO: another page to add reply
                                        },
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
    );
  }
}
