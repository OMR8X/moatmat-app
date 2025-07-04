import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';

import '../../../../Core/functions/show_alert.dart';
import '../../../../Core/resources/sizes_resources.dart';
import '../../../auth/state/auth_c/auth_cubit_cubit.dart';
import '../../../auth/view/auth_views_manager.dart';
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
  State<TestPerQuestionExploreView> createState() => _TestPerQuestionExploreViewState();
}

class _TestPerQuestionExploreViewState extends State<TestPerQuestionExploreView> {
  @override
  void initState() {
    context.read<AuthCubit>().onCheck();
    context.read<TestPerQuestionExploreCubit>().init(widget.test, widget.minutes);

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
        body: BlocBuilder<TestPerQuestionExploreCubit, PerQuestionExploreState>(
          builder: (context, state) {
            final cubit = context.read<TestPerQuestionExploreCubit>();
            if (state is PerQuestionExploreQuestion) {
              return TestQuestionView(
                onExit: () {
                  context.read<TestPerQuestionExploreCubit>().finish();
                },
                test: widget.test,
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
                  context.read<TestPerQuestionExploreCubit>().answerQuestion(
                    state.currentQ,
                    (question, selected),
                  );
                },
              );
            } else if (state is PerQuestionExploreResult) {
              return TestResultView(
                sendResultCompleter: cubit.sendResultCompleter,
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
                  context.read<TestPerQuestionExploreCubit>().init(widget.test, widget.minutes);
                },
                backToHome: () {
                  Navigator.of(context).pop();
                },
                correctAnswers: "${state.correct.length}",
                wrongAnswers: "${state.wrong.length}",
                result: state.result,
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoActivityIndicator(),
                    SizedBox(
                      height: SizesResources.s6,
                    ),
                    Text("جار التحميل"),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
