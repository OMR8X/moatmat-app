import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/school/domain/entities/school.dart';
import 'package:moatmat_app/Features/school/domain/repository/repository.dart';

class GetSchoolUc {
  final SchoolRepository repository;

  GetSchoolUc({required this.repository});

  Future<Either<Failure, List<School>>> call() async {
    return await repository.getSchool();
  }
}
