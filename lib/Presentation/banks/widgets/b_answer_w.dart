import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:moatmat_app/Features/banks/domain/entites/b_question_answer.dart';
import 'package:moatmat_app/Features/tests/domain/entities/answer.dart';
import 'package:moatmat_app/Presentation/tests/widgets/answer_body_w.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../tests/widgets/answer_w.dart';

class BankQuestionAnswerWidget extends StatefulWidget {
  const BankQuestionAnswerWidget({
    super.key,
    required this.answer,
    required this.onAnswer,
    this.selected,
  });
  final bool? selected;
  final Answer answer;
  final VoidCallback onAnswer;

  @override
  State<BankQuestionAnswerWidget> createState() =>
      _BankQuestionAnswerWidgetState();
}

class _BankQuestionAnswerWidgetState extends State<BankQuestionAnswerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BankQuestionAnswerWidget oldWidget) {
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
          ),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onAnswer(),
              onTapDown: (details) {
                HapticFeedback.lightImpact();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s3,
                  horizontal: SpacingResources.sidePadding / 2,
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 35,
                    ),
                    Expanded(
                      flex: 5,
                      child: AnswerBodyWidget(
                        answer: widget.answer,
                      ),
                    ),
                    SizedBox(
                      width: 35,
                      child: (widget.answer.trueAnswer ?? false)
                          ? getCorrectWidget()
                          : getWrongWidget(),
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
    if (widget.selected == false && widget.answer.trueAnswer == false) {
      return const SizedBox();
    }

    return const SizedBox(
      width: 35,
      child: CircleAvatar(
        radius: 10,
        backgroundColor: ColorsResources.green,
        child: Icon(
          Icons.check,
          size: 10,
          color: ColorsResources.onPrimary,
        ),
      ),
    );
  }

  Widget getWrongWidget() {
    if (widget.selected == null) {
      return const SizedBox();
    }
    if (widget.selected == false && widget.answer.trueAnswer == false) {
      return const SizedBox();
    }
    return const SizedBox(
      width: 35,
      child: CircleAvatar(
        radius: 10,
        backgroundColor: Colors.red,
        child: Icon(
          Icons.close,
          size: 10,
          color: ColorsResources.onPrimary,
        ),
      ),
    );
  }
}
