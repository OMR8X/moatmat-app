import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/result/data/datasources/ds.dart';
import 'package:moatmat_app/User/Features/result/domain/entities/result.dart';
import 'package:moatmat_app/User/Features/result/domain/repository/repository.dart';

class ResultsRepositoryImpl implements ResultsRepository {
  final ResultsDataSource dataSource;

  ResultsRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, Unit>> addResult({
    required Result result,
  }) async {
    try {
      await dataSource.addResult(result: result);
      return right(unit);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<Result>>> getLatestResults() async {
    try {
      var res = await dataSource.getLatestResults();
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<Result>>> getMyRepositoryResults({
    int? testId,
    int? bankId,
  }) async {
    try {
      var res = await dataSource.getMyRepositoryResults(
        testId: testId,
        bankId: bankId,
      );
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<Result>>> getMyResults() async {
    try {
      var res = await dataSource.getMyResults();
      return right(res);
    } on Exception catch (e) {
      print(e);
      return left(const AnonFailure());
    }
  }
}
