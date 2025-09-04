import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Features/banks/domain/repository/repository.dart';
import 'package:moatmat_app/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/errors/failures.dart';

class GetSchoolTestClassesUC {
  final TestsRepository repository;

  GetSchoolTestClassesUC({required this.repository});
  Future<Either<Failure, List<(String, int)>>> call({
    required String schoolId,
    required String material,
  }) async {
    return await repository.getSchoolTestClasses(schoolId: schoolId, material: material);
  }
}
