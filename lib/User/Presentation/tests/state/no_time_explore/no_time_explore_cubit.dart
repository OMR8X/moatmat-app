import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/question.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/result/domain/entities/result.dart';
import '../../../../Features/result/domain/usecases/add_result_uc.dart';

part 'no_time_explore_state.dart';

class TestNoTimeExploreCubit extends Cubit<NoTimeExploreState> {
  TestNoTimeExploreCubit() : super(NoTimeExploreLoading());
  late Test test;
  late List<(Question, int?)> questions;
  late int currentQuestion;
  late Duration period;
  Timer? _timer;
  void init(Test test) {
    variables(test);
    getQuestion();
    startTimeCounter();
  }

  void getQuestion({int? index}) {
    //
    if (index == null) {
      emitState();
      return;
    }
    //
    if (index > questions.length - 1) {
      // end
      finish();
    } else if (index < 0) {
      return;
    } else {
      //
      currentQuestion = index;
      emitState();
    }
  }

  void answerQuestion(int index, (Question, int?) question) {
    questions[index] = (question.$1, question.$2);
    emitState();
  }

  void variables(Test test) {
    //
    currentQuestion = 0;
    this.test = test;

    //
    questions = [];
    for (var q in test.questions) {
      var answers = q.answers;
      answers.shuffle();
      q = q.copyWith(answers: answers);
      questions.add((q, null));
    }
  }

  startTimeCounter() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    period = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      period = Duration(seconds: period.inSeconds + 1);
    });
  }

  void finish() async {
    List<(Question, int)> correct = [];
    List<(Question, int)> wrong = [];
    for (var q in questions) {
      if (q.$2 != null) {
        List<int> correctIndex = [];
        for (int i = 0; i < q.$1.answers.length; i++) {
          (q.$1.answers[i].trueAnswer ?? false) ? correctIndex.add(i) : null;
        }
        (correctIndex.contains(q.$2))
            ? correct.add((q.$1, q.$2!))
            : wrong.add((q.$1, q.$2!));
      } else {
        int correctIndex = 0;
        for (int i = 0; i < q.$1.answers.length; i++) {
          (q.$1.answers[i].trueAnswer ?? false) ? correctIndex = i : null;
        }
        wrong.add((q.$1, correctIndex));
      }
    }
    String result =
        ((correct.length / questions.length) * 100).toStringAsFixed(2);
    emit(NoTimeExploreResult(
      correct: correct,
      wrong: wrong,
      result: result,
    ));
    submitResult(wrong, result);
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
  }

  submitResult(List<(Question, int)> wrongAnswers, String result) async {
    debugPrint("submitting");
    String wrongAnswersStr = "";
    for (var a in wrongAnswers) {
      wrongAnswersStr += (a.$1.id + 1).toString();
      wrongAnswersStr += ' , ';
    }
    var userInfo = locator<UserData>();
    await locator<AddResultUC>().call(
      result: Result(
        id: 0,
        marks: result,
        wrongAnswers: wrongAnswersStr,
        period: period.inSeconds,
        date: DateTime.now(),
        name: userInfo.name,
        testName: test.information.title,
        userId: userInfo.uuid,
        testId: test.id.toString(),
      ),
      test: test,
    );
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
  }

  emitState() {
    emit(NoTimeExploreQuestion(
      question: questions[currentQuestion],
      currentQ: currentQuestion,
      length: questions.length,
    ));
  }
}
// result
