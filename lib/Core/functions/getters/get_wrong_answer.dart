import 'package:flutter/material.dart';

import '../../../Features/result/domain/entities/result.dart';
import '../../../Features/tests/domain/entities/question.dart';

List<(Question, int?)> getWrongAnswers(
  Result result,
  List<Question> questions,
) {
  //
  List<(Question, int?)> wrongAnswers = [];
  //
  for (int i = 0; i < result.answers.length; i++) {
    //
    final answer = result.answers[i];
    final question = questions[i];
    //
    if (answer != null) {
      //
      List<int> trueAnswers = getTrueAnswers(question);
      //
      if (!trueAnswers.contains(answer)) {
        wrongAnswers.add((question, answer));
      } else {
        debugPrint("here");
      }
      //
    } else {
      wrongAnswers.add((question, null));
    }
  }
  return wrongAnswers;
}

List<int> getTrueAnswers(Question q) {
  //
  List<int> trueAnswers = [];
  //
  for (var answer in q.answers) {
    if (answer.trueAnswer ?? false) {
      trueAnswers.add(answer.id);
    }
  }
  //
  return trueAnswers;
}
