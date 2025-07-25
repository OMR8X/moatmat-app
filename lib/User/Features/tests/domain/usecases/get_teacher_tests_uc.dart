import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';

class GetTeacherTestsUC {
  final TestsRepository repository;

  GetTeacherTestsUC({required this.repository});
  Future<Either<Failure, List<(Test, int)>>> call({
    required String teacherEmail,
    required String clas,
    required String material,
  }) async {
    return await repository.getTeacherTests(
      teacherEmail: teacherEmail,
      clas: clas,
      material: material,
    );
  }
}
