import 'package:flutter/material.dart';
import 'package:flutter_math_fork/ast.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Presentation/tests/widgets/answer_w.dart';
import 'package:moatmat_app/User/Presentation/tests/widgets/question_body_w.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/widgets/math/question_body_w.dart';
import '../../../Features/auth/domain/entites/user_data.dart';
import '../../../Features/tests/domain/entities/question.dart';

class TestQuestionBox extends StatefulWidget {
  const TestQuestionBox({
    super.key,
    required this.question,
    this.didAnswer = false,
    required this.onLike,
    required this.onShare,
    required this.onReport,
    required this.onShowAnswer,
    required this.testID,
    required this.onUnLike,
    this.disableExplain = false,
  });
  final int testID;
  final Question question;
  final bool didAnswer, disableExplain;
  final VoidCallback onShare;
  final VoidCallback onReport;
  final VoidCallback onShowAnswer;
  final Function(bool like) onLike;
  final Function(bool like) onUnLike;

  @override
  State<TestQuestionBox> createState() => _TestQuestionBoxState();
}

class _TestQuestionBoxState extends State<TestQuestionBox> {
  bool didAnswer = false;
  bool liked = false;
  @override
  void initState() {
    didAnswer = didAnswer;
    checkLiked();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TestQuestionBox oldWidget) {
    if (didAnswer == widget.didAnswer) return;
    setState(() {
      didAnswer = widget.didAnswer;
    });
    checkLiked();
    super.didUpdateWidget(oldWidget);
  }

  checkLiked() {
    var likes = locator<UserData>().likes;
    bool isLiked = false;
    for (var l in likes) {
      if (l.tQuestion?.id == widget.question.id) {
        if ((l.testId) == widget.testID) {
          isLiked = true;
          break;
        }
      }
    }
    setState(() {
      liked = isLiked;
    });
  }

  @override
  void didChangeDependencies() {
    if (didAnswer == widget.didAnswer) return;
    setState(() {
      didAnswer = widget.didAnswer;
    });
    checkLiked();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s2,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: SizesResources.s2,
            horizontal: SpacingResources.sidePadding / 2,
          ),
          width: SpacingResources.mainWidth(context),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: ShadowsResources.mainBoxShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopItems(
                liked: liked,
                onShare: widget.onShare,
                onReport: widget.onReport,
                onLike: (b) {
                  if (b) {
                    widget.onLike(b);
                  } else {
                    widget.onUnLike(b);
                  }
                  setState(() {
                    liked = b;
                  });
                },
              ),
              QuestionBodyWidget(question: widget.question),
              const SizedBox(height: SizesResources.s2),
              if (didAnswer &&
                  (widget.question.explain != null) &&
                  (widget.question.explain!.isNotEmpty) &&
                  (!widget.disableExplain))
                IconButton(
                  onPressed: widget.onShowAnswer,
                  icon: const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: ColorsResources.blackText2,
                  ),
                ),
              const SizedBox(height: SizesResources.s2),
            ],
          ),
        ),
      ],
    );
  }
}

// class TestQuestionBodyWidget extends StatelessWidget {
//   const TestQuestionBodyWidget({
//     super.key,
//     required this.question,
//     this.disableOpenImage = false,
//   });
//   final Question question;
//   final bool disableOpenImage;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (question.image != null && question.image!.isNotEmpty)
//           Column(
//             children: [
//               const SizedBox(height: SizesResources.s2),
//               GestureDetector(
//                 onTap: () {
//                   if (disableOpenImage) return;
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           ExploreImage(image: question.image!),
//                     ),
//                   );
//                 },
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     question.image!,
//                     width: SpacingResources.mainWidth(context) - 50,
//                     fit: BoxFit.fitWidth,
//                     frameBuilder:
//                         (context, child, frame, wasSynchronouslyLoaded) {
//                       if (frame == null) {
//                         return SizedBox(
//                           width: SpacingResources.mainWidth(context) - 50,
//                           height: 200,
//                           child: Shimmer.fromColors(
//                               baseColor: Colors.grey[400]!,
//                               highlightColor: Colors.grey[300]!,
//                               child: const SizedBox(
//                                 width: 200,
//                                 height: 100,
//                                 // color: ColorsResources.background,
//                               )),
//                         );
//                       } else {
//                         return SizedBox(
//                           child: child,
//                         );
//                       }
//                     },
//                     loadingBuilder: (context, child, p) {
//                       if (p == null) {
//                         return child;
//                       } else {
//                         return SizedBox(
//                           width: SpacingResources.mainWidth(context) - 50,
//                           height: 200,
//                           child: Shimmer.fromColors(
//                               baseColor: Colors.grey[400]!,
//                               highlightColor: Colors.grey[300]!,
//                               child: Container(
//                                 width: 200,
//                                 height: 100,
//                                 color: ColorsResources.background,
//                               )),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: SizesResources.s3),
//             ],
//           ),
//         if (question.question != null)
//           SizedBox(
//             child: Text(
//               question.question!,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 letterSpacing: 0.2,
//                 height: 1.6,
//                 color: ColorsResources.blackText1,
//               ),
//             ),
//           ),
//         if (question.equation != null &&
//             question.equation != "" &&
//             question.question != null &&
//             question.question != "")
//           const SizedBox(height: SizesResources.s3),
//         if (question.equation != null) ...[
//           SizedBox(
//             width: SpacingResources.mainWidth(context),
//             child: RichText(
//               text: TextSpan(
//                 style: const TextStyle(
//                   fontSize: 14.0,
//                   color: Colors.black,
//                   fontFamily: "Almarai",
//                   height: 2,
//                 ),
//                 children: List.generate(
//                   fixTheError(question.equation!).length,
//                   (index) {
//                     if (!containsArabic(
//                         fixTheError(question.equation!)[index])) {
//                       return WidgetSpan(
//                         alignment: PlaceholderAlignment.middle,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 2.5,
//                             vertical: 2,
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 5),
//                             child: SizedBox(
//                               child: Math.tex(
//                                 fixTheError(question.equation!)[index],
//                                 textStyle: const TextStyle(fontSize: 17),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     } else {
//                       return TextSpan(
//                         text: " ${fixTheError(question.equation!)[index]}  ",
//                         style: const TextStyle(fontSize: 14),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ]
//       ],
//     );
//   }
// }

class TopItems extends StatelessWidget {
  const TopItems({
    super.key,
    required this.onShare,
    required this.onReport,
    required this.onLike,
    required this.liked,
  });
  final bool liked;
  final VoidCallback onShare;
  final VoidCallback onReport;
  final Function(bool like) onLike;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: onReport,
          icon: const Icon(
            Icons.report_problem_outlined,
            size: 18,
            color: ColorsResources.blackText2,
          ),
        ),
        IconButton(
          onPressed: onShare,
          icon: const Icon(
            Icons.share,
            size: 16,
            color: ColorsResources.blackText2,
          ),
        ),
        IconButton(
          onPressed: () {
            onLike(!liked);
          },
          icon: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            size: 16,
            color: liked ? Colors.red : ColorsResources.blackText2,
          ),
        ),
      ],
    );
  }
}

class ExploreImage extends StatelessWidget {
  const ExploreImage({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: SpacingResources.mainWidth(context),
          height: MediaQuery.sizeOf(context).height,
          child: InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(100),
            minScale: 0.5,
            maxScale: 2,
            child: Image.network(
              image,
            ),
          ),
        ),
      ),
    );
  }
}
