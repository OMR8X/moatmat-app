import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/export_errors.dart';

class ClearCachedTestsUC {
  final TestsRepository repository;

  ClearCachedTestsUC({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.clearCachedTests();
  }
}
