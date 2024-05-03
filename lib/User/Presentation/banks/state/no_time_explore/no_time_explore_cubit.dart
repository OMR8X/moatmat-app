import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_q.dart';

import '../../../../Core/resources/audios_r.dart';
import '../../../../Features/tests/domain/entities/question.dart';

part 'no_time_explore_state.dart';

class NoTimeExploreCubit extends Cubit<NoTimeExploreState> {
  NoTimeExploreCubit() : super(NoTimeExploreLoading());
  late Bank bank;
  late List<(Question, int?)> questions;
  late int currentQuestion;
  void init(Bank bank) {
    variables(bank);
    getQuestion();
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
    //
    questions = [];
    for (var q in bank.questions) {
      var answers = q.answers;
      answers.shuffle();
      q = q.copyWith(answers: answers);
      questions.add((q, null));
    }
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
    emit(NoTimeExploreResult(
      correct: correct,
      wrong: wrong,
      result: ((correct.length / questions.length) * 100).toStringAsFixed(2),
    ));
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
