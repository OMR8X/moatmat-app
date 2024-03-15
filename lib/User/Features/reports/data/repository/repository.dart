import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/reports/data/datasources/ds.dart';
import 'package:moatmat_app/User/Features/reports/domain/entities/reposrt_data.dart';
import 'package:moatmat_app/User/Features/reports/domain/repository/reports_repository.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';

class ReportRepositoryImpl implements ReportsRepository {
  final ReportsDataSource dataSource;

  ReportRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, Unit>> reportOnBank({
    required String message,
    required String teacher,
    required String name,
    required int bankID,
    required int questionID,
  }) async {
    try {
      await dataSource.reportOnBank(
        message: message,
        bankID: bankID,
        questionID: questionID,
        teacher: teacher,
        name: name,
      );
      return right(unit);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> reportOnTest({
    required String message,
    required String teacher,
    required String name,
    required int testID,
    required int questionID,
  }) async {
    try {
      await dataSource.reportOnTest(
        message: message,
        testID: testID,
        questionID: questionID,
        teacher: teacher,
        name: name,
      );
      return right(unit);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<ReportData>>> getReports() async {
    try {
      var res = await dataSource.getReports();
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }
}
