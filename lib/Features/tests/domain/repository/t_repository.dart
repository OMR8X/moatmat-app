import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Features/tests/domain/entities/mini_test.dart';
import 'package:moatmat_app/Features/tests/domain/entities/test.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/errors/failures.dart';
import '../../../auth/domain/entites/teacher_data.dart';
import '../entities/outer_test.dart';

abstract class TestsRepository {
  // material teachers
  Future<Either<Failure, List<(String, int)>>> getMaterialTestClasses({
    required String material,
  });
  // material teachers
  Future<Either<Failure, List<(String, int)>>> getSchoolTestClasses({
    required String schoolId,
    required String material,
  });
  // material teachers
  Future<Either<Failure, List<(TeacherData, int)>>> getMaterialTestsTeachers({
    required String clas,
    required String material,
  });
  // schools teachers
  Future<Either<Failure, List<(TeacherData, int)>>> getSchoolTestsTeachers({
    required String clas,
    required String schoolId,
    required String material,
  });
  //
  // get outer test
  Future<Either<Failure, OuterTest>> getOuterTestById({required int id});
  //
  // teacher Tests
  Future<Either<Failure, List<(Test, int)>>> getTeacherTests({
    required String teacherEmail,
    required String clas,
    required String material,
  });
  // test by id
  Future<Either<Failure, Test>> getTestById({
    required int id,
    bool isOffline = false,
  });
  //
  Future<Either<Failure, List<Test>>> getTestsByIds({
    required List<int> ids,
    required bool showHidden,
  });
  //
  Future<Either<Failure, bool>> canDoTest(MiniTest test);
  //
  // Cache methods
  Future<Either<Failure, Unit>> cacheTest({required Test test});
  Future<Either<Failure, List<Test>>> getCachedTests();
  Future<Either<Failure, Unit>> clearCachedTests();
  Future<Either<Failure, Unit>> deleteCachedTest({required int testId});
}
