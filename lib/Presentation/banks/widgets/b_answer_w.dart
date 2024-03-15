import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/b_question_answer.dart';

import '../../../User/Core/resources/colors_r.dart';
import '../../../User/Core/resources/shadows_r.dart';
import '../../../User/Core/resources/sizes_resources.dart';
import '../../../User/Core/resources/spacing_resources.dart';

class BankQuestionAnswerWidget extends StatefulWidget {
  const BankQuestionAnswerWidget({
    super.key,
    required this.answer,
    required this.onAnswer,
    this.selected,
  });
  final bool? selected;
  final BankAnswer answer;
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s3,
                  horizontal: SizesResources.s4,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Opacity(
                        opacity: 0,
                        child: CircleAvatar(
                          radius: 14,
                          child: Icon(
                            Icons.check,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        widget.answer.answer,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Opacity(
                        opacity: 1,
                        child: widget.answer.isCorrect
                            ? getCorrectWidget()
                            : getWrongWidget(),
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
