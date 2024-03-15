import 'package:moatmat_app/User/Features/reports/domain/entities/reposrt_data.dart';

class ReportDataModel extends ReportData {
  ReportDataModel({
    required super.id,
    required super.message,
    required super.questionID,
    required super.testId,
    required super.bankId,
    required super.teacher,
    required super.name,
  });
  factory ReportDataModel.fromJson(Map json) {
    return ReportDataModel(
      id: json["id"],
      message: json["message"],
      questionID: json["question_id"],
      testId: json["test_id"],
      bankId: json["bank_id"],
      teacher: json["teacher"],
      name: json["name"],
    );
  }
  factory ReportDataModel.fromClass(ReportData report) {
    return ReportDataModel(
      id: report.id,
      message: report.message,
      questionID: report.questionID,
      testId: report.testId,
      bankId: report.bankId,
      teacher: report.teacher,
      name: report.name,
    );
  }
  toJson() {
    return {
      "message": message,
      "question_id": questionID,
      "test_id": testId,
      "bank_id": bankId,
      "teacher": teacher,
      "name": name,
    };
  }
}
