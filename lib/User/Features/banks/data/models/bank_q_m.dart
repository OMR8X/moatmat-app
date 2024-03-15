import 'package:moatmat_app/User/Features/banks/data/models/b_answer_m.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_q.dart';

class BankQuestionModel extends BankQuestion {
  BankQuestionModel({
    required super.id,
    required super.question,
    required super.explain,
    required super.equation,
    required super.image,
    required super.answers,
  });
  factory BankQuestionModel.fomJson(Map json) {
    return BankQuestionModel(
      id: json["id"],
      explain: json["explain"],
      question: json["question"],
      equation: json["equation"],
      image: json["image"],
      answers: List.generate((json["answers"] as List).length, (index) {
        return BankAnswerModel.fromJson(json["answers"][index]);
      }),
    );
  }
  factory BankQuestionModel.fromClass(BankQuestion bankQuestion) {
    return BankQuestionModel(
      id: bankQuestion.id,
      explain: bankQuestion.explain,
      question: bankQuestion.question,
      equation: bankQuestion.equation,
      image: bankQuestion.image,
      answers: bankQuestion.answers,
    );
  }
  Map toJson() {
    return {
      "id": id,
      "question": question,
      "explain": explain,
      "equation": equation,
      "image": image,
      "answers":
          answers.map((e) => BankAnswerModel.fromClass(e).toJson()).toList(),
    };
  }
}
