import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/school/data/datasources/school_datasource.dart';
import 'package:moatmat_app/User/Features/school/domain/entities/school.dart';
import 'package:moatmat_app/User/Features/school/domain/repository/repository.dart';

class SchoolRepositoryImpl extends SchoolRepository {
  final SchoolDataSoucre dataSoucre;

  SchoolRepositoryImpl({required this.dataSoucre});
  @override
  Future<Either<Failure, List<School>>> getSchool() async {
    try {
      var res = await dataSoucre.getSchool();
      return right(res);
    } on Exception {
      return left(AnonFailure());
    }
  }
}
