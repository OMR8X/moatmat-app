import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/errors/failures.dart';
import '../entities/test.dart';
import '../repository/t_repository.dart';

class GetTestsByIdsUC {
  final TestsRepository repository;

  GetTestsByIdsUC({required this.repository});

  Future<Either<Failure, List<Test>>> call({
    required List<int> ids,
    required bool showHidden,
  }) async {
    return await repository.getTestsByIds(ids: ids, showHidden: showHidden);
  }
}
