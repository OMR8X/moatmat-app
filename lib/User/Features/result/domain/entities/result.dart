class Result {
  //
  final int id;
  final String userId;
  final String testId;
  //
  final String name;
  final String marks;
  final String wrongAnswers;
  final DateTime date;
  final int period;
  //
  final String testName;

  Result({
    required this.id,
    required this.marks,
    required this.wrongAnswers,
    required this.period,
    required this.date,
    required this.name,
    required this.testName,
    required this.userId,
    required this.testId,
  });
  //
}
