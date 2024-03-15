import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';

abstract class BanksRepository {
  // material teachers
  Future<Either<Failure, List<(String, int)>>> getMaterialBankClasses({
    required String material,
  });
  // material teachers
  Future<Either<Failure, List<(String, int)>>> getMaterialBanksTeachers({
    required String clas,
    required String material,
  });
  // teacher banks
  Future<Either<Failure, List<(Bank, int)>>> getTeacherBanks({
    required String teacher,
    required String clas,
    required String material,
  });
  //
  // bank by id
  Future<Either<Failure, Bank>> getBankById({
    required int id,
  });
}
