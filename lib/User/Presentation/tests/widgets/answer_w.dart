import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/answer.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';

class TestQuestionAnswerWidget extends StatefulWidget {
  const TestQuestionAnswerWidget({
    super.key,
    required this.answer,
    required this.onAnswer,
    this.selected,
    this.canChange = false,
  });
  final bool? selected;
  final bool canChange;
  final TestAnswer answer;
  final VoidCallback onAnswer;

  @override
  State<TestQuestionAnswerWidget> createState() =>
      _TestQuestionAnswerWidgetState();
}

class _TestQuestionAnswerWidgetState extends State<TestQuestionAnswerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TestQuestionAnswerWidget oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  Function()? onAnswer() {
    if (widget.selected == null) {
      return widget.onAnswer;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s1,
          ),
          width: SpacingResources.mainWidth(context),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: ShadowsResources.mainBoxShadow,
            border: widget.selected == true
                ? Border.all(
                    color: ColorsResources.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTapDown: (details) {
                HapticFeedback.lightImpact();
              },
              onTap: widget.canChange
                  ? () {
                      widget.onAnswer();
                    }
                  : onAnswer(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s3,
                  horizontal: SizesResources.s4,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        widget.answer.answer,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getCorrectWidget() {
    if (widget.selected == null) {
      return const SizedBox();
    }
    if (widget.selected == false && widget.answer.isCorrect == false) {
      return const SizedBox();
    }

    return const CircleAvatar(
      radius: 14,
      backgroundColor: ColorsResources.green,
      child: Icon(
        Icons.check,
        size: 14,
        color: ColorsResources.onPrimary,
      ),
    );
  }

  Widget getWrongWidget() {
    if (widget.selected == null) {
      return const SizedBox();
    }
    if (widget.selected == false && widget.answer.isCorrect == false) {
      return const SizedBox();
    }
    return const CircleAvatar(
      radius: 14,
      backgroundColor: Colors.red,
      child: Icon(
        Icons.close,
        size: 14,
        color: ColorsResources.onPrimary,
      ),
    );
  }
}
