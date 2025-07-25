import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/mini_test.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';

class CanDoTestUC {
  final TestsRepository repository;

  CanDoTestUC({required this.repository});
  Future<Either<Failure, bool>> call({required MiniTest test}) async {
    return await repository.canDoTest(test);
  }
}
