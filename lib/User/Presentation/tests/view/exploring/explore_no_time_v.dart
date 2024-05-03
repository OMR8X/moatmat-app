import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Presentation/tests/state/no_time_explore/no_time_explore_cubit.dart';

import '../../../../Features/tests/domain/entities/test.dart';
import '../list_of_answers_v.dart';
import '../question_v.dart';
import '../result_v.dart';

class TestExploreNoTimeView extends StatefulWidget {
  const TestExploreNoTimeView({super.key, required this.test});
  final Test test;
  @override
  State<TestExploreNoTimeView> createState() => _TestExploreNoTimeViewState();
}

class _TestExploreNoTimeViewState extends State<TestExploreNoTimeView>
    with WidgetsBindingObserver {
  bool submit = true;

  @override
  void initState() {
    super.initState();
    context.read<TestNoTimeExploreCubit>().init(widget.test);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      context.read<TestNoTimeExploreCubit>().finish();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<TestNoTimeExploreCubit>();
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (submit) {
          context.read<TestNoTimeExploreCubit>().finish();
        }
      },
      child: Scaffold(
        body: BlocBuilder<TestNoTimeExploreCubit, NoTimeExploreState>(
          builder: (context, state) {
            if (state is NoTimeExploreQuestion) {
              return TestQuestionView(
                test: widget.test,
                title: "${state.currentQ + 1} / ${state.length}",
                question: state.question.$1,
                selected: state.question.$2,
                showPrevious: state.currentQ > 0,
                showNext: true,
                onNext: () => cubit.getQuestion(index: state.currentQ + 1),
                onPrevious: () => cubit.getQuestion(index: state.currentQ - 1),
                onPop: () => Navigator.of(context).pop(),
                onAnswer: (question, selected) {
                  cubit.answerQuestion(
                    state.currentQ,
                    (question, selected),
                  );
                },
              );
            }
            if (state is NoTimeExploreResult) {
              submit = false;
              return TestResultView(
                explorable: widget.test.properties.exploreAnswers ?? false,
                canReTest: widget.test.properties.repeatable ?? false,
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
                  context.read<TestNoTimeExploreCubit>().init(widget.test);
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
