class ReportData {
  final int id;
  final String name;
  final String teacher;
  final int questionID;
  final String? message;
  final int? testId;
  final int? bankId;

  ReportData({
    required this.id,
    required this.message,
    required this.questionID,
    required this.testId,
    required this.bankId,
    required this.teacher,
    required this.name,
  });
  ReportData copyWith({
    int? id,
    String? message,
    String? name,
    String? teacher,
    int? questionID,
    int? testId,
    int? bankId,
  }) {
    return ReportData(
      id: id ?? this.id,
      message: message ?? this.message,
      teacher: teacher ?? this.teacher,
      name: name ?? this.name,
      questionID: questionID ?? this.questionID,
      testId: testId ?? this.testId,
      bankId: bankId ?? this.bankId,
    );
  }
}
