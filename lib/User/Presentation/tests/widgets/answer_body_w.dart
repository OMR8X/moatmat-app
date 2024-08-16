import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/widgets/math/question_body_w.dart';
import '../../../Features/tests/domain/entities/answer.dart';
import 'test_q_box.dart';

class AnswerBodyWidget extends StatefulWidget {
  const AnswerBodyWidget({super.key, required this.answer});
  final Answer answer;

  @override
  State<AnswerBodyWidget> createState() => _AnswerBodyWidgetState();
}

class _AnswerBodyWidgetState extends State<AnswerBodyWidget> {
  @override
  void didUpdateWidget(covariant AnswerBodyWidget oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //
            if (widget.answer.image != null && widget.answer.image != "") ...[
              AnswerImageBuilderWidget(image: widget.answer.image!),
              const SizedBox(height: SizesResources.s2),
            ],
            //
            if (widget.answer.text != null && widget.answer.text != "") ...[
              QuestionTextBuilderWidget(
                text: widget.answer.text!,
                equations: widget.answer.equations ?? [],
                colors: const [],
              ),
            ],

            //
          ],
        ),
      ],
    );
  }
}

class AnswerImageBuilderWidget extends StatelessWidget {
  const AnswerImageBuilderWidget({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    if (image.contains("supabase")) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExploreImage(image: image),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            image,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: SpacingResources.mainWidth(context) - 120,
                  height: 150,
                  color: Colors.grey[300],
                ),
              );
            },
            width: SpacingResources.mainWidth(context) - 120,
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExploreImage(image: image),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            image,
            width: SpacingResources.mainWidth(context) / 2,
          ),
        ),
      );
    }
  }
}
