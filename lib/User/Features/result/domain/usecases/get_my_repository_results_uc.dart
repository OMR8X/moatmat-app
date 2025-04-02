import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/result/domain/repository/repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entities/result.dart';

class GetMyRepositoryResultsUc {
  final ResultsRepository repository;

  GetMyRepositoryResultsUc({required this.repository});

  Future<Either<Failure, List<Result>>> call({int? testId, int? bankId,}) {
    return repository.getMyRepositoryResults(
      testId: testId,
      bankId: bankId,
    );
  }
}
