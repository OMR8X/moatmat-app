import 'package:dartz/dartz.dart';

import '../../../../Core/errors/export_errors.dart';
import '../entites/code_data.dart';
import '../repository/codes_repository.dart';

class GenerateCodeUC {
  final CodesRepository repository;

  GenerateCodeUC({required this.repository});
  Future<Either<Failure, CodeData>> call({required int amount}) async {
    return repository.generateCode(amount: amount);
  }
}
