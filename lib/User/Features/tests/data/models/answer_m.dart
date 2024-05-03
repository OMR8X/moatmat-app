import 'package:moatmat_app/User/Features/tests/domain/entities/answer.dart';

class AnswerModel extends Answer {
  AnswerModel({
    required super.text,
    required super.equations,
    required super.trueAnswer,
    required super.image,
  });
  factory AnswerModel.fromJson(Map json) {
    return AnswerModel(
      text: json["text"],
      equations: List.generate(
        (json["equations"] as List?)?.length ?? 0,
        (i) => json["equations"][i],
      ),
      trueAnswer: json["true_answer"],
      image: json["image"],
    );
  }
  factory AnswerModel.fromClass(Answer answer) {
    return AnswerModel(
      text: answer.text,
      equations: answer.equations,
      trueAnswer: answer.trueAnswer,
      image: answer.image,
    );
  }

  toJson() {
    return {
      "text": text,
      "equations": equations,
      "true_answer": trueAnswer,
      "image": image,
    };
  }
}
