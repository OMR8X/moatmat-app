
import '../../domain/entities/outer_test.dart';
import 'outer_question.dart';

class OuterTestFormModel extends OuterTestForm {
  OuterTestFormModel({
    required super.id,
    required super.questions,
  });
  factory OuterTestFormModel.fromJson(Map json) {
    return OuterTestFormModel(
      id: json['id'],
      questions: (json['questions'] as List).map((e) {
        return OuterQuestionModel.fromJson(e);
      }).toList(),
    );
  }
  factory OuterTestFormModel.fromClass(OuterTestForm form) {
    return OuterTestFormModel(
      id: form.id,
      questions: form.questions,
    );
  }

  toJson() {
    return {
      'id': id,
      'questions': questions.map((e) {
        return OuterQuestionModel.fromClass(e).toJson();
      }).toList(),
    };
  }
}
