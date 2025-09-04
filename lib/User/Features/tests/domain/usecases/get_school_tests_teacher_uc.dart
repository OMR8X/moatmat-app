import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/banks/domain/repository/repository.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/errors/failures.dart';
import '../../../auth/domain/entites/teacher_data.dart';

class GetSchoolTestsTeacherUC {
  final TestsRepository repository;

  GetSchoolTestsTeacherUC({required this.repository});
  Future<Either<Failure, List<(TeacherData, int)>>> call({
    required String clas,
    required String schoolId,
    required String material,
  }) async {
    return await repository.getSchoolTestsTeachers(clas: clas, schoolId: schoolId, material: material);
  }
}
