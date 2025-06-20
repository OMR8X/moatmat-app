import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/functions/parsers/time_ago.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/fonts_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/resources/supabase_r.dart';
import 'package:moatmat_app/User/Presentation/auth/view/error_v.dart';
import 'package:moatmat_app/User/Presentation/videos/state/commentCubit/comment_cubit.dart';
import 'package:moatmat_app/User/Presentation/videos/state/videoCubit/video_cubit.dart';
import 'package:moatmat_app/User/Presentation/videos/widget/under_video_w.dart';
import 'package:moatmat_app/User/Presentation/videos/widget/video_comment_w.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  void fun() async {
    // var user = Supabase.instance.client.auth.currentUser;
    // SupabaseClient client = SupabaseClient(SupabaseResources.url, SupabaseResources.key);
    // for (int i = 1; i < 6; i++) {
    //   var res = await client.from('comment').update({
    //     "user_id":user!.id,
    //     "video_id":1,
    //     "comment_text":"محتوى التعليق بشكل عام او خاص غير مهم محتوى التعليق بشكل عام او خاص غير مهممحتوى التعليق بشكل عام او خاص غير مهم",
    //   }).eq('id', i);
    //   print(res);
    // }
  }

  @override
  void initState() {
    super.initState();
    context.read<VideoCubit>().init(1);
    context.read<CommentCubit>().init(1);
  }

  @override
  Widget build(BuildContext context) {
    // fun();
    return Scaffold(
      backgroundColor: ColorsResources.onPrimary,
      appBar: AppBar(
        title: Text("عنوان الفيديو"),
        backgroundColor: ColorsResources.onPrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // TODO: for testing
          // context.read<CommentCubit>().addComment(
          //       commentText: "try 1 to add comment on video",
          //       videoId: 1,
          //     );
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
            BlocConsumer<VideoCubit, VideoState>(
              listener: (context, state) {
                //
              },
              builder: (context, state) {
                if (state is VideoLoaded) {
                  return Column(
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
                        views: state.video.views,
                        videoId: state.video.id,
                        rating: state.video.rating,
                        ratingNum: state.video.ratingNum,
                      ),
                      //
                      Padding(padding: EdgeInsets.only(top: SizesResources.s6)),
                    ],
                  );
                } else if (state is VideoError) {
                  return ErrorView(error: state.msg);
                }
                return Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                  ),
                );
              },
            ),
            Expanded(
              child: BlocConsumer<CommentCubit, CommentState>(
                listener: (context, state) {
                  if (state is CommentError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.msg)),
                    );
                  } else if (state is CommentSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.msg)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CommentLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // comment num
                        Text(
                          'التعليقات (${state.comments.length})',
                          style: FontsResources.styleExtraBold(size: 18),
                        ),
                        //
                        Padding(padding: EdgeInsets.only(top: SizesResources.s3)),
                        // commnet list,
                        Expanded(
                          child: ListView.builder(
                              itemCount: state.comments.length,
                              itemBuilder: (context, commentIndex) {
                                return VideoCommentWidget(
                                  username: state.comments[commentIndex].username,
                                  commentText: state.comments[commentIndex].comment,
                                  fromTime: timeAgo(state.comments[commentIndex].createdAt),
                                  repliesNum: state.comments[commentIndex].repliesNum,
                                  onTapOnReplies: () {
                                    // TODO: another page to add reply
                                  },
                                );
                              }),
                        ),
                      ],
                    );
                  } else if (state is CommentError) {
                    return ErrorView(error: state.msg);
                  }
                  return Center(
                    child: CupertinoActivityIndicator(
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
