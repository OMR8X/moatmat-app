import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/banks/domain/repository/repository.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';

class GetMaterialTestsTeachersUC {
  final TestsRepository repository;

  GetMaterialTestsTeachersUC({required this.repository});
  Future<Either<Failure, List<(String, int)>>>  call({
    required String clas,
    required String material,
  }) async {
    return await repository.getMaterialTestsTeachers(
        clas: clas, material: material);
  }
}
