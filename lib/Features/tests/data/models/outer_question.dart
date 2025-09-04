
import '../../domain/entities/outer_test.dart';

class OuterQuestionModel extends OuterQuestion {
  OuterQuestionModel({
    required super.id,
    required super.trueAnswer,
  });

  factory OuterQuestionModel.fromJson(Map json) {
    return OuterQuestionModel(
      id: json['id'],
      trueAnswer: json['trueAnswer'],
    );
  }
  factory OuterQuestionModel.fromClass(OuterQuestion question) {
    return OuterQuestionModel(
      id: question.id,
      trueAnswer: question.trueAnswer,
    );
  }
  
  
  toJson() {
    return {
      'id': id,
      'trueAnswer': trueAnswer,
    };
  }
}
