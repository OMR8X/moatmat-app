import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/question.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/auth/domain/entites/user_data.dart';
import '../../../../Features/result/domain/entities/result.dart';
import '../../../../Features/result/domain/usecases/add_result_uc.dart';

part 'per_question_explore_state.dart';

class TestPerQuestionExploreCubit extends Cubit<PerQuestionExploreState> {
  TestPerQuestionExploreCubit() : super(PerQuestionExploreLoading());
  late Test test;
  late List<(TestQuestion, int?)> questions = [];
  late List<(TestQuestion, int?)> didNotAnswer;
  late int currentQuestion;
  late int seconds;
  Timer? _timer;
  late Duration time, counter;
  late bool stopTimer;
  void init(Test test, int seconds) {
    variables(test, seconds);
  }

  //
  void variables(Test test, int seconds) {
    //
    counter = Duration.zero;
    currentQuestion = 0;
    this.test = test;
    this.seconds = seconds;
    stopTimer = false;
    //
    initTIme();
    //
    didNotAnswer = [];
    questions = [];

    for (var q in test.questions) {
      var answers = q.answers;
      answers.shuffle();
      q = q.copyWith(answers: answers);
      questions.add((q, null));
    }
    //
    emitState();
    cancelTimer();
    startTimer();
  }

  initTIme() {
    time = Duration(seconds: seconds, milliseconds: 900);
    if (questions.isNotEmpty && questions[currentQuestion].$1.time != null) {
      time = Duration(seconds: questions[currentQuestion].$1.time!);
    }
  }
  //

  void answerQuestion(int index, (TestQuestion, int?) question) {
    questions[index] = (question.$1, question.$2);
    emitState();
    stopTimer = true;
  }

  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      currentQuestion++;
      stopTimer = false;
      initTIme();
      emitState();
    } else {
      stopTimer = true;
      cancelTimer();
      finish();
    }
  }

  //
  //
  void startTimer() {
    initTIme();
    const milliseconds = 500;
    _timer = Timer.periodic(
      const Duration(milliseconds: milliseconds),
      (timer) {
        if (stopTimer) {
          return;
        }
        if (time.inSeconds <= 0) {
          onTimeEnd();
          stopTimer = true;
          return;
        }
        // time over
        if (time.inSeconds <= 0) {
          onTimeEnd();
          return;
        }
        // did answer
        if (questions[currentQuestion].$2 != null) {
          return;
        }
        // did finish
        if (questions[questions.length - 1].$2 != null) {
          return;
        }
        time = Duration(milliseconds: time.inMilliseconds - milliseconds);
        counter = Duration(milliseconds: counter.inMilliseconds + milliseconds);
        emitState();
        return;
      },
    );
  }

  emitState() {
    emit(PerQuestionExploreQuestion(
      question: questions[currentQuestion],
      currentQ: currentQuestion,
      length: questions.length,
      time: time,
    ));
  }

  void onTimeEnd() {
    //
    var ques = questions[currentQuestion];
    //
    //
    int trueIndex = 0;
    for (int i = 0; i < ques.$1.answers.length; i++) {
      if (ques.$1.answers[i].isCorrect) {
        trueIndex = i;
      }
    }
    didNotAnswer.add((ques.$1, trueIndex));
    questions[currentQuestion] = (ques.$1, 10);
    //
    emitState();
  }

  void cancelTimer() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
  }

  void finish() {
    cancelTimer();
    List<(TestQuestion, int)> correct = [];
    List<(TestQuestion, int)> wrong = [];
    for (var q in questions) {
      if (q.$2 != null) {
        List<int> correctIndex = [];
        for (int i = 0; i < q.$1.answers.length; i++) {
          q.$1.answers[i].isCorrect ? correctIndex.add(i) : null;
        }
        (correctIndex.contains(q.$2))
            ? correct.add((q.$1, q.$2!))
            : wrong.add((q.$1, q.$2!));
      } else {
        int correctIndex = 0;
        for (int i = 0; i < q.$1.answers.length; i++) {
          q.$1.answers[i].isCorrect ? correctIndex = i : null;
        }
        wrong.add((q.$1, correctIndex));
      }
    }
    //
    for (var d in didNotAnswer) {
      String value = "";
      value += d.$1.image ?? "";
      value += d.$1.answers.first.answer;
      correct.removeWhere((e) {
        String value2 = "";
        value2 += e.$1.image ?? "";
        value2 += e.$1.answers.first.answer;
        return value == value2;
      });
    }
    wrong.addAll(didNotAnswer.map((e) => (e.$1, e.$2!)).toList());
    var result = ((correct.length / questions.length) * 100).toStringAsFixed(2);
    emit(PerQuestionExploreResult(
      correct: correct,
      wrong: wrong,
      result: result,
    ));
    submitResult(wrong, result);
  }

  submitResult(List<(TestQuestion, int)> wrongAnswers, String result) async {
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
        period: counter.inSeconds,
        date: DateTime.now(),
        name: userInfo.name,
        testName: test.title,
        userId: userInfo.uuid,
        testId: test.id.toString(),
      ),
      test: test,
    );
  }
}
