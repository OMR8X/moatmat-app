import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../repository/codes_repository.dart';

class UseCodeUC {
  final CodesRepository repository;

  UseCodeUC({required this.repository});
  Future<Either<Failure, Unit>> call({required String code}) async {
    return await repository.scanCode(code: code);
  }
}
