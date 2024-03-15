import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/banks/domain/repository/repository.dart';

import '../../../../Core/errors/exceptions.dart';

class GetMaterialBankClassesUC {
  final BanksRepository repository;

  GetMaterialBankClassesUC({required this.repository});
  Future<Either<Failure, List<(String, int)>>>  call({required String material}) async {
    return await repository.getMaterialBankClasses(material: material);
  }
}
