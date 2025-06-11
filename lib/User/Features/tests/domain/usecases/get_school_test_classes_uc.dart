import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/banks/domain/repository/repository.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';

class GetSchoolTestClassesUC {
  final TestsRepository repository;

  GetSchoolTestClassesUC({required this.repository});
  Future<Either<Failure, List<(String, int)>>>  call({required String schoolId}) async {
    return await repository.getSchoolTestClasses(schoolId: schoolId);
  }
}
