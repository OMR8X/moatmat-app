import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/tests/data/datasources/tests_ds.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';

class TestsRepositoryImpl implements TestsRepository {
  final TestsDataSource dataSource;

  TestsRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<(String, int)>>> getMaterialTestClasses(
      {required String material}) async {
    try {
      var res = await dataSource.getMaterialTestClasses(material: material);
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<(String, int)>>> getMaterialTestsTeachers(
      {required String clas, required String material}) async {
    try {
      var res = await dataSource.getMaterialTestsTeachers(
        clas: clas,
        material: material,
      );
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<(Test, int)>>> getTeacherTests(
      {required String teacher,
      required String clas,
      required String material}) async {
    try {
      var res = await dataSource.getTeacherTests(
        teacher: teacher,
        clas: clas,
        material: material,
      );
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Test>> getTestById({required int id}) async {
    try {
      var res = await dataSource.getTestById(id: id);
      return right(res);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }
}
