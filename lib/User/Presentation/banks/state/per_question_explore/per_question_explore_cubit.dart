import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_q.dart';

import '../../../../Core/resources/audios_r.dart';

part 'per_question_explore_state.dart';

class PerQuestionExploreCubit extends Cubit<PerQuestionExploreState> {
  PerQuestionExploreCubit() : super(PerQuestionExploreLoading());
  late Bank bank;
  late List<(BankQuestion, int?)> questions;
  late List<(BankQuestion, int?)> didNotAnswer;
  late int currentQuestion;
  late int seconds;
  Timer? _timer;
  late Duration time;
  late bool stopTimer;
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
    didNotAnswer = [];
    questions = [];

    for (var q in bank.questions) {
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
  }
  //

  void answerQuestion(int index, (BankQuestion, int?) question) {
    BankQuestion currentQuestion = questions[index].$1;
    List<int> trueIndexes = [];
    for (int i = 0; i < currentQuestion.answers.length; i++) {
      if (currentQuestion.answers[i].isCorrect) {
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
    List<(BankQuestion, int)> correct = [];
    List<(BankQuestion, int)> wrong = [];
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
        wrong.add((q.$1, q.$2!));
      }
    }
    //
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
    emit(PerQuestionExploreResult(
      correct: correct,
      wrong: wrong,
      result: ((correct.length / questions.length) * 100).toStringAsFixed(2),
    ));
  }
}
