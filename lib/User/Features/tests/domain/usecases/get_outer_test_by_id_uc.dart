import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entities/outer_test.dart';

class GetOuterTestByIdUseCase {
  final TestsRepository repository;

  GetOuterTestByIdUseCase({required this.repository});

 Future<Either<Failure, OuterTest>>  call({required int id}) async {
    return repository.getOuterTestById(id: id);
  }
}
