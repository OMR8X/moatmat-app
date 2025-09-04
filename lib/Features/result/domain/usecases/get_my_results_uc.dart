import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Features/result/domain/repository/repository.dart';

import '../../../../Core/errors/export_errors.dart';
import '../entities/result.dart';

class GetMyResultsUC {
  final ResultsRepository repository;

  GetMyResultsUC({required this.repository});

  Future<Either<Failure, List<Result>>> call() {
    return repository.getMyResults();
  }
}
