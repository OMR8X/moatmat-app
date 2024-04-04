import '../../domain/entites/b_question_answer.dart';

class BankAnswerModel extends BankAnswer {
  BankAnswerModel({
    required super.answer,
    required super.equation,
    required super.isCorrect,
  });
  factory BankAnswerModel.fromJson(Map json) {
    return BankAnswerModel(
      answer: json["answer"],
      equation: json["equation"],
      isCorrect: json["is_correct"] ?? false,
    );
  }
  factory BankAnswerModel.fromClass(BankAnswer answer) {
    return BankAnswerModel(
      answer: answer.answer,
      equation: answer.equation,
      isCorrect: answer.isCorrect,
    );
  }
  toJson() {
    return {
      "answer": answer,
      "equation": equation,
      "is_correct": isCorrect,
    };
  }
}
