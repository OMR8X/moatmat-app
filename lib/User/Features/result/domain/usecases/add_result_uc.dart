import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/result/domain/repository/repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../tests/domain/entities/test.dart';
import '../entities/result.dart';

class AddResultUC {
  final ResultsRepository repository;

  AddResultUC({required this.repository});

  Future<Either<Failure, Unit>> call({required Result result,required Test test}) async {
    return await repository.addResult(result: result,test: test);
  }
}
