import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';
import 'package:moatmat_app/User/Presentation/results/state/results/my_results_cubit.dart';
import 'package:moatmat_app/User/Presentation/results/view/result_v.dart';
import 'package:moatmat_app/User/Presentation/results/widget/result_tile_w.dart';

import '../../../Core/functions/parsers/num_to_latter.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/widgets/toucheable_tile_widget.dart';
import '../../../Core/widgets/ui/empty_list_text.dart';
import '../../../Features/tests/domain/entities/outer_test.dart';

class MyResultsView extends StatefulWidget {
  const MyResultsView({super.key});

  @override
  State<MyResultsView> createState() => _MyResultsViewState();
}

class _MyResultsViewState extends State<MyResultsView> {
  @override
  void initState() {
    context.read<MyResultsCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyResultsCubit, MyResultsState>(
        builder: (context, state) {
          if (state is MyResultsInitial) {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(AppBarTitles.myResult),
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: "نتائج اختباراتي"),
                      Tab(text: "نتائج بنوكي"),
                      Tab(text: "اختبارات خارجية"),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    state.testsResults.isEmpty
                        ? const EmptyListTextWidget()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              vertical: SizesResources.s2,
                            ),
                            itemCount: state.testsResults.length,
                            itemBuilder: (context, index) {
                              return ResultTileWidget(
                                showResult: false,
                                result: state.testsResults[index],
                                onExploreResult: () {
                                  context.read<MyResultsCubit>().exploreResult(
                                        state.testsResults[index],
                                      );
                                },
                              );
                            },
                          ),
                    state.banksResults.isEmpty
                        ? const EmptyListTextWidget()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              vertical: SizesResources.s2,
                            ),
                            itemCount: state.banksResults.length,
                            itemBuilder: (context, index) {
                              return ResultTileWidget(
                                showResult: false,
                                result: state.banksResults[index],
                                onExploreResult: () {
                                  context.read<MyResultsCubit>().exploreResult(
                                        state.banksResults[index],
                                      );
                                },
                              );
                            },
                          ),
                    state.outerResults.isEmpty
                        ? const EmptyListTextWidget()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              vertical: SizesResources.s2,
                            ),
                            itemCount: state.outerResults.length,
                            itemBuilder: (context, index) {
                              return ResultTileWidget(
                                showResult: true,
                                result: state.outerResults[index],
                                onExploreResult: () {
                                  context.read<MyResultsCubit>().exploreResult(
                                        state.outerResults[index],
                                      );
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
            );
          } else if (state is MyResultsExploreResult) {
            return ResultView(
              mark: state.mark,
              questions: state.wrongAnswers,
              showTrueAnswers: state.showTrueAnswers,
            );
          } else if (state is MyResultsExploreResultOuterResult) {
            return Scaffold(
              appBar: AppBar(
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: Text("نتيجتك : %${(state.mark).toStringAsFixed(1)}"),
                  ),
                ],
              ),
              body: OuterWrongAnswersBuilder(
                length: state.length,
                answers: state.answers,
                questions: state.questions,
              ),
            );
          } else if (state is MyResultsError) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text(state.error),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class OuterWrongAnswersBuilder extends StatelessWidget {
  ///
  const OuterWrongAnswersBuilder({
    super.key,
    required this.length,
    required this.answers,
    required this.questions,
  });

  ///
  final int length;
  final List<OuterQuestion> questions;
  final List<int?> answers;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 15),
      itemCount: min(answers.length, min(length, questions.length)),
      //
      // shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      //
      itemBuilder: (context, index) {
        //
        int? selection = answers[index] ?? -1;
        OuterQuestion question = questions[index];
        //
        if ((selection) == (question.trueAnswer + 1)) {
          return const SizedBox();
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                width: SpacingResources.mainWidth(context),
                height: (SpacingResources.mainWidth(context)) / 6,
                child: Row(children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: ColorsResources.blackText1,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(
                    5,
                    (i) {
                      bool trueAnswer = questions[index].trueAnswer == i;
                      Color color1 = Colors.orange;
                      return Expanded(
                        child: CircleAvatar(
                          backgroundColor: (selection - 1) == i
                              ? color1
                              : trueAnswer
                                  ? Colors.green
                                  : null,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              numberToLetter(i + 1),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  getSubTitle(int? selection) {
    return selection == null ? "لم يتم الاختيار" : "تم اختيار  ${numberToLetter(selection)}";
  }
}
