import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/reports/domain/entities/reposrt_data.dart';

abstract class ReportsRepository {
  Future<Either<Failure, Unit>> reportOnTest({
    required String message,
    required String name,
    required String teacher,
    required int testID,
    required int questionID,
  });
  //
  Future<Either<Failure, Unit>> reportOnBank({
    required String message,
    required String name,
    required String teacher,
    required int bankID,
    required int questionID,
  });
  //
  Future<Either<Failure, List<ReportData>>> getReports();
}
