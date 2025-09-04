import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/banks/domain/repository/repository.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/errors/failures.dart';

class GetMaterialTestClassesUC {
  final TestsRepository repository;

  GetMaterialTestClassesUC({required this.repository});
  Future<Either<Failure, List<(String, int)>>>  call({required String material}) async {
    return await repository.getMaterialTestClasses(material: material);
  }
}
