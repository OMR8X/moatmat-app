import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/result/domain/entities/result.dart';
import 'package:moatmat_app/Features/tests/domain/entities/test.dart';

abstract class ResultsRepository {
  // add result
  Future<Either<Failure, Unit>> addResult({
    required Result result,
  });
  // get latest results
  Future<Either<Failure, List<Result>>> getLatestResults();
  //
  Future<Either<Failure, List<Result>>> getMyResults();
  Future<Either<Failure, List<Result>>> getMyRepositoryResults({
    int? testId,
    int? bankId,
  });
}
