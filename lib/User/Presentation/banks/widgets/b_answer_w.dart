import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/b_question_answer.dart';

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
              onTapDown: (details) {
                HapticFeedback.lightImpact();
              },
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
                      child: getContentWidget(),
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

  Widget getContentWidget() {
    List<Widget> widgets = [];
    if (widget.answer.answer != null) {
      widgets.add(
        Text(
          widget.answer.answer!,
          textAlign: TextAlign.center,
        ),
      );
    }
    if (widget.answer.equation != null) {
      widgets.add(
        Center(
          child: SizedBox(
            width: SpacingResources.mainWidth(context) - (SizesResources.s8),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontFamily: "Almarai",
                  height: 2,
                ),
                children: List.generate(
                  fixTheError(widget.answer.equation!).length,
                  (index) {
                    if (!containsArabic(
                        fixTheError(widget.answer.equation!)[index])) {
                      return WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: SizedBox(
                          child: Math.tex(
                            fixTheError(widget.answer.equation!)[index],
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    } else {
                      return TextSpan(
                        text:
                            " ${fixTheError(widget.answer.equation!)[index]}  ",
                        style: const TextStyle(fontSize: 14),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      children: widgets,
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
