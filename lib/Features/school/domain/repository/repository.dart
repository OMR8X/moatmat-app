import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/school/domain/entities/school.dart';

abstract class SchoolRepository {
  Future<Either<Failure, List<School>>> getSchool();
}
