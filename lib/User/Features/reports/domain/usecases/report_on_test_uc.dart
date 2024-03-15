import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/reports/domain/repository/reports_repository.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import '../../../../Core/errors/exceptions.dart';

class ReportOnTestUseCase {
  final ReportsRepository repository;

  ReportOnTestUseCase({required this.repository});
  Future<Either<Failure, Unit>> call({
    required String message,
    required String teacher,
    required String name,
    required int testID,
    required int questionID,
  }) async {
    return repository.reportOnTest(
      message: message,
      testID: testID,
      questionID: questionID,
      teacher: teacher,
      name: name,
    );
  }
}
