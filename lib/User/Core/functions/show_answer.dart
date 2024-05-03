import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/question.dart';

import '../../Presentation/videos/view/video_player_v.dart';
import '../../Presentation/videos/view/video_player_w.dart';
import '../resources/sizes_resources.dart';

showExplain(Question question, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("التعليل"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (question.video != null) ...[
            const SizedBox(height: SizesResources.s4),
            VideoPlayerWidget(
              link: question.video!,
            ),
          ],
          if (question.explain != null)
            SizedBox(
              child: Text(
                question.explain!,
                textAlign: TextAlign.start,
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("حسنا"),
        ),
      ],
    ),
  );
}
