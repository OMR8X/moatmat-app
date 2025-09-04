import 'package:flutter/material.dart';
import 'package:moatmat_app/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/Features/banks/domain/entites/bank_q.dart';
import 'package:moatmat_app/Presentation/auth/view/auth_views_manager.dart';
import 'package:moatmat_app/Presentation/banks/views/question_v.dart';

import '../../../../Features/tests/domain/entities/question.dart';

class DoBankQuestionView extends StatefulWidget {
  const DoBankQuestionView({
    super.key,
    required this.bank,
    required this.question,
  });
  final Bank bank;
  final Question question;
  @override
  State<DoBankQuestionView> createState() => _DoBankQuestionViewState();
}

class _DoBankQuestionViewState extends State<DoBankQuestionView> {
  int? selected;
  @override
  Widget build(BuildContext context) {
    return BankQuestionView(
      bank: widget.bank,
      selected: selected,
      question: widget.question,
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
      title: "بنك الاستاذ ${widget.bank.information.teacher}",
      onExit: () {},
    );
  }
}
