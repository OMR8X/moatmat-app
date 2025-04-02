import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_app/User/Features/banks/data/data_sources/banks_ds.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/repository/repository.dart';

class BanksRepositoryImpl implements BanksRepository {
  final BanksDataSource dataSource;

  BanksRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<(String, int)>>> getMaterialBankClasses(
      {required String material}) async {
    try {
      var res = await dataSource.getMaterialBankClasses(material: material);
      return right(res);
    } on Exception catch (e) {
      print(e);
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<(TeacherData, int)>>> getMaterialBanksTeachers(
      {required String clas, required String material}) async {
    try {
      var res = await dataSource.getMaterialBanksTeachers(
        clas: clas,
        material: material,
      );
      return right(res);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<(Bank, int)>>> getTeacherBanks(
      {required String teacherEmail,
      required String clas,
      required String material}) async {
    try {
      var res = await dataSource.getTeacherBanks(
        teacherEmail: teacherEmail,
        clas: clas,
        material: material,
      );
      return right(res);
    } on Exception catch (e) {
      print(e);
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Bank>> getBankById({required int id}) async {
    try {
      var res = await dataSource.getBankById(id: id);
      return right(res);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }

    @override
  Future<Either<Exception, List<Bank>>> getBanksByIds(
      {required List<int> ids}) async {
    try {
      var res = await dataSource.getBanksByIds(ids: ids);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }
}
