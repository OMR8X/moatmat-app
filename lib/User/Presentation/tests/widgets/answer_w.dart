import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/answer.dart';
import 'package:moatmat_app/User/Presentation/tests/widgets/answer_body_w.dart';
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
    this.showIsTrue = false,
  });
  final bool? selected;
  final bool canChange;
  final bool showIsTrue;
  final Answer answer;
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
                padding: widget.selected == true
                    ? const EdgeInsets.symmetric(
                        vertical: SizesResources.s3 - 2,
                        horizontal: (SpacingResources.sidePadding / 2) - 2,
                      )
                    : const EdgeInsets.symmetric(
                        vertical: SizesResources.s3,
                        horizontal: (SpacingResources.sidePadding / 2) - 2,
                      ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnswerBodyWidget(answer: widget.answer),
                    if (widget.showIsTrue &&
                        (widget.answer.trueAnswer ?? false))
                      const Icon(
                        Icons.check,
                        color: ColorsResources.green,
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget getContentWidget() {
  //   List<Widget> widgets = [];
  //   if (widget.answer.answer != null && widget.answer.answer != "") {
  //     widgets.add(
  //       SizedBox(
  //         width: SpacingResources.mainWidth(context) - (SizesResources.s8),
  //         child: Text(
  //           widget.answer.answer!,
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     );
  //   }
  //   if ((widget.answer.answer != null && widget.answer.answer != "") &&
  //       (widget.answer.equation != null && widget.answer.equation != "")) {
  //     widgets.add(const SizedBox(height: SizesResources.s3));
  //   }
  //   if (widget.answer.equation != null) {
  //     widgets.add(
  //       Center(
  //         child: SizedBox(
  //           width: SpacingResources.mainWidth(context) - (SizesResources.s8),
  //           child: RichText(
  //             text: TextSpan(
  //               style: const TextStyle(
  //                 fontSize: 14.0,
  //                 color: Colors.black,
  //                 fontFamily: "Almarai",
  //                 height: 2,
  //               ),
  //               children: List.generate(
  //                 fixTheError(widget.answer.equation!).length,
  //                 (index) {
  //                   if (!containsArabic(
  //                       fixTheError(widget.answer.equation!)[index])) {
  //                     return WidgetSpan(
  //                       alignment: PlaceholderAlignment.middle,
  //                       child: SizedBox(
  //                         child: Math.tex(
  //                           fixTheError(widget.answer.equation!)[index],
  //                           textStyle: const TextStyle(fontSize: 17),
  //                         ),
  //                       ),
  //                     );
  //                   } else {
  //                     return TextSpan(
  //                       text:
  //                           " ${fixTheError(widget.answer.equation!)[index]}  ",
  //                       style: const TextStyle(fontSize: 14),
  //                     );
  //                   }
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //   return Column(
  //     children: widgets,
  //   );
  // }

  Widget getCorrectWidget() {
    if (widget.selected == null) {
      return const SizedBox();
    }
    if (widget.selected == false && widget.answer.trueAnswer == false) {
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
    if (widget.selected == false && widget.answer.trueAnswer == false) {
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

bool containsArabic(String word) {
  // Regular expression to match Arabic characters
  RegExp arabicRegExp = RegExp(r'[\u0600-\u06FF]');
  // Check if the word contains any Arabic characters
  return arabicRegExp.hasMatch(word) || word == "\n" || word == ":";
}

List<String> fixTheError(String latexAndArabic) {
  List<String> words = latexAndArabic.split("++++");
  return words;
}
