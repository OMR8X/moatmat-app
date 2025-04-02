class Result {
  //
  final int id;
  //
  final String userId;
  //
  final String userNumber;
  //
  final double mark;
  //
  final int? testId;
  //
  final int? bankId;
  //
  final int? outerTestId;
  //
  final int? form;
  //
  final List<int?> answers;
  //
  final List<int?> wrongAnswers;
  //
  final DateTime date;
  //
  final int period;
  //
  final String testName;
  //
  final String userName;
  //
  final double? testAverage;
  //
  final String? teacherEmail;

  Result({
    required this.id,
    required this.userId,
    required this.userNumber,
    required this.testId,
    required this.bankId,
    required this.form,
    required this.outerTestId,
    required this.mark,
    required this.answers,
    required this.wrongAnswers,
    required this.date,
    required this.period,
    required this.testName,
    required this.userName,
    this.testAverage,
    this.teacherEmail,
  });

  Result copyWith({
    int? id,
    String? userId,
    String? userNumber,
    double? mark,
    int? testId,
    int? bankId,
    List<int?>? answers,
    List<int?>? wrongAnswers,
    DateTime? date,
    int? period,
    String? testName,
    String? userName,
    double? testAverage,
    int? form,
    int? outerTestId,
  }) {
    return Result(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userNumber: userNumber ?? this.userNumber,
      testId: testId ?? this.testId,
      bankId: bankId ?? this.bankId,
      mark: mark ?? this.mark,
      answers: answers ?? this.answers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      date: date ?? this.date,
      period: period ?? this.period,
      testName: testName ?? this.testName,
      userName: userName ?? this.userName,
      form: form ?? this.form,
      outerTestId: outerTestId ?? this.outerTestId,
    );
  }
}
