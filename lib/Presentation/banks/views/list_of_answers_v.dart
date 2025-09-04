import 'package:flutter/material.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';
import 'package:moatmat_app/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/Core/resources/texts_resources.dart';
import 'package:moatmat_app/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/Features/banks/domain/entites/bank_q.dart';
import 'package:moatmat_app/Features/tests/domain/entities/question.dart';
import 'package:moatmat_app/Presentation/banks/views/question_v.dart';

class ListOfBankAnswersView extends StatefulWidget {
  const ListOfBankAnswersView(
      {super.key, required this.answers, required this.bank});
  final Bank bank;
  final List<(Question, int)> answers;
  @override
  State<ListOfBankAnswersView> createState() => _ListOfBankAnswersViewState();
}

class _ListOfBankAnswersViewState extends State<ListOfBankAnswersView> {
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
                    BankQuestionBodyElements(
                      bank: widget.bank,
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
