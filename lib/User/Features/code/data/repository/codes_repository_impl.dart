import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../domain/entites/code_data.dart';
import '../../domain/repository/codes_repository.dart';
import '../data_sources/codes_ds.dart';

class CodesRepositoryImpl implements CodesRepository {
  final CodesDataSource dataSource;

  CodesRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, Unit>> scanCode({required String code}) async {
    try {
      await dataSource.scanCode(code: code);
      return right(unit);
    } on CodesUsedException {
      return left(const CodesUsedFailure());
    } on PostgrestException catch (e) {
      if (e.code == "22P02") {
        return left(const InvalidDataFailure());
      } else {
        return left(const AnonFailure());
      }
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, CodeData>> generateCode({required int amount}) async {
    try {
      var res = await dataSource.generateCode(amount: amount);
      return right(res);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }
}
