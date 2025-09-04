import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/errors/export_errors.dart';
import '../../domain/entites/code_center.dart';
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
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, CodeData>> generateCode({required int amount}) async {
    try {
      var res = await dataSource.generateCode(amount: amount);
      return right(res);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, List<CodeCenter>>> getCodesCenters({required String governorate}) async {
    try {
      var res = await dataSource.getCodesCenters(governorate: governorate);
      return right(res);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }
}
