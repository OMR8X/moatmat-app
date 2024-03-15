import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Presentation/tests/view/result_v.dart';

import '../../state/full_time_explore/full_time_explore_cubit.dart';
import '../list_of_answers_v.dart';
import '../question_v.dart';

class TestFullTimeExploreView extends StatefulWidget {
  const TestFullTimeExploreView({
    super.key,
    required this.minutes,
    required this.test,
  });
  final int minutes;
  final Test test;
  @override
  State<TestFullTimeExploreView> createState() =>
      _TestFullTimeExploreViewState();
}

class _TestFullTimeExploreViewState extends State<TestFullTimeExploreView> {
  bool submit = true;
  @override
  void initState() {
    context.read<TestFullTimeExploreCubit>().init(widget.test, widget.minutes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (submit) {
          context.read<TestFullTimeExploreCubit>().finish();
        }
      },
      child: Scaffold(
        body: BlocBuilder<TestFullTimeExploreCubit, FullTimeExploreState>(
          builder: (context, state) {
            if (state is FullTimeExploreQuestion) {
              return TestQuestionView(
                test: widget.test,
                title: "${state.currentQ + 1} / ${state.length}",
                time: state.time,
                question: state.question.$1,
                selected: state.question.$2,
                showPrevious: false,
                showNext: true,
                onNext: () =>
                    context.read<TestFullTimeExploreCubit>().nextQuestion(),
                onPrevious: () {},
                onPop: () => Navigator.of(context).pop(),
                onAnswer: (question, selected) {
                  context.read<TestFullTimeExploreCubit>().answerQuestion(
                    state.currentQ,
                    (question, selected),
                  );
                },
              );
            } else if (state is FullTimeExploreResult) {
              submit = false;
              return TestResultView(
                canReTest: widget.test.returnable,
                explorable: widget.test.explorable,
                showCorrectAnswers: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ListOfTestAnswersView(
                        test: widget.test,
                        answers: state.correct,
                      ),
                    ),
                  );
                },
                showWrongAnswers: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ListOfTestAnswersView(
                        test: widget.test,
                        answers: state.wrong,
                      ),
                    ),
                  );
                },
                reOpen: () {
                  context
                      .read<TestFullTimeExploreCubit>()
                      .init(widget.test, widget.minutes);
                },
                backToHome: () {
                  submit = false;
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
