import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';

class GetTestByIdUC {
  final TestsRepository repository;

  GetTestByIdUC({required this.repository});
  Future<Either<Failure, Test>> call({required int id}) async {
    return repository.getTestById(id: id);
  }
}
