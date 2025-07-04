import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';
import 'package:moatmat_app/User/Features/result/domain/usecases/get_my_repository_results_uc.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Presentation/tests/view/question_v.dart';

import '../../../Features/result/domain/entities/result.dart';
import '../../../Features/tests/domain/entities/question.dart';

class ListOfTestAnswersView extends StatefulWidget {
  const ListOfTestAnswersView({super.key, required this.answers, required this.test});
  final Test test;
  final List<(Question, int)> answers;
  @override
  State<ListOfTestAnswersView> createState() => _ListOfTestAnswersViewState();
}

class _ListOfTestAnswersViewState extends State<ListOfTestAnswersView> {
  final PageController _controller = PageController();
  int currentQuestion = 1;
  bool isLoading = true;
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    await locator<GetMyRepositoryResultsUc>()
        .call(
      testId: widget.test.id,
    )
        .then((v) {
      v.fold(
        (l) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("عزيزي الطالب عليك حل الاختبار بشكل كامل مرة واحدة على الأقل لتتمكن من عرض النتائج و تصفح سلم التصحيح"),
            duration: const Duration(seconds: 8),
          ));
          Navigator.pop(context);
        },
        (r) {
          handleResult(r);
        },
      );
    });
  }

  handleResult(List<Result> results) {
    //
    if (results.isEmpty) {
      popScreen();
      return;
    }
    //

    if (results.any((r) => r.answers.every((e) => e != null))) {
      //
      setState(() {
        isLoading = false;
      });
    } else {
      popScreen();
    }
  }

  popScreen() {
    Fluttertoast.showToast(msg: "يجب حل الاختبار بشكل كامل مرة واحدة على الاقل لعرض النتائج");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.background,
      appBar: AppBar(
        title: const Text(AppBarTitles.listOfAnswer),
        backgroundColor: ColorsResources.background,
      ),
      body: isLoading
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : PageView.builder(
              controller: _controller,
              onPageChanged: (value) {
                setState(() {
                  currentQuestion = widget.answers[value].$1.id;
                });
              },
              itemCount: widget.answers.length,
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(top: SizesResources.s2),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Text("رقم السؤال : $currentQuestion"),
                          ],
                        ),
                        TestQuestionBodyElements(
                          test: widget.test,
                          disableExplain: false,
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
                          showIsTrue: widget.test.properties.showAnswers ?? false,
                        ),
                      ],
                    ),
                  )),
    );
  }
}
