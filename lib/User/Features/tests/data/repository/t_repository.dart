import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:moatmat_app/User/Features/tests/data/datasources/tests_ds.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/mini_test.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../auth/domain/entites/teacher_data.dart';
import '../../domain/entities/outer_test.dart';

class TestsRepositoryImpl implements TestsRepository {
  final TestsDataSource dataSource;

  TestsRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<(String, int)>>> getMaterialTestClasses({required String material}) async {
    try {
      var res = await dataSource.getMaterialTestClasses(material: material);
      return right(res);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, OuterTest>> getOuterTestById({required int id}) async {
    try {
      final res = await dataSource.getOuterTestById(id: id);
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<(TeacherData, int)>>> getMaterialTestsTeachers({required String clas, required String material}) async {
    try {
      var res = await dataSource.getMaterialTestsTeachers(
        clas: clas,
        material: material,
      );
      return right(res);
    } on Exception catch (e) {
      debugPrint("Anon Exception: $e");
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<(Test, int)>>> getTeacherTests({required String teacherEmail, required String clas, required String material}) async {
    try {
      var res = await dataSource.getTeacherTests(
        teacherEmail: teacherEmail,
        clas: clas,
        material: material,
      );
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Test>> getTestById({required int id, bool isOffline = false}) async {
    try {
      if (isOffline) {
        // Try to get from cache first
        final cachedTests = await dataSource.getCachedTests();
        final cachedTest = cachedTests.where((test) => test.id == id).firstOrNull;
        if (cachedTest != null) {
          return right(cachedTest);
        }
      }
      var res = await dataSource.getTestById(id: id);
      return right(res);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> canDoTest(MiniTest test) async {
    try {
      var r = await dataSource.canDoTest(test: test);
      return right(r);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<Test>>> getTestsByIds({required List<int> ids, required bool showHidden}) async {
    try {
      final res = await dataSource.getTestsByIds(ids: ids, showHidden: showHidden);
      return right(res);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<(String, int)>>> getSchoolTestClasses({
    required String schoolId,
    required String material,
  }) async {
    try {
      var res = await dataSource.getSchoolTestClasses(schoolId: schoolId, material: material);
      return right(res);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<(TeacherData, int)>>> getSchoolTestsTeachers({
    required String clas,
    required String schoolId,
    required String material,
  }) async {
    try {
      var res = await dataSource.getSchoolTestsTeachers(
        clas: clas,
        schoolId: schoolId,
        material: material,
      );
      return right(res);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> cacheTest({required Test test}) async {
    try {
      var res = await dataSource.cacheTest(test: test);
      return right(res);
    } on CacheException catch (e) {
      debugPrint("Cache test exception: $e");
      return left(const CacheFailure());
    } on Exception catch (e) {
      debugPrint("Cache test exception: $e");
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<Test>>> getCachedTests() async {
    try {
      var res = await dataSource.getCachedTests();
      return right(res);
    } on InvalidCacheException {
      return left(const InvalidCacheFailure());
    } on CacheException {
      return left(const CacheFailure());
    } on Exception catch (e) {
      debugPrint("Get cached tests exception: $e");
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCachedTests() async {
    try {
      var res = await dataSource.clearCachedTests();
      return right(res);
    } on CacheException {
      return left(const CacheFailure());
    } on Exception catch (e) {
      debugPrint("Clear cached tests exception: $e");
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCachedTest({required int testId}) async {
    try {
      var res = await dataSource.deleteCachedTest(testId: testId);
      return right(res);
    } on CacheException {
      return left(const CacheFailure());
    } on Exception catch (e) {
      debugPrint("Delete cached test exception: $e");
      return left(const AnonFailure());
    }
  }
}
