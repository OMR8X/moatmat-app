import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entities/test.dart';
import 't_repository.dart';

class GetTestsByIdsUC {
  final TestsRepository repository;

  GetTestsByIdsUC({required this.repository});

  Future<Either<Failure, List<Test>>> call({
    required List<int> ids,
  }) async {
    return await repository.getTestsByIds(ids: ids);
  }
}
