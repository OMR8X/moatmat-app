import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/banks/domain/repository/repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entites/bank.dart';

class GetTeacherBanksUC {
  final BanksRepository repository;

  GetTeacherBanksUC({required this.repository});
  Future<Either<Failure, List<(Bank, int)>>> call({
    required String teacherEmail,
    required String clas,
    required String material,
  }) async {
    return await repository.getTeacherBanks(
      teacherEmail: teacherEmail,
      clas: clas,
      material: material,
    );
  }
}
