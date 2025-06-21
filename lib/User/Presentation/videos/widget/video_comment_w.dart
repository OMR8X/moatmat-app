import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/fonts_r.dart';

class VideoCommentWidget extends StatelessWidget {
  const VideoCommentWidget({
    super.key,
    required this.username,
    required this.commentText,
    required this.fromTime,
    required this.repliesNum,
    this.onTapOnReplies,
  });
  final String username;
  final String commentText;
  final String fromTime;
  final int repliesNum;
  final void Function()? onTapOnReplies;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
        children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                username,
                style: FontsResources.styleBold(),
              ),
              Text(
                fromTime,
                style: FontsResources.lightStyle(),
              ),
            ],
          ),
          subtitle: Text(
            commentText,
            style: FontsResources.styleMedium(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
              icon: Icon(
                Icons.arrow_forward,
                color: ColorsResources.primary,
              ),
              iconAlignment: IconAlignment.end,
              onPressed: onTapOnReplies,
              label: Text("الردود ($repliesNum)"),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
