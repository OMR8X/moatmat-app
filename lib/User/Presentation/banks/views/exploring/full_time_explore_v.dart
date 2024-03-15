import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Presentation/banks/state/full_time_explore/full_time_explore_cubit.dart';
import 'package:moatmat_app/User/Presentation/banks/views/list_of_answers_v.dart';
import 'package:moatmat_app/User/Presentation/banks/views/question_v.dart';
import 'package:moatmat_app/User/Presentation/banks/views/result_v.dart';

import '../../state/per_question_explore/per_question_explore_cubit.dart';

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
    context.read<FullTimeExploreCubit>().init(widget.bank, widget.minutes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FullTimeExploreCubit, FullTimeExploreState>(
        builder: (context, state) {
          if (state is FullTimeExploreQuestion) {
            return BankQuestionView(
                      bank: widget.bank,
              title: "${state.currentQ + 1} / ${state.length}",
              time: state.time,
              question: state.question.$1,
              selected: state.question.$2,
              showPrevious: false,
              showNext: true,
              onNext: () => context.read<FullTimeExploreCubit>().nextQuestion(),
              onPrevious: () {},
              onPop: () => Navigator.of(context).pop(),
              onAnswer: (question, selected) {
                context.read<FullTimeExploreCubit>().answerQuestion(
                  state.currentQ,
                  (question, selected),
                );
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
                context
                    .read<FullTimeExploreCubit>()
                    .init(widget.bank, widget.minutes);
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
    );
  }
}
