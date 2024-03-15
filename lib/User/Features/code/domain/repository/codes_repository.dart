import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entites/code_data.dart';

abstract class CodesRepository {
  // scan code
  Future<Either<Failure, Unit>> scanCode({required String code});
  //
  Future<Either<Failure, CodeData>> generateCode({required int amount});
  //
}
