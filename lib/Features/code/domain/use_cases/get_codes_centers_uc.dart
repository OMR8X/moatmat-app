import 'package:dartz/dartz.dart';

import '../../../../Core/errors/export_errors.dart';
import '../entites/code_center.dart';
import '../repository/codes_repository.dart';

class GetCodesCentersUC {
  final CodesRepository repository;

  GetCodesCentersUC({required this.repository});

  Future<Either<Failure, List<CodeCenter>>> call({
    required String governorate,
  }) {
    return repository.getCodesCenters(governorate: governorate);
  }
}
