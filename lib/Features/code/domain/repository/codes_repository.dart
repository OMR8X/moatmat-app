import 'package:dartz/dartz.dart';

import '../../../../Core/errors/export_errors.dart';
import '../entites/code_center.dart';
import '../entites/code_data.dart';

abstract class CodesRepository {
  // scan code
  Future<Either<Failure, Unit>> scanCode({required String code});
  //
  Future<Either<Failure, CodeData>> generateCode({required int amount});
  //
  Future<Either<Failure, List<CodeCenter>>> getCodesCenters({
    required String governorate,
  });
}
