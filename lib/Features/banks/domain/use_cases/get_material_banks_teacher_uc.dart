import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Features/banks/domain/repository/repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/errors/export_errors.dart';
import '../../../auth/domain/entites/teacher_data.dart';

class GetMaterialBanksTeachersUC {
  final BanksRepository repository;

  GetMaterialBanksTeachersUC({required this.repository});
  Future<Either<Failure, List<(TeacherData, int)>>> call({
    required String clas,
    required String material,
  }) async {
    return await repository.getMaterialBanksTeachers(clas: clas, material: material);
  }
}
