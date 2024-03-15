import '../../domain/entites/b_question_answer.dart';

class BankAnswerModel extends BankAnswer {
  BankAnswerModel({
    required super.answer,
    required super.isCorrect,
  });
  factory BankAnswerModel.fromJson(Map json) {
    return BankAnswerModel(
      answer: json["answer"],
      isCorrect: json["is_correct"] ?? false,
    );
  }
  factory BankAnswerModel.fromClass(BankAnswer answer) {
    return BankAnswerModel(
      answer: answer.answer,
      isCorrect: answer.isCorrect,
    );
  }
  toJson() {
    return {
      "answer": answer,
      "is_correct": isCorrect,
    };
  }
}
