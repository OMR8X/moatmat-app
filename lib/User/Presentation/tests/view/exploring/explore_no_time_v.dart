import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/functions/show_alert.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import 'package:moatmat_app/User/Presentation/auth/view/auth_views_manager.dart';
import 'package:moatmat_app/User/Presentation/tests/state/no_time_explore/no_time_explore_cubit.dart';

import '../../../../Features/tests/domain/entities/test.dart';
import '../list_of_answers_v.dart';
import '../question_v.dart';
import '../questions_v.dart';
import '../result_v.dart';

class TestExploreNoTimeView extends StatefulWidget {
  const TestExploreNoTimeView({super.key, required this.test});
  final Test test;
  @override
  State<TestExploreNoTimeView> createState() => _TestExploreNoTimeViewState();
}

class _TestExploreNoTimeViewState extends State<TestExploreNoTimeView> {
  @override
  void initState() {
    context.read<AuthCubit>().onCheck();
    super.initState();
    context.read<TestNoTimeExploreCubit>().init(widget.test);
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<TestNoTimeExploreCubit>();
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
        body: BlocBuilder<TestNoTimeExploreCubit, NoTimeExploreState>(
          builder: (context, state) {
            if (state is NoTimeExploreQuestion) {
              return TestQuestionView(
                onExit: () {
                  context.read<TestNoTimeExploreCubit>().finish();
                },
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
            } else if (state is NoTimeExploreQuestionScrollable) {
              return TestQuestionsView(
                onExit: () {
                  context.read<TestNoTimeExploreCubit>().finish(force: true);
                },
                test: widget.test,
                title: "",
                questions: state.questions,
                showPrevious: false,
                showNext: false,
                onNext: () {},
                onPrevious: () {},
                onPop: () => Navigator.of(context).pop(),
                onAnswer: (index, question, selected) {
                  cubit.answerQuestion(
                    index,
                    (question, selected),
                  );
                },
                onFinish: () {
                  context.read<TestNoTimeExploreCubit>().finish();
                },
              );
            }
            if (state is NoTimeExploreResult) {
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
                  Navigator.of(context).pop();
                },
                correctAnswers: "${state.correct.length}",
                wrongAnswers: "${state.wrong.length}",
                result: state.result,
              );
            }
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
          },
        ),
      ),
    );
  }
}
