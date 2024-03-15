import 'package:moatmat_app/User/Features/tests/data/models/answer_m.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/question.dart';

class TestQuestionModel extends TestQuestion {
  TestQuestionModel({
    required super.id,
    required super.question,
    required super.explain,
    required super.equation,
    required super.image,
    required super.time,
    required super.editable,
    required super.answers,
  });
  factory TestQuestionModel.fromJson(Map json) {
    return TestQuestionModel(
      id: json["id"],
      question: json["question"],
      explain: json["explain"],
      equation: json["equation"],
      image: json["image"],
      time: json["time"],
      editable: json["editable"]??false,
      answers: List.generate(
        (json["answers"] as List).length,
        (index) {
          return TestAnswerModel.fromJson(json["answers"][index]);
        },
      ),
    );
  }
  factory TestQuestionModel.fromClass(TestQuestion question) {
    return TestQuestionModel(
      id: question.id,
      question: question.question,
      explain: question.explain,
      equation: question.equation,
      image: question.image,
      time: question.time,
      editable: question.editable,
      answers: question.answers,
    );
  }
  toJson() {
    return {
      "id":id,
      "question": question,
      "explain": explain,
      "equation": equation,
      "time": time,
      "editable": editable,
      "answers": answers.map((e) {
        return TestAnswerModel.fromClass(e).toJson();
      }).toList(),
    };
  }
}
