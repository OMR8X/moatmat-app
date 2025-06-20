import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/functions/parsers/format_views.dart';
import 'package:moatmat_app/User/Presentation/videos/state/myRatingToVideoCubit/my_rating_to_video_cubit.dart';
import 'package:moatmat_app/User/Presentation/videos/widget/video_icons_w.dart';

class UnderVideoWidget extends StatefulWidget {
  const UnderVideoWidget({
    super.key,
    required this.views,
    required this.videoId,
    required this.rating,
    required this.ratingNum,
  });
  final int views;
  final int videoId;
  final double rating;
  final int ratingNum;

  @override
  State<UnderVideoWidget> createState() => _UnderVideoWidgetState();
}

class _UnderVideoWidgetState extends State<UnderVideoWidget> {
  @override
  void initState() {
    super.initState();
    context.read<MyRatingToVideoCubit>().init(videoId: widget.videoId);
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //
          VideoIconsWidget(
            text1: '${widget.rating}/5 (${widget.ratingNum})',
            text2: 'التقييم',
            icon: Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
          //
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.grey,
          ),
          //
          BlocBuilder<MyRatingToVideoCubit, MyRatingToVideoState>(
            builder: (context, state) {
              if (state is MyRatingToVideoLoaded) {
                return VideoIconsWidget(
                  text1: state.myRating != -1 ? "${state.myRating}/5" : "إضافة تقييم",
                  text2: state.myRating != -1 ? "تقييمك" : "",
                  icon: Icon(
                    state.myRating != -1 ? Icons.star : Icons.star_border,
                    color: state.myRating != -1 ? Colors.amber : Colors.grey,
                  ),
                );
              } else if (state is MyRatingToVideoError) {
                return VideoIconsWidget(
                  text1: "حدث خطأ",
                  text2: "",
                  icon: Icon(
                    Icons.warning,
                    color: Colors.grey,
                  ),
                );
              }
              return CupertinoActivityIndicator(
                color: Colors.white,
              );
            },
          ),
          //
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.grey,
          ),
          //
          VideoIconsWidget(
            text1: formatViews(widget.views),
            text2: "المشاهدات",
            icon: Icon(Icons.visibility_outlined),
          ),
          //
        ],
      ),
    );
  }
}
