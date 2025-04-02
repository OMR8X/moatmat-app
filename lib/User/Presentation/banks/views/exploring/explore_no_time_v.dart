import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Presentation/banks/state/no_time_explore/no_time_explore_cubit.dart';
import 'package:moatmat_app/User/Presentation/banks/views/list_of_answers_v.dart';
import 'package:moatmat_app/User/Presentation/banks/views/question_v.dart';
import 'package:moatmat_app/User/Presentation/banks/views/result_v.dart';

import '../../../auth/state/auth_c/auth_cubit_cubit.dart';
import '../../../auth/view/auth_views_manager.dart';
import '../../state/full_time_explore/full_time_explore_cubit.dart';
import '../questions_v.dart';

class ExploreNoTimeView extends StatefulWidget {
  const ExploreNoTimeView({super.key, required this.bank});
  final Bank bank;
  @override
  State<ExploreNoTimeView> createState() => _ExploreNoTimeViewState();
}

class _ExploreNoTimeViewState extends State<ExploreNoTimeView> {
  @override
  void initState() {
    context.read<AuthCubit>().onCheck();
    context.read<NoTimeExploreCubit>().init(widget.bank);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<NoTimeExploreCubit>();
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
        body: BlocBuilder<NoTimeExploreCubit, NoTimeExploreState>(
          builder: (context, state) {
            if (state is NoTimeExploreQuestion) {
              return BankQuestionView(
                onExit: () {
                  print("object");
                  cubit.finish();
                },
                bank: widget.bank,
                title: "${state.currentQ + 1} / ${state.length}",
                question: state.question.$1,
                selected: state.question.$2,
                showPrevious: state.currentQ > 0,
                showNext: true,
                onNext: () {
                  if (state.currentQ == state.length - 1) {
                    cubit.finish();
                  }
                  cubit.getQuestion(index: state.currentQ + 1);
                },
                onPrevious: () => cubit.getQuestion(index: state.currentQ - 1),
                onPop: () => Navigator.of(context).pop(),
                onAnswer: (question, selected) {
                  context.read<NoTimeExploreCubit>().answerQuestion(
                    state.currentQ,
                    (question, selected),
                  );
                },
                disableActions: false,
              );
            } else if (state is NoTimeExploreQuestionScrollable) {
              return BankQuestionsView(
                onAnswer: (index, question, selected) {
                  context.read<NoTimeExploreCubit>().answerQuestion(
                    index,
                    (question, selected),
                  );
                },
                onPop: () => Navigator.of(context).pop(),
                title: "",
                bank: widget.bank,
                onExit: () {
                  context.read<NoTimeExploreCubit>().finish(force: true);
                },
                questions: state.questions,
                onFinish: () {
                  context.read<NoTimeExploreCubit>().finish();
                },
              );
            } else if (state is NoTimeExploreResult) {
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
                  context.read<NoTimeExploreCubit>().init(widget.bank);
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
