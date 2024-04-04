import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';

import '../../state/per_question_explore/per_question_explore_cubit.dart';
import '../list_of_answers_v.dart';
import '../question_v.dart';
import '../result_v.dart';

class TestPerQuestionExploreView extends StatefulWidget {
  const TestPerQuestionExploreView({
    super.key,
    required this.minutes,
    required this.test,
  });
  final int minutes;
  final Test test;
  @override
  State<TestPerQuestionExploreView> createState() =>
      _TestPerQuestionExploreViewState();
}

class _TestPerQuestionExploreViewState
    extends State<TestPerQuestionExploreView> {
  bool submit = true;
  @override
  void initState() {
    context
        .read<TestPerQuestionExploreCubit>()
        .init(widget.test, widget.minutes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<TestPerQuestionExploreCubit>();
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (submit) {
          cubit.finish();
        }
      },
      child: Scaffold(
        body: BlocBuilder<TestPerQuestionExploreCubit, PerQuestionExploreState>(
          builder: (context, state) {
            if (state is PerQuestionExploreQuestion) {

              return TestQuestionView(
                test: widget.test,
                title: "${state.currentQ + 1} / ${state.length}",
                time: state.time,
                question: state.question.$1,
                selected: state.question.$2,
                showPrevious: false,
                showNext: true,
                onNext: () =>
                    context.read<TestPerQuestionExploreCubit>().nextQuestion(),
                onPrevious: () {},
                onPop: () => Navigator.of(context).pop(),
                onAnswer: (question, selected) {
                  context.read<TestPerQuestionExploreCubit>().answerQuestion(
                    state.currentQ,
                    (question, selected),
                  );
                },
              );
            } else if (state is PerQuestionExploreResult) {
              submit = false;
              return TestResultView(
                explorable: widget.test.explorable,
                canReTest: widget.test.returnable,
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
                      .read<TestPerQuestionExploreCubit>()
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
            } else {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
