import 'package:moatmat_app/User/Features/auth/domain/entites/user_like.dart';
import 'package:moatmat_app/User/Features/tests/data/models/question_m.dart';

import '../../../banks/data/models/bank_q_m.dart';

class UserLikeModel extends UserLike {
  UserLikeModel({
    required super.id,
    required super.bankId,
    required super.testId,
    required super.bQuestion,
    required super.tQuestion,
  });
  factory UserLikeModel.fromJson(Map json) {
    return UserLikeModel(
      id: json["id"],
      bankId: json["bank_id"],
      testId: json["test_id"],
      bQuestion:json["bank_question"]!=null? BankQuestionModel.fomJson(json["bank_question"]):null,
      tQuestion:json["test_question"]!=null? TestQuestionModel.fromJson(json["test_question"]):null,
    );
  }
  factory UserLikeModel.fromClass(UserLike like) {
    return UserLikeModel(
      id: like.id,
      bankId: like.bankId,
      testId: like.testId,
      bQuestion: like.bQuestion,
      tQuestion: like.tQuestion,
    );
  }
  toJson() {
    Map data = {
      "id": id,
      "bank_id": bankId,
      "test_id": testId,
    };
    if (bQuestion != null) {
      data["bank_question"] = BankQuestionModel.fromClass(bQuestion!).toJson();
    }
    if (tQuestion != null) {
      data["test_question"] = TestQuestionModel.fromClass(tQuestion!).toJson();
    }
    return data;
  }
}
