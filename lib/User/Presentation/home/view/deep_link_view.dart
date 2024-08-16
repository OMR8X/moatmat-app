import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_q.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/question.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';

import '../../banks/views/question_v.dart';
import '../../tests/view/question_v.dart';

class DeepLinkView extends StatefulWidget {
  const DeepLinkView({
    super.key,
    required this.questionId,
    this.bank,
    this.test,
  });

  final int questionId;
  final Bank? bank;
  final Test? test;
  @override
  State<DeepLinkView> createState() => _DeepLinkViewState();
}

class _DeepLinkViewState extends State<DeepLinkView> {
  int? selected;

  @override
  Widget build(BuildContext context) {
    if (widget.bank != null) {
      return BankQuestionView(
        bank: widget.bank!,
        selected: selected,
        question: widget.bank!.questions[widget.questionId],
        onAnswer: (question, selected) {
          setState(() {
            this.selected = selected;
          });
        },
        onPop: () {
          Navigator.of(context).pop();
        },
        disableActions: true,
        onNext: () {},
        onPrevious: () {},
        title: "بنك الاستاذ ${widget.bank!.information.teacher}",
        onExit: () {},
      );
    } else if (widget.test != null) {
      return TestQuestionView(
        onExit: () {},
        test: widget.test!,
        selected: selected,
        disableActions: true,
        question: widget.test!.questions[widget.questionId],
        onAnswer: (question, selected) {
          setState(() {
            this.selected = selected;
          });
        },
        onPop: () {
          Navigator.of(context).pop();
        },
        onNext: () {},
        onPrevious: () {},
        title: "بنك الاستاذ ${widget.test!.information.teacher}",
      );
    }
    return const Scaffold();
  }
}
