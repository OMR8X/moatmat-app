import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Presentation/banks/state/full_time_explore/full_time_explore_cubit.dart';
import 'package:moatmat_app/User/Presentation/banks/views/list_of_answers_v.dart';
import 'package:moatmat_app/User/Presentation/banks/views/question_v.dart';
import 'package:moatmat_app/User/Presentation/banks/views/questions_v.dart';
import 'package:moatmat_app/User/Presentation/banks/views/result_v.dart';

import '../../../../Core/functions/show_alert.dart';
import '../../../auth/state/auth_c/auth_cubit_cubit.dart';
import '../../../auth/view/auth_views_manager.dart';

class FullTimeExploreView extends StatefulWidget {
  const FullTimeExploreView({
    super.key,
    required this.minutes,
    required this.bank,
  });
  final int minutes;
  final Bank bank;
  @override
  State<FullTimeExploreView> createState() => _FullTimeExploreViewState();
}

class _FullTimeExploreViewState extends State<FullTimeExploreView> {
  @override
  void initState() {
    context.read<AuthCubit>().onCheck();
    context.read<FullTimeExploreCubit>().init(widget.bank, widget.minutes);
    super.initState();
  }

  showUnsolvedQuestionsAlert(List<int> unsolved) {
    showAlert(
      context: context,
      title: "تاكيد تسليم الاختبار",
      body: "هنالك بعض الاسئلة التي لم تقم بحلها \n(${unsolved.map((e) => e + 1).join(",")})\nهل تريد انهاء و تسليم الاختبار؟",
      agreeBtn: "نعم تسليم الاختبار",
      disagreeBtn: "عودة للاختبار",
      onAgree: () {
        context.read<FullTimeExploreCubit>().finish(force: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedOut) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const AuthViewsManager(),
            ),
          );
        }
      },
      child: Scaffold(
        body: BlocConsumer<FullTimeExploreCubit, FullTimeExploreState>(
          listener: (context, state) {
            if (state is FullTimeExploreQuestionScrollable) {
              if (state.showWarning) {
                showUnsolvedQuestionsAlert(state.unsolved);
              }
            }
            if (state is FullTimeExploreQuestion) {
              if (state.showWarning) {
                showUnsolvedQuestionsAlert(state.unsolved);
              }
            }
          },
          builder: (context, state) {
            final cubit = context.read<FullTimeExploreCubit>();
            if (state is FullTimeExploreQuestion) {
              return BankQuestionView(
                onExit: () {
                  context.read<FullTimeExploreCubit>().finish(force: true);
                },
                bank: widget.bank,
                title: "${state.currentQ + 1} / ${state.length}",
                time: state.time,
                question: state.question.$1,
                selected: state.question.$2,
                showPrevious: state.currentQ > 0,
                showNext: true,
                onNext: () => context.read<FullTimeExploreCubit>().nextQuestion(),
                onPrevious: () => cubit.previousQuestion(index: state.currentQ - 1),
                onPop: () => Navigator.of(context).pop(),
                onAnswer: (question, selected) {
                  context.read<FullTimeExploreCubit>().answerQuestion(
                    state.currentQ,
                    (question, selected),
                  );
                },
              );
            } else if (state is FullTimeExploreQuestionScrollable) {
              return BankQuestionsView(
                onAnswer: (index, question, selected) {
                  context.read<FullTimeExploreCubit>().answerQuestion(
                    index,
                    (question, selected),
                  );
                },
                onPop: () => Navigator.of(context).pop(),
                title: "",
                time: state.time,
                bank: widget.bank,
                onExit: () {
                  context.read<FullTimeExploreCubit>().finish();
                },
                questions: state.questions,
                onFinish: () {
                  context.read<FullTimeExploreCubit>().finish();
                },
              );
            } else if (state is FullTimeExploreResult) {
              return BankResultView(
                showCorrectAnswers: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ListOfBankAnswersView(
                        bank: widget.bank,
                        answers: state.correct,
                      ),
                    ),
                  );
                },
                showWrongAnswers: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ListOfBankAnswersView(
                        bank: widget.bank,
                        answers: state.wrong,
                      ),
                    ),
                  );
                },
                reOpen: () {
                  context.read<FullTimeExploreCubit>().init(widget.bank, widget.minutes);
                },
                backToHome: () {
                  Navigator.of(context).pop();
                },
                correctAnswers: "${state.correct.length}",
                wrongAnswers: "${state.wrong.length}",
                result: state.result,
              );
            }

            return const Center(
              child: CupertinoActivityIndicator(),
            );
          },
        ),
      ),
    );
  }
}
