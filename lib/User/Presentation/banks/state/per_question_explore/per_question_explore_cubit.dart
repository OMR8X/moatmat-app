import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_q.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Core/resources/audios_r.dart';
import '../../../../Features/auth/domain/entites/user_data.dart';
import '../../../../Features/result/domain/entities/result.dart';
import '../../../../Features/result/domain/usecases/add_result_uc.dart';
import '../../../../Features/tests/domain/entities/question.dart';

part 'per_question_explore_state.dart';

class PerQuestionExploreCubit extends Cubit<PerQuestionExploreState> {
  PerQuestionExploreCubit() : super(PerQuestionExploreLoading());
  late Bank bank;
  late List<(Question, int?)> questions;
  late List<(Question, int?)> didNotAnswer;
  late int currentQuestion;
  late int seconds;
  Timer? _timer;
  late Duration time;
  late bool stopTimer;
  bool didSubmit = false;
  late Duration counter;
  late List<int?> userAnswers;
  List<int?> wrongAnswers = [];
  void init(Bank bank, int seconds) {
    variables(bank, seconds);
  }

  //
  void variables(Bank bank, int seconds) {
    //
    currentQuestion = 0;
    this.bank = bank;
    this.seconds = seconds;
    stopTimer = false;
    //
    initTIme();
    //
    counter = Duration.zero;
    didNotAnswer = [];
    questions = [];
    userAnswers = [];
    didSubmit = false;

    for (var q in bank.questions) {
      var answers = q.answers;
      answers.shuffle();
      q = q.copyWith(answers: answers);
      questions.add((q, null));
      userAnswers.add(null);
    }
    //
    wrongAnswers = List.filled(questions.length, -1);
    //
    emitState();
    cancelTimer();
    startTimer();
  }

  initTIme() {
    time = Duration(seconds: seconds, milliseconds: 900);
  }
  //

  void answerQuestion(int index, (Question, int?) question) {
    //
    if (question.$2 != null) {
      userAnswers[index] = question.$1.answers[question.$2!].id;
    }
    //
    Question currentQuestion = questions[index].$1;
    List<int> trueIndexes = [];
    for (int i = 0; i < currentQuestion.answers.length; i++) {
      if (currentQuestion.answers[i].trueAnswer ?? false) {
        trueIndexes.add(i);
      }
    }
    if (trueIndexes.contains(question.$2)) {
      AudioPlayer().play(AssetSource(AudiosResources.correctAnswer));
    } else {
      AudioPlayer().play(AssetSource(AudiosResources.wrongAnswer), volume: 2);
    }
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

  void previousQuestion() {
    currentQuestion--;
    stopTimer = false;
    initTIme();
    emitState();
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
        // did answer current question
        if (questions[currentQuestion].$2 != null) {
          return;
        }
        // did finish - automatically proceed to results
        if (questions[questions.length - 1].$2 != null) {
          stopTimer = true;
          cancelTimer();
          finish();
          return;
        }
        time = Duration(milliseconds: time.inMilliseconds - milliseconds);
        //
        counter = Duration(milliseconds: counter.inMilliseconds + 500);
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
      if (ques.$1.answers[i].trueAnswer ?? false) {
        trueIndex = i;
      }
    }
    didNotAnswer.add((ques.$1, trueIndex));
    questions[currentQuestion] = (ques.$1, trueIndex);

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

    List<(Question, int)> correct = [];
    List<(Question, int)> wrong = [];

    for (var q in questions) {
      if (q.$2 != null) {
        List<int> correctIndex = [];

        for (int i = 0; i < q.$1.answers.length; i++) {
          if (q.$1.answers[i].trueAnswer ?? false) {
            correctIndex.add(i);
          }
        }

        if (correctIndex.contains(q.$2)) {
          correct.add((q.$1, q.$2!));
        } else {
          if (q.$1.id - 1 >= 0 && q.$1.id - 1 < wrongAnswers.length) {
            wrongAnswers[q.$1.id - 1] = userAnswers[q.$1.id - 1];
          }
          wrong.add((q.$1, q.$2!));
        }
      } else {
        int correctIndex = 0;
        for (int i = 0; i < q.$1.answers.length; i++) {
          if (q.$1.answers[i].trueAnswer ?? false) {
            correctIndex = i;
          }
        }
        if (q.$1.id - 1 >= 0 && q.$1.id - 1 < wrongAnswers.length) {
          wrongAnswers[q.$1.id - 1] = null;
        }
        wrong.add((q.$1, correctIndex));
      }
    }

    for (var d in didNotAnswer) {
      if (d.$1.id - 1 >= 0 && d.$1.id - 1 < wrongAnswers.length) {
        wrongAnswers[d.$1.id - 1] = null;
      }
      String value = "";
      value += d.$1.image ?? "";
      value += d.$1.answers.first.text ?? "";
      correct.removeWhere((e) {
        String value2 = "";
        value2 += e.$1.image ?? "";
        value2 += d.$1.answers.first.text ?? "";
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

    submitResult(wrongAnswers, double.tryParse(result) ?? 0.0);
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
    var userData = locator<UserData>();
    //
    print(counter.inSeconds);
    //

    await locator<AddResultUC>().call(
      result: Result(
        id: 0,
        userNumber: userData.id.toString(),
        answers: userAnswers,
        wrongAnswers: wrongAnswers,
        mark: result,
        period: counter.inSeconds,
        date: DateTime.now(),
        testName: bank.information.title,
        userId: userData.uuid,
        testId: null,
        form: null,
        outerTestId: null,
        bankId: bank.id,
        userName: userData.name,
      ),
    );
  }
}
