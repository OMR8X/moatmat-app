import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/Presentation/banks/state/per_question_explore/per_question_explore_cubit.dart';
import 'package:moatmat_app/Presentation/banks/views/list_of_answers_v.dart';
import 'package:moatmat_app/Presentation/banks/views/question_v.dart';
import 'package:moatmat_app/Presentation/banks/views/result_v.dart';

import '../../../auth/state/auth_c/auth_cubit_cubit.dart';
import '../../../auth/view/auth_views_manager.dart';

class PerQuestionExploreView extends StatefulWidget {
  const PerQuestionExploreView({
    super.key,
    required this.seconds,
    required this.bank,
  });
  final int seconds;
  final Bank bank;
  @override
  State<PerQuestionExploreView> createState() => _PerQuestionExploreViewState();
}

class _PerQuestionExploreViewState extends State<PerQuestionExploreView> {
  @override
  void initState() {
    context.read<AuthCubit>().onCheck();
    context.read<PerQuestionExploreCubit>().init(widget.bank, widget.seconds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<PerQuestionExploreCubit>();
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
        body: BlocBuilder<PerQuestionExploreCubit, PerQuestionExploreState>(
          builder: (context, state) {
            if (state is PerQuestionExploreQuestion) {
              return BankQuestionView(
                onExit: () {
                  context.read<PerQuestionExploreCubit>().finish();
                },
                bank: widget.bank,
                title: "${state.currentQ + 1} / ${state.length}",
                time: state.time,
                question: state.question.$1,
                selected: state.question.$2,
                showPrevious: state.currentQ > 0,
                showNext: true,
                onNext: cubit.nextQuestion,
                onPrevious: cubit.previousQuestion,
                onPop: () => Navigator.of(context).pop(),
                onAnswer: (question, selected) {
                  context.read<PerQuestionExploreCubit>().answerQuestion(
                    state.currentQ,
                    (question, selected),
                  );
                },
              );
            } else if (state is PerQuestionExploreResult) {
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
                  context
                      .read<PerQuestionExploreCubit>()
                      .init(widget.bank, widget.seconds);
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
