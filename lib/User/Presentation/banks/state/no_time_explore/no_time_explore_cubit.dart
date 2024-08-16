import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
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

part 'no_time_explore_state.dart';

class NoTimeExploreCubit extends Cubit<NoTimeExploreState> {
  NoTimeExploreCubit() : super(NoTimeExploreLoading());
  late Bank bank;
  late List<(Question, int?)> questions;
  late int currentQuestion;
  bool didSubmit = false;
  late Duration period;
  Timer? _timer;
  late List<int?> userAnswers;
  List<int?> wrongAnswers = [];
  void init(Bank bank) {
    variables(bank);
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
  }

  void variables(Bank bank) {
    //
    currentQuestion = 0;
    this.bank = bank;
    didSubmit = false;
    //
    questions = [];
    userAnswers = [];

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

  void finish() {
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
          wrongAnswers[q.$1.id - 1] = userAnswers[q.$1.id - 1];
          wrong.add((q.$1, q.$2!));
        }
      } else {
        int correctIndex = 0;
        for (int i = 0; i < q.$1.answers.length; i++) {
          (q.$1.answers[i].trueAnswer ?? false) ? correctIndex = i : null;
        }
        wrongAnswers[q.$1.id - 1] = userAnswers[q.$1.id - 1];
        wrong.add((q.$1, correctIndex));
      }
    }
    var result = ((correct.length / questions.length) * 100).toStringAsFixed(2);
    submitResult(wrongAnswers, double.tryParse(result) ?? 0.0);
    emit(NoTimeExploreResult(
      correct: correct,
      wrong: wrong,
      result: ((correct.length / questions.length) * 100).toStringAsFixed(2),
    ));
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
    var userData = locator<UserData>();
//
    print(period.inSeconds);
    //
    await locator<AddResultUC>().call(
      result: Result(
        id: 0,
        userNumber: userData.id.toString(),
        answers: userAnswers,
        wrongAnswers: wrongAnswers,
        mark: result,
        period: period.inSeconds,
        date: DateTime.now(),
        testName: bank.information.title,
        userId: userData.uuid,
        testId: null,
        bankId: bank.id,
        userName: userData.name,
      ),
    );
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
