import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/fonts_r.dart';

class VideoCommentWidget extends StatelessWidget {
  const VideoCommentWidget({
    super.key,
    required this.username,
    required this.commentText,
    required this.fromTime,
    required this.buttonWidget,
  });
  final String username;
  final String commentText;
  final String fromTime;
  final Widget buttonWidget;

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
        buttonWidget,
        Divider(),
      ],
    );
  }
}
