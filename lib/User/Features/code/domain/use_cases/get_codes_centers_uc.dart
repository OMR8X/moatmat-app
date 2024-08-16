import 'package:dartz/dartz.dart';

import '../entites/code_center.dart';
import '../repository/codes_repository.dart';

class GetCodesCentersUC {
  final CodesRepository repository;

  GetCodesCentersUC({required this.repository});

  Future<Either<Exception, List<CodeCenter>>> call({
    required String governorate,
  }) {
    return repository.getCodesCenters(governorate: governorate);
  }
}
