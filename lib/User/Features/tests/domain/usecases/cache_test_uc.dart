import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';

class CacheTestUC {
  final TestsRepository repository;

  CacheTestUC({required this.repository});

  Future<Either<Failure, Unit>> call({required Test test}) async {
    return await repository.cacheTest(test: test);
  }
} 