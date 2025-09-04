import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Features/banks/domain/repository/repository.dart';
import 'package:moatmat_app/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/errors/failures.dart';
import '../../../auth/domain/entites/teacher_data.dart';

class GetMaterialTestsTeachersUC {
  final TestsRepository repository;

  GetMaterialTestsTeachersUC({required this.repository});
  Future<Either<Failure, List<(TeacherData,int)>>>  call({
    required String clas,
    required String material,
  }) async {
    return await repository.getMaterialTestsTeachers(
        clas: clas, material: material);
  }
}
