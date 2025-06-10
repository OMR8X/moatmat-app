import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/school/domain/entities/school.dart';

abstract class SchoolRepository {
  Future<Either<Failure, List<School>>> getSchool();
}