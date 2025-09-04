import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';
import 'package:moatmat_app/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/Core/widgets/ui/divider_w.dart';
import 'package:moatmat_app/Features/tests/domain/entities/question.dart';
import 'package:moatmat_app/Presentation/banks/views/question_v.dart';
import 'package:moatmat_app/Presentation/banks/widgets/bank_q_box.dart';
import 'package:moatmat_app/Presentation/questions/widgets/answer_item_widget.dart';
import 'package:moatmat_app/Presentation/questions/widgets/question_item_widget.dart';
import 'package:moatmat_app/Presentation/tests/widgets/answer_body_w.dart';
import 'package:moatmat_app/Presentation/tests/widgets/answer_w.dart';

import '../../../Core/functions/parsers/num_to_latter.dart';
import '../../../Core/functions/show_answer.dart';
import '../../../Core/widgets/toucheable_tile_widget.dart';
import '../../../Core/widgets/ui/empty_list_text.dart';
import '../state/results/my_results_cubit.dart';

class ResultView extends StatelessWidget {
  const ResultView({
    super.key,
    required this.questions,
    required this.showTrueAnswers,
    required this.mark,
  });
  final bool showTrueAnswers;
  final double mark;
  final List<(Question?, int?)> questions;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.read<MyResultsCubit>().backToResults();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تفاصيل النتيجة"),
          centerTitle: false,
          leading: IconButton(
              onPressed: () {
                context.read<MyResultsCubit>().backToResults();
              },
              icon: Icon(
                Icons.arrow_back_ios,
              )),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text("نتيجتك : %${mark.toStringAsFixed(1)}"),
            ),
          ],
        ),
        body: questions.first.$1 != null
            ? ListView.separated(
                itemCount: questions.length,
                separatorBuilder: (context, index) {
                  return const DividerWidget();
                },
                itemBuilder: (context, i1) {
                  final q = questions[i1].$1;
                  return Column(children: [
                    BankQuestionBox(
                      question: q!,
                      disableExplain: false,
                      onLike: (like) {},
                      onShare: () {},
                      onReport: (id) {},
                      onShowAnswer: () {
                        showExplain(q, context);
                      },
                      bankID: 1,
                      onUnLike: (like) {},
                      disableActions: true,
                      didAnswer: true,
                    ),
                    // QuestionItemWidget(question: q!),
                    ...List.generate(
                      q.answers.length,
                      (i2) {
                        bool selected = q.answers[i2].id == questions[i1].$2;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TestQuestionAnswerWidget(
                              answer: q.answers[i2],
                              selected: selected,
                              onAnswer: () {},
                              showIsTrue: showTrueAnswers,
                            ),
                          ],
                        );
                      },
                    ),
                    if (questions[i1].$2 == null)
                      const Column(
                        children: [
                          SizedBox(height: SizesResources.s2),
                          Text(
                            "لم يتم اختيار اجابة",
                          ),
                        ],
                      )
                  ]);
                },
              )
            : OuterWrongAnswersBuilder(
                wrongAnswers: questions.map((e) {
                  return e.$2;
                }).toList(),
              ),
      ),
    );
  }
}

class OuterWrongAnswersBuilder extends StatelessWidget {
  const OuterWrongAnswersBuilder({super.key, required this.wrongAnswers});
  final List<int?> wrongAnswers;
  @override
  Widget build(BuildContext context) {
    return wrongAnswers.isEmpty
        ? const EmptyListTextWidget()
        : ListView.builder(
            itemCount: wrongAnswers.length,
            //
            itemBuilder: (context, index) {
              //
              int? selection = wrongAnswers[index];
              //
              if (selection == -1) {
                return const SizedBox();
              }
              return TouchableTileWidget(
                title: "رقم السؤال : ${index + 1}",
                subTitle: getSubTitle(selection),
                icon: Icon(
                  selection == null ? Icons.question_mark : Icons.close,
                  color: selection == null ? Colors.orange : Colors.red,
                ),
              );
            },
          );
  }

  getSubTitle(int? selection) {
    return selection == null ? "لم يتم الاختيار" : "تم اختيار  ${numberToLetter(selection)}";
  }
}
