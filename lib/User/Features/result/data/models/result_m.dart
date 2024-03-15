import 'package:moatmat_app/User/Features/result/domain/entities/result.dart';

class ResultModel extends Result {
  ResultModel({
    required super.id,
    required super.marks,
    required super.wrongAnswers,
    required super.period,
    required super.date,
    required super.name,
    required super.testName,
    required super.userId,
    required super.testId,
  });
  factory ResultModel.fromJson(Map json) {
    return ResultModel(
      id: json["id"],
      marks: json["marks"],
      wrongAnswers: json["wrong_answers"],
      period: json["period"],
      date: DateTime.parse(json["date"]),
      name: json["name"],
      testName: json["test_name"],
      userId: json["user_id"],
      testId: json["test_id"],
    );
  }
  factory ResultModel.fromClass(Result result) {
    return ResultModel(
      id: result.id,
      marks: result.marks,
      wrongAnswers: result.wrongAnswers,
      period: result.period,
      date: result.date,
      name: result.name,
      testName: result.testName,
      userId: result.userId,
      testId: result.testId,
    );
  }
  toJson() {
    return {
      "marks": marks,
      "wrong_answers": wrongAnswers,
      "period": period,
      "date": date.toString(),
      "name": name,
      "test_name": testName,
      "user_id": userId,
      "test_id": testId,
    };
  }
}
