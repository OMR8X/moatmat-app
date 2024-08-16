import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/mini_test.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../auth/domain/entites/teacher_data.dart';

abstract class TestsRepository {
  // material teachers
  Future<Either<Failure, List<(String, int)>>> getMaterialTestClasses({
    required String material,
  });
  // material teachers
  Future<Either<Failure, List<(TeacherData, int)>>> getMaterialTestsTeachers({
    required String clas,
    required String material,
  });
  // teacher Tests
  Future<Either<Failure, List<(Test, int)>>> getTeacherTests({
    required String teacherEmail,
    required String clas,
    required String material,
  });
  // test by id
  Future<Either<Failure, Test>> getTestById({
    required int id,
  });
  //
  Future<Either<Failure, bool>> canDoTest(MiniTest test);
}
