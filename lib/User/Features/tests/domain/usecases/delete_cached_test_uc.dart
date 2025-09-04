import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/errors/failures.dart';

class DeleteCachedTestUC {
  final TestsRepository repository;

  DeleteCachedTestUC({required this.repository});

  Future<Either<Failure, Unit>> call({required int testId}) async {
    return await repository.deleteCachedTest(testId: testId);
  }
}
