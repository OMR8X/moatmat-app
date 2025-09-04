import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/banks/domain/entites/bank.dart';

import '../../../auth/domain/entites/teacher_data.dart';

abstract class BanksRepository {
  // material teachers
  Future<Either<Failure, List<(String, int)>>> getMaterialBankClasses({
    required String material,
  });
  // material teachers
  Future<Either<Failure, List<(TeacherData, int)>>> getMaterialBanksTeachers({
    required String clas,
    required String material,
  });
  // teacher banks
  Future<Either<Failure, List<(Bank, int)>>> getTeacherBanks({
    required String teacherEmail,
    required String clas,
    required String material,
  });
  //
  // bank by id
  Future<Either<Failure, Bank>> getBankById({
    required int id,
  });
  //
  //
  Future<Either<Exception, List<Bank>>> getBanksByIds({
    required List<int> ids,
  });
}
