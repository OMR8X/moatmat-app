import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/school/data/datasources/school_datasource.dart';
import 'package:moatmat_app/Features/school/domain/entities/school.dart';
import 'package:moatmat_app/Features/school/domain/repository/repository.dart';

class SchoolRepositoryImpl extends SchoolRepository {
  final SchoolDataSoucre dataSoucre;

  SchoolRepositoryImpl({required this.dataSoucre});
  @override
  Future<Either<Failure, List<School>>> getSchool() async {
    try {
      var res = await dataSoucre.getSchool();
      return right(res);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }
}
