import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Core/resources/audios_r.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_q.dart';

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
  late Duration time;
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

  initTime() {
    time = Duration(minutes: minutes, milliseconds: 900);
  }
  //

  void answerQuestion(int index, (Question, int?) question) async {
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
        // // did answer
        // if (questions[currentQuestion].$2 != null) {
        //   return;
        // }
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
        if (ques.$1.answers[i].trueAnswer ?? false) {
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

    for (var d in didNotAnswer) {
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
    emit(FullTimeExploreResult(
      correct: correct,
      wrong: wrong,
      result: ((correct.length / questions.length) * 100).toStringAsFixed(2),
    ));
  }
}
