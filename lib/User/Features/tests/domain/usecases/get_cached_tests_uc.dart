import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/errors/failures.dart';

class GetCachedTestsUC {
  final TestsRepository repository;

  GetCachedTestsUC({required this.repository});

  Future<Either<Failure, List<Test>>> call() async {
    return await repository.getCachedTests();
  }
} 