import 'package:flutter/material.dart';
import 'package:moatmat_app/Core/widgets/view/question_explain_v.dart';
import 'package:moatmat_app/Features/tests/domain/entities/question.dart';

showExplain(Question question, BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => QuestionExplainView(question: question),
    ),
  );

  // showDialog(
  //   context: context,
  //   builder: (context) => AlertDialog(
  //     title: const Text("التعليل"),
  //     content: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         if (question.video != null) ...[
  //           const SizedBox(height: SizesResources.s4),
  //           SizedBox(
  //               width: 300,
  //               height: 170,
  //               child: VideoPlayerWidget(
  //                 flickManager: flickManager,
  //               ))
  //         ],
  //         if (question.explain != null)
  //           SizedBox(
  //             child: Text(
  //               question.explain!,
  //               textAlign: TextAlign.start,
  //             ),
  //           ),
  //       ],
  //     ),
  //     actions: [
  //       TextButton(
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //         child: const Text("حسنا"),
  //       ),
  //     ],
  //   ),
  // ).then((value) => flickManager.dispose());
}
