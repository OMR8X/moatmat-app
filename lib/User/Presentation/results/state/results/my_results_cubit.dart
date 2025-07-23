import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Core/functions/getters/get_wrong_answer.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_bank_by_id.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/User/Features/result/domain/usecases/get_my_results_uc.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/outer_test.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/get_outer_test_by_id_uc.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/get_test_by_id.dart';

import '../../../../Features/result/domain/entities/result.dart';
import '../../../../Features/tests/domain/entities/question.dart';

part 'my_results_state.dart';

class MyResultsCubit extends Cubit<MyResultsState> {
  MyResultsCubit() : super(MyResultsLoading());
  //
  List<Result> testsResults = [];
  List<Result> banksResults = [];
  List<Result> outerResults = [];
  //

  init() async {
    //
    emit(MyResultsLoading());
    //
    testsResults = [];
    banksResults = [];
    outerResults = [];
    //
    var res = await locator<GetMyResultsUC>().call();
    //
    res.fold((l) => emit(MyResultsError(error: l.toString())), (r) {
      //
      testsResults = r.where((e) {
        return e.testId != null || (e.bankId == null && e.outerTestId == null && e.testId == null);
      }).toList();
      banksResults = r.where((e) {
        return e.bankId != null;
      }).toList();
      //
      outerResults = r.where((e) {
        return e.bankId == null && e.testId == null && e.outerTestId != null;
      }).toList();
      //
      emit(MyResultsInitial(
        testsResults: testsResults,
        banksResults: banksResults,
        outerResults: outerResults,
      ));
    });
  }

  backToResults() {
    //
    emit(MyResultsLoading());
    //
    if (testsResults.isNotEmpty || banksResults.isNotEmpty) {
      emit(MyResultsInitial(
        testsResults: testsResults,
        banksResults: banksResults,
        outerResults: outerResults,
      ));
    } else {
      init();
    }
  }

  exploreResult(Result result) async {
    //
    emit(MyResultsLoading());
    //
    if (result.testId != null) {
      //
      var res = await locator<GetTestByIdUC>().call(id: result.testId!);
      //
      res.fold(
        (l) {
          emit(MyResultsError(error: l.toString()));
        },
        (r) {
          //
          if (!isTestPurchased(r)) {
            emit(MyResultsError(error: "الاختبار غير متاح للعرض."));
            return;
          }
          //
          List<(Question, int?)> wrongAnswers = getWrongAnswers(
            result,
            r.questions,
          );
          //
          int wrong = wrongAnswers.length;
          int truee = r.questions.length - wrong;
          //
          emit(MyResultsExploreResult(
            mark: (truee / r.questions.length) * 100,
            wrongAnswers: wrongAnswers,
            showTrueAnswers: r.properties.showAnswers ?? false,
          ));
        },
      );
    } else if (result.outerTestId != null) {
      var res = await locator<GetOuterTestByIdUseCase>().call(id: result.outerTestId!);
      //
      res.fold(
        (l) {
          emit(MyResultsError(error: l.toString()));
        },
        (r) {
          //
          List<(Question, int?)> wrongAnswers = [];
          //
          for (int i = 0; i < result.answers.length && i < r.forms[result.form!].questions.length; i++) {
            final answer = result.answers[i];
            final question = r.forms[result.form!].questions[i];

            if (answer != null) {
              if (answer != (question.trueAnswer + 1)) {
                wrongAnswers.add((question.toQuestion(), answer));
              }
            } else {
              wrongAnswers.add((question.toQuestion(), null));
            }
          }

          //
          int wrong = wrongAnswers.length;
          int truee = r.forms.first.questions.length - wrong;
          //

          //
          emit(
            MyResultsExploreResultOuterResult(
              length: r.information.length,
              mark: (truee / r.forms.first.questions.length) * 100,
              questions: r.forms[result.form!].questions,
              answers: result.answers,
            ),
          );
        },
      );
    } else if (result.bankId != null) {
      //
      var res = await locator<GetBankByIdUC>().call(id: result.bankId!);
      //
      res.fold(
        (l) {
          emit(MyResultsError(error: l.toString()));
        },
        (r) {
          //
          if (!isBankPurchased(r)) {
            emit(MyResultsError(error: "البنك غير متاح للعرض."));
            return;
          }
          //
          List<(Question, int?)> wrongAnswers = getWrongAnswers(
            result,
            r.questions,
          );
          //
          int wrong = wrongAnswers.length;
          int truee = r.questions.length - wrong;
          //
          emit(MyResultsExploreResult(
            mark: (truee / r.questions.length) * 100,
            wrongAnswers: wrongAnswers,
            showTrueAnswers: true,
          ));
        },
      );
    } else {
      emit(MyResultsExploreResult(
        mark: result.mark,
        wrongAnswers: result.wrongAnswers.map((e) {
          return (null, e);
        }).toList(),
        showTrueAnswers: true,
      ));
    }
  }

  bool isTestPurchased(Test? test) {
    //
    if (test == null ) {
      return false;
    }
    //
    bool purchased = false;
    //
    var items = locator<List<PurchaseItem>>().toSet().toList();
    //
    for (var i in items) {
      if (i.itemId.trim() == "$id" && i.itemType.trim() == "test") {
        purchased = true;
      }
      if ((i.itemId.trim() == test.information.teacher.trim()) && i.itemType.trim() == "teacher") {
        purchased = true;
      }
    }
    //
    return purchased;
  }

  bool isBankPurchased(Bank? bank) {
    //
    if (bank == null ) {
      return false;
    }
    //
    bool purchased = false;
    //
    var items = locator<List<PurchaseItem>>();
    //
    for (var i in items) {
      if (i.itemId == "$id" && i.itemType == "bank") {
        purchased = true;
      }
      if (i.itemId == bank.information.teacher && i.itemType == "teacher") {
        purchased = true;
      }
    }
    //
    return purchased;
  }
}
