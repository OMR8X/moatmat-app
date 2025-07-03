import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/functions/parsers/format_views.dart';
import 'package:moatmat_app/User/Presentation/videos/state/VideoBloc/video_bloc.dart';
import 'package:moatmat_app/User/Presentation/videos/widget/add_rating_bottom_sheet_w.dart';
import 'package:moatmat_app/User/Presentation/videos/widget/video_icons_w.dart';

class UnderVideoWidget extends StatefulWidget {
  const UnderVideoWidget({
    super.key,
    required this.views,
    required this.videoId,
    required this.rating,
    required this.ratingNum,
    required this.myRate,
  });
  final int views;
  final int videoId;
  final double rating;
  final int ratingNum;
  final int myRate;

  @override
  State<UnderVideoWidget> createState() => _UnderVideoWidgetState();
}

class _UnderVideoWidgetState extends State<UnderVideoWidget> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //
          VideoIconsWidget(
            text1: '${widget.rating}', // /5 (${widget.ratingNum})
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
          VideoIconsWidget(
            text1: widget.myRate != -1 ? "${widget.myRate}/5" : "إضافة تقييم",
            text2: widget.myRate != -1 ? "تقييمك" : "",
            icon: widget.myRate != -1
                ? Icon(
                    Icons.star,
                    color: Colors.amber,
                  )
                : Icon(
                    Icons.star_border,
                    color: Colors.grey,
                  ),
            onPressed: widget.myRate != -1
                ? null
                : () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) {
                        return BlocProvider.value(
                          value: context.read<VideoBloc>(),
                          child: AddRatingBottomSheetWidget(),
                        );
                      },
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
