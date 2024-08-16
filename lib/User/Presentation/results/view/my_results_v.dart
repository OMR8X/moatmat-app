import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';
import 'package:moatmat_app/User/Presentation/results/state/results/my_results_cubit.dart';
import 'package:moatmat_app/User/Presentation/results/view/result_v.dart';
import 'package:moatmat_app/User/Presentation/results/widget/result_tile_w.dart';

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
                    ListView.builder(
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
                    ListView.builder(
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
                    ListView.builder(
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
