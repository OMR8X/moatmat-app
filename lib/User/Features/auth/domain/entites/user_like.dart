import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_q.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/question.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';

class UserLike {
  final int id;
  final int? bankId;
  final int? testId;
  final BankQuestion? bQuestion;
  final TestQuestion? tQuestion;

  UserLike({
    required this.id,
    required this.bankId,
    required this.testId,
    required this.bQuestion,
    required this.tQuestion,
  });
}
