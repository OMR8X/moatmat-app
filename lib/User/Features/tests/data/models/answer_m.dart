import 'package:moatmat_app/User/Features/tests/domain/entities/answer.dart';

class TestAnswerModel extends TestAnswer {
  TestAnswerModel({
    required super.answer,
    required super.isCorrect,
  });
  factory TestAnswerModel.fromJson(Map json) {
    return TestAnswerModel(
      answer: json["answer"],
      isCorrect: json["is_correct"],
    );
  }
  factory TestAnswerModel.fromClass(TestAnswer answer) {
    return TestAnswerModel(
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
