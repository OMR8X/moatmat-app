import 'package:dartz/dartz.dart';

import '../../../../Core/errors/export_errors.dart';
import '../entites/teacher_data.dart';
import '../repository/users_repository.dart';

class GetTeacherDataUC {
  final UserRepository repository;

  GetTeacherDataUC({required this.repository});
  Future<Either<Failure, TeacherData>> call() async {
    return await repository.getTeacherData();
  }
}
