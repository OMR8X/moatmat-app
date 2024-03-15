import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Presentation/tests/view/question_v.dart';

import '../../../Features/tests/domain/entities/question.dart';

class ListOfTestAnswersView extends StatefulWidget {
  const ListOfTestAnswersView(
      {super.key, required this.answers, required this.test});
  final Test test;
  final List<(TestQuestion, int)> answers;
  @override
  State<ListOfTestAnswersView> createState() => _ListOfTestAnswersViewState();
}

class _ListOfTestAnswersViewState extends State<ListOfTestAnswersView> {
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.background,
      appBar: AppBar(
        title: const Text(AppBarTitles.listOfAnswer),
        backgroundColor: ColorsResources.background,
      ),
      body: PageView.builder(
          controller: _controller,
          itemCount: widget.answers.length,
          itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(top: SizesResources.s2),
                child: Column(
                  children: [
                    TestQuestionBodyElements(
                      test: widget.test,
                      question: widget.answers[index].$1,
                      onAnswer: (i) {},
                      onNext: () {
                        _controller.jumpToPage(index + 1);
                      },
                      onPrevious: () {
                        _controller.jumpToPage(index - 1);
                      },
                      showNext: index < widget.answers.length - 1,
                      showPrevious: index > 0,
                      disableActions: false,
                      selected: widget.answers[index].$2,
                    ),
                  ],
                ),
              )),
    );
  }
}
