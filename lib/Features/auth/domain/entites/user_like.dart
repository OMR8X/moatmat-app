import 'package:moatmat_app/Features/tests/domain/entities/question.dart';

class UserLike {
  final int id;
  final int? bankId;
  final int? testId;
  final Question? bQuestion;
  final Question? tQuestion;

  UserLike({
    required this.id,
    required this.bankId,
    required this.testId,
    required this.bQuestion,
    required this.tQuestion,
  });
}
