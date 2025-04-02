import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/result/domain/entities/result.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';

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
