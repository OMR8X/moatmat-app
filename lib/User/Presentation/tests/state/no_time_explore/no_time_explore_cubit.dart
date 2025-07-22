import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  late List<int?> userAnswers;
  late int currentQuestion;
  late Duration period;
  List<int?> wrongAnswers = [];
  Timer? _timer;
  bool didSubmit = false;
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
    if (question.$2 != null) {
      userAnswers[index] = question.$1.answers[question.$2!].id;
    }
    questions[index] = (question.$1, question.$2);
    emitState();
  }

  void variables(Test test) {
    //
    currentQuestion = 0;
    this.test = test;
    didSubmit = false;
    //
    userAnswers = [];
    questions = [];
    for (var q in test.questions) {
      var answers = q.answers;
      answers.shuffle();
      q = q.copyWith(answers: answers);
      questions.add((q, null));
      userAnswers.add(null);
    }
    //
    wrongAnswers = List.filled(questions.length, -1);
    //
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

  void finish({bool force = false}) async {
    //
    if (test.properties.scrollable == true && !force) {
      //
      bool leftQuestion = false;
      //
      for (var q in questions) {
        if (q.$2 == null) {
          leftQuestion = true;
        }
      }
      if (leftQuestion) {
        Fluttertoast.showToast(msg: "يجب الاجابة على جميع الأسئلة");
        return;
      }
    }
    List<(Question, int)> correct = [];
    List<(Question, int)> wrong = [];
    for (var q in questions) {
      if (q.$2 != null) {
        List<int> correctIndex = [];
        for (int i = 0; i < q.$1.answers.length; i++) {
          (q.$1.answers[i].trueAnswer ?? false) ? correctIndex.add(i) : null;
        }
        if (correctIndex.contains(q.$2)) {
          correct.add((q.$1, q.$2!));
        } else {
          int index = q.$1.id - 1;
          if (index >= 0 && index < wrongAnswers.length && index < userAnswers.length) {
            wrongAnswers[index] = userAnswers[index];
          }
          wrong.add((q.$1, q.$2!));
        }
      } else {
        int correctIndex = 0;
        for (int i = 0; i < q.$1.answers.length; i++) {
          (q.$1.answers[i].trueAnswer ?? false) ? correctIndex = i : null;
        }
        int index = q.$1.id - 1;
        if (index >= 0 && index < wrongAnswers.length) {
          wrongAnswers[index] = null;
        }
        wrong.add((q.$1, correctIndex));
      }
    }
    String result = ((correct.length / questions.length) * 100).toStringAsFixed(2);
    emit(NoTimeExploreResult(
      correct: correct,
      wrong: wrong,
      result: result,
    ));
    await submitResult(wrongAnswers, double.tryParse(result) ?? 0.0);
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
  }

  submitResult(List<int?> wrongAnswers, double result) async {
    if (didSubmit) {
      debugPrint("did submit , skip submitting");
      return;
    }
    //
    didSubmit = true;
    //
    debugPrint("submitting");
    //

    var userInfo = locator<UserData>();

    await locator<AddResultUC>().call(
      result: Result(
        id: 0,
        userNumber: userInfo.id.toString(),
        answers: userAnswers,
        wrongAnswers: wrongAnswers,
        period: period.inSeconds,
        mark: result,
        date: DateTime.now(),
        testName: test.information.title,
        userId: userInfo.uuid,
        testId: test.id,
        bankId: null,
        form: null,
        outerTestId: null,
        userName: userInfo.name,
      ),
    );
  }

  emitState() {
    if (test.properties.scrollable == true) {
      emit(NoTimeExploreQuestionScrollable(
        questions: List.from(questions),
      ));
    } else {
      emit(NoTimeExploreQuestion(
        question: questions[currentQuestion],
        currentQ: currentQuestion,
        length: questions.length,
      ));
    }
  }
}
// result
