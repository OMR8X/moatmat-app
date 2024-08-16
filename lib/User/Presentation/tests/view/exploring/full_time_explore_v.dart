import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Presentation/tests/view/result_v.dart';

import '../../../../Core/functions/show_alert.dart';
import '../../../auth/state/auth_c/auth_cubit_cubit.dart';
import '../../../auth/view/auth_views_manager.dart';
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
  bool didAlert = false;
  @override
  void initState() {context.read<AuthCubit>().onCheck();
    context.read<TestFullTimeExploreCubit>().init(widget.test, widget.minutes);

    super.initState();
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
        body: BlocBuilder<TestFullTimeExploreCubit, FullTimeExploreState>(
          builder: (context, state) {
            final cubit = context.read<TestFullTimeExploreCubit>();

            if (state is FullTimeExploreQuestion) {
              return TestQuestionView(
                onExit: () {
                  context.read<TestFullTimeExploreCubit>().finish();
                },
                enableActions: true,
                test: widget.test,
                title: "${state.currentQ + 1} / ${state.length}",
                time: state.time,
                question: state.question.$1,
                selected: state.question.$2,
                showPrevious: state.currentQ > 0,
                showNext: true,
                onNext: () => cubit.nextQuestion(),
                onPrevious: () =>
                    cubit.previousQuestion(index: state.currentQ - 1),
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
                  context
                      .read<TestFullTimeExploreCubit>()
                      .init(widget.test, widget.minutes);
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
