import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_app/User/Core/resources/audios_r.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_q.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/auth/domain/entites/user_data.dart';
import '../../../../Features/result/domain/entities/result.dart';
import '../../../../Features/result/domain/usecases/add_result_uc.dart';
import '../../../../Features/tests/domain/entities/question.dart';
part 'full_time_explore_state.dart';

class FullTimeExploreCubit extends Cubit<FullTimeExploreState> {
  FullTimeExploreCubit() : super(FullTimeExploreInitial());
  late Bank bank;
  late List<(Question, int?)> questions;
  late List<(Question, int?)> didNotAnswer;
  late int currentQuestion;
  late int minutes;
  Timer? _timer;
  bool didSubmit = false;
  late Duration time;
  //
  List<int?> wrongAnswers = [];
  //

  late Duration counter;
  late List<int?> userAnswers;
  void init(Bank bank, int minutes) {
    variables(bank, minutes);
  }

  //
  void variables(Bank bank, int minutes) {
    currentQuestion = 0;
    this.bank = bank;
    this.minutes = minutes;
    time = Duration(minutes: minutes, milliseconds: 900);
    didNotAnswer = [];
    questions = [];
    userAnswers = [];
    counter = Duration.zero;
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

  initTime() {
    time = Duration(minutes: minutes, milliseconds: 900);
  }
  //

  void answerQuestion(int index, (Question, int?) question) async {
    //
    if (question.$2 != null) {
      userAnswers[index] = question.$1.answers[question.$2!].id;
    }
    //
    questions[index] = (question.$1, question.$2);
    emitState();
    //
    Question currentQuestion = questions[index].$1;
    List<int> trueIndexes = [];
    //
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
  }

  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      currentQuestion++;
      emitState();
    } else {
      finish();
    }
  }

  void previousQuestion({int? index}) {
    //
    if (index == null) {
      emitState();
      return;
    }
    //
    if (index > questions.length - 1) {
    } else {
      //
      currentQuestion = index;
      emitState();
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
        // // Check if all questions are answered - auto finish
        // if (questions.isNotEmpty && questions.every((q) => q.$2 != null)) {
        //   cancelTimer();
        //   debugPrint("Auto-finishing: All questions answered");
        //   finish();
        //   return;
        // }

        time = Duration(milliseconds: time.inMilliseconds - milliseconds);
        //
        counter = Duration(milliseconds: counter.inMilliseconds + 500);
        //
        emitState();
        return;
      },
    );
  }

  emitState() {
    if (bank.properties.scrollable == true) {
      emit(FullTimeExploreQuestionScrollable(
        questions: List.from(questions),
        time: time,
      ));
    } else {
      emit(FullTimeExploreQuestion(
        question: questions[currentQuestion],
        currentQ: currentQuestion,
        length: questions.length,
        time: time,
      ));
    }
  }

  void collectRestQuestions() {
    emit(FullTimeExploreLoading());
    while (currentQuestion < questions.length - 1) {
      //
      var ques = questions[currentQuestion];
      int trueIndex = 0;
      for (int i = 0; i < ques.$1.answers.length; i++) {
        if (ques.$1.answers[i].trueAnswer ?? false) {
          trueIndex = i;
        }
      }
      didNotAnswer.add((ques.$1, trueIndex));
      //
      questions[currentQuestion] = (ques.$1, trueIndex);
      currentQuestion++;
    }
  }

  void cancelTimer() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
  }

  void finish({bool force = false}) {
    //
    if (!force) {
      //
      bool leftQuestion = false;
      //
      leftQuestion = questions.any((e) => e.$2 == null);
      //
      if (leftQuestion) {
        if (bank.properties.scrollable == true) {
          emit(FullTimeExploreQuestionScrollable(
            questions: List.from(questions),
            time: time,
            unsolved: questions.where((e) => e.$2 == null).map((e) => e.$1.id - 1).toList(),
            showWarning: true,
          ));
        } else {
          emit(FullTimeExploreQuestion(
            question: questions[currentQuestion],
            currentQ: currentQuestion,
            length: questions.length,
            time: time,
            unsolved: questions.where((e) => e.$2 == null).map((e) => e.$1.id - 1).toList(),
            showWarning: true,
          ));
        }
        return;
      }
    }
    //
    cancelTimer();
    // collectRestQuestions();
    List<(Question, int)> correct = [];
    List<(Question, int)> wrong = [];
    //
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
        //
        wrongAnswers[q.$1.id - 1] = null;
        //
        wrong.add((q.$1, correctIndex));
      }
    }

    for (var d in didNotAnswer) {
      //
      wrongAnswers[d.$1.id - 1] = null;
      //
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
    //
    wrong.addAll(didNotAnswer.map((e) => (e.$1, e.$2!)).toList());
    //
    var result = ((correct.length / questions.length) * 100).toStringAsFixed(2);
    //
    submitResult(wrongAnswers, double.tryParse(result) ?? 0.0);
    //
    emit(FullTimeExploreResult(
      correct: correct,
      wrong: wrong,
      result: ((correct.length / questions.length) * 100).toStringAsFixed(2),
    ));
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
