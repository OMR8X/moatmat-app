import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Features/auth/domain/use_cases/update_user_data_uc.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/question.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/auth/domain/entites/user_data.dart';
import '../../../../Features/result/domain/entities/result.dart';
import '../../../../Features/result/domain/usecases/add_result_uc.dart';
part 'full_time_explore_state.dart';

class TestFullTimeExploreCubit extends Cubit<FullTimeExploreState> {
  TestFullTimeExploreCubit() : super(FullTimeExploreInitial());
  late Test test;
  late List<(TestQuestion, int?)> questions;
  late List<(TestQuestion, int?)> didNotAnswer;
  late int currentQuestion;
  late int seconds;
  late Duration counter;
  Timer? _timer;
  late Duration time;
  void init(Test test, int seconds) {
    variables(test, seconds);
  }

  //
  void variables(Test test, int seconds) {
    counter = Duration.zero;
    currentQuestion = 0;
    this.test = test;
    this.seconds = seconds;
    initTime();
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

  initTime() {
    time = Duration(seconds: seconds, milliseconds: 900);
  }
  //

  void answerQuestion(int index, (TestQuestion, int?) question) {
    questions[index] = (question.$1, question.$2);
    emitState();
  }

  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      currentQuestion++;
      emitState();
    } else {
      cancelTimer();
      finish();
    }
  }

  //
  //
  void startTimer() {
    const milliseconds = 500;
    _timer = Timer.periodic(
      const Duration(milliseconds: milliseconds),
      (timer) {
        // time over
        if (time.inSeconds <= 0) {
          finish();
          return;
        }
        // did answer
        // if (questions[currentQuestion].$2 != null) {
        //   return;
        // }
        // did finish
        if (questions[questions.length - 1].$2 != null) {
          return;
        }
        time = Duration(milliseconds: time.inMilliseconds - milliseconds);
        counter = Duration(milliseconds: counter.inMilliseconds + 500);
        emitState();
        return;
      },
    );
  }

  emitState() {
    emit(FullTimeExploreQuestion(
      question: questions[currentQuestion],
      currentQ: currentQuestion,
      length: questions.length,
      time: time,
    ));
  }

  void collectRestQuestions() {
    emit(FullTimeExploreLoading());
    while (currentQuestion < questions.length - 1) {
      //
      var ques = questions[currentQuestion];
      int trueIndex = 0;
      for (int i = 0; i < ques.$1.answers.length; i++) {
        if (ques.$1.answers[i].isCorrect) {
          trueIndex = i;
        }
      }
      didNotAnswer.add((ques.$1, trueIndex));
      questions[currentQuestion] = (ques.$1, trueIndex);
      currentQuestion++;
    }
  }

  void cancelTimer() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
  }

  void finish() {
    cancelTimer();
    // collectRestQuestions();
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

    for (var d in didNotAnswer) {
      String value = "";
      value += d.$1.image ?? "";
      value += d.$1.answers.first.answer ?? d.$1.answers.first.equation!;
      correct.removeWhere((e) {
        String value2 = "";
        value2 += e.$1.image ?? "";
        value2 += d.$1.answers.first.answer ?? d.$1.answers.first.equation!;
        return value == value2;
      });
    }
    wrong.addAll(didNotAnswer.map((e) => (e.$1, e.$2!)).toList());
    var result = ((correct.length / questions.length) * 100).toStringAsFixed(2);
    emit(FullTimeExploreResult(
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
    var userData = locator<UserData>();
    await locator<AddResultUC>().call(
      result: Result(
        id: 0,
        marks: result,
        wrongAnswers: wrongAnswersStr,
        period: counter.inSeconds,
        date: DateTime.now(),
        name: userData.name,
        testName: test.title,
        userId: userData.uuid,
        testId: test.id.toString(),
      ),
      test: test,
    );
    userData = userData.copyWith(
      tests: userData.tests + [(test.id, test.title)],
    );
    await locator<UpdateUserDataUC>().call(userData: userData);
  }
}
