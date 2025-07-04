import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  late List<(Question, int?)> questions;
  late List<int?> userAnswers;
  late List<(Question, int?)> didNotAnswer;
  late int currentQuestion;
  late int seconds;
  Completer<void>? sendResultCompleter;
  late Duration counter;
  Timer? _timer;
  late Duration time;
  bool didSubmit = false;
  List<int?> wrongAnswers = [];
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
    userAnswers = [];
    didSubmit = false;
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
    emitState();
    cancelTimer();
    startTimer();
  }

  initTime() {
    time = Duration(seconds: seconds, milliseconds: 900);
  }
  //

  void answerQuestion(int index, (Question, int?) question) {
    //
    if (question.$2 != null) {
      userAnswers[index] = question.$1.answers[question.$2!].id;
    }
    //
    questions[index] = (question.$1, question.$2);
    //
    emitState();
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

        time = Duration(milliseconds: time.inMilliseconds - milliseconds);
        counter = Duration(milliseconds: counter.inMilliseconds + 500);
        emitState();
        return;
      },
    );
  }

  emitState() {
    if (test.properties.scrollable == true) {
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
      questions[currentQuestion] = (ques.$1, trueIndex);
      currentQuestion++;
    }
  }

  void cancelTimer() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
  }

  void finish({bool force = false}) async {
    sendResultCompleter = Completer<void>();
    //
    if (!force) {
      //
      bool leftQuestion = false;
      //
      leftQuestion = questions.any((e) => e.$2 == null);
      //
      if (leftQuestion) {
        if (test.properties.scrollable == true) {
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
    //
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
        wrongAnswers[q.$1.id - 1] = null;
        wrong.add((q.$1, correctIndex));
      }
    }
    //
    for (var d in didNotAnswer) {
      wrongAnswers[d.$1.id - 1] = null;
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
    //
    wrong.addAll(didNotAnswer.map((e) => (e.$1, e.$2!)).toList());
    var result = ((correct.length / questions.length) * 100).toStringAsFixed(2);
    emit(FullTimeExploreResult(
      correct: correct,
      wrong: wrong,
      result: result,
    ));
    await submitResult(wrongAnswers, double.tryParse(result) ?? 0.0);
    sendResultCompleter?.complete();
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
        testName: test.information.title,
        userId: userData.uuid,
        testId: test.id,
        bankId: null,
        form: null,
        outerTestId: null,
        userName: userData.name,
      ),
    );
    //
    userData = userData.copyWith(
      tests: userData.tests + [(test.id, test.information.title)],
    );
    //
    await locator<UpdateUserDataUC>().call(userData: userData);
  }
}
