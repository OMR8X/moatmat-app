import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/reports/domain/repository/reports_repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../banks/domain/entites/bank.dart';

class ReportOnBankUseCase {
  final ReportsRepository repository;

  ReportOnBankUseCase({required this.repository});
  Future<Either<Failure, Unit>> call({
    required String message,
    required String teacher,
    required String name,
    required int bankID,
    required int questionID,
  }) async {
    return repository.reportOnBank(
      message: message,
      bankID: bankID,
      questionID: questionID,
      name: name,
      teacher: teacher
    );
  }
}
