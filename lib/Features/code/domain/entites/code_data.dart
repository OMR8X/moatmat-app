class CodeData {
  final String id;
  final int amount;
  final DateTime? check1;
  final DateTime? check2;
  final bool? used;

  CodeData({
    required this.id,
    required this.amount,
    this.check1,
    this.check2,
    required this.used,
  });
}
