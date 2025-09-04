import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/result/data/datasources/ds.dart';
import 'package:moatmat_app/Features/result/domain/entities/result.dart';
import 'package:moatmat_app/Features/result/domain/repository/repository.dart';

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
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, List<Result>>> getLatestResults() async {
    try {
      var res = await dataSource.getLatestResults();
      return right(res);
    } on Exception catch (e) {
      return left(e.toFailure);
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
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, List<Result>>> getMyResults() async {
    try {
      var res = await dataSource.getMyResults();
      return right(res);
    } on Exception catch (e) {
      print(e);
      return left(e.toFailure);
    }
  }
}
