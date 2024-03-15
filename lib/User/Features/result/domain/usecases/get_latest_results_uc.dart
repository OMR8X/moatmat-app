import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/result/domain/repository/repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entities/result.dart';

class GetLatestResultUC {
  final ResultsRepository repository;

  GetLatestResultUC({required this.repository});

  Future<Either<Failure, List<Result>>> call() async {
    return await repository.getLatestResults();
  }
}
