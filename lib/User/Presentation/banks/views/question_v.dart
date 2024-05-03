import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:moatmat_app/User/Core/functions/show_answer.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/services/deep_links_s.dart';
import 'package:moatmat_app/User/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_like.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_q.dart';
import 'package:moatmat_app/User/Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import 'package:moatmat_app/User/Presentation/banks/widgets/b_answer_w.dart';
import 'package:moatmat_app/User/Presentation/banks/widgets/bank_q_box.dart';
import 'package:moatmat_app/User/Presentation/banks/widgets/explore_question_appbar_w.dart';

import '../../../Core/functions/report.dart';
import '../../../Features/tests/domain/entities/question.dart';

class BankQuestionView extends StatefulWidget {
  const BankQuestionView({
    super.key,
    required this.question,
    this.selected,
    required this.onAnswer,
    required this.onPop,
    required this.onNext,
    required this.onPrevious,
    this.showNext,
    this.showPrevious,
    this.disableActions,
    required this.title,
    this.time,
    required this.bank,
  });
  final Bank bank;
  final String title;
  final Duration? time;
  final Question question;
  final int? selected;
  final bool? showNext, showPrevious, disableActions;
  final VoidCallback onPop;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(Question question, int? selected) onAnswer;

  @override
  State<BankQuestionView> createState() => _BankQuestionViewState();
}

class _BankQuestionViewState extends State<BankQuestionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      body: Column(
        children: [
          ExploreQuestionAppBarWidget(
            onPop: widget.onPop,
            title: widget.title,
            time: widget.time,
          ),
          BankQuestionBodyElements(
            bank: widget.bank,
            question: widget.question,
            selected: widget.selected,
            onNext: widget.onNext,
            onPrevious: widget.onPrevious,
            showNext: widget.showNext,
            showPrevious: widget.showPrevious,
            disableActions: widget.disableActions,
            onAnswer: (selected) {
              widget.onAnswer(widget.question, selected);
            },
          ),
        ],
      ),
    );
  }
}

class BankQuestionBodyElements extends StatelessWidget {
  const BankQuestionBodyElements({
    super.key,
    required this.question,
    this.selected,
    required this.onAnswer,
    required this.onNext,
    required this.onPrevious,
    this.showNext,
    this.showPrevious,
    this.disableActions,
    required this.bank,
  });
  final Bank bank;
  final int? selected;
  final Question question;
  final Function(int selected) onAnswer;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool? showNext, showPrevious, disableActions;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        decoration: const BoxDecoration(
          color: ColorsResources.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(48),
            topRight: Radius.circular(48),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(48),
            topRight: Radius.circular(48),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: SizesResources.s6),
            itemCount: question.answers.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    BankQuestionBox(
                      bankID: bank.id,
                      question: question,
                      onUnLike: (v) {
                        var like = UserLike(
                          id: 0,
                          bankId: bank.id,
                          testId: null,
                          bQuestion: question,
                          tQuestion: null,
                        );
                        context.read<AuthCubit>().unLike(like: like);
                      },
                      onLike: (v) {
                        var like = UserLike(
                          id: 0,
                          bankId: bank.id,
                          testId: null,
                          bQuestion: question,
                          tQuestion: null,
                        );
                        context.read<AuthCubit>().like(like: like);
                      },
                      onShare: () async {
                        await DeepLinkService.createDynamicLink(
                          bankId: bank.id,
                          context: context,
                          questionId: question.id,
                        );
                      },
                      onReport: (int id) {
                        reportOnQuestion(
                          context: context,
                          id: bank.id,
                          bQuestion: question,
                          name: bank.information.title,
                          teacherEmail: bank.teacherEmail,
                        );
                      },
                      onShowAnswer: () {
                        showExplain(question, context);
                      },
                      didAnswer: selected != null,
                    ),
                    BankQuestionAnswerWidget(
                      answer: question.answers[index],
                      onAnswer: () {
                        onAnswer(index);
                      },
                      selected: selected != null ? selected == index : null,
                    ),
                  ],
                );
              } else {
                if (index == question.answers.length - 1) {
                  return Column(
                    children: [
                      BankQuestionAnswerWidget(
                        answer: question.answers[index],
                        onAnswer: () {
                          onAnswer(index);
                        },
                        selected: selected != null ? selected == index : null,
                      ),
                      getActions(selected != null, context),
                    ],
                  );
                } else {
                  return BankQuestionAnswerWidget(
                    answer: question.answers[index],
                    onAnswer: () {
                      onAnswer(index);
                    },
                    selected: selected != null ? selected == index : null,
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget getActions(bool didAnswer, BuildContext context) {
    if (disableActions == true) return const SizedBox();
    if (didAnswer || disableActions == false) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: SizesResources.s4),
        child: SizedBox(
          width: SpacingResources.mainWidth(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButtonWidget(
                text: "السابق",
                width: SpacingResources.mainHalfWidth(context),
                onPressed: showPrevious == true ? onPrevious : null,
              ),
              const Spacer(),
              ElevatedButtonWidget(
                text: "التالي",
                width: SpacingResources.mainHalfWidth(context),
                onPressed: showNext == true ? onNext : null,
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

class TopElements extends StatelessWidget {
  const TopElements({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.transparent,
      ),
    );
  }
}
