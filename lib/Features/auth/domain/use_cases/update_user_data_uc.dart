import 'package:dartz/dartz.dart';

import '../../../../Core/errors/export_errors.dart';
import '../entites/user_data.dart';
import '../repository/users_repository.dart';

class UpdateUserDataUC {
  final UserRepository repository;

  UpdateUserDataUC({required this.repository});
  Future<Either<Failure, Unit>> call({required UserData userData}) async {
    return await repository.updateUserData(userData: userData);
  }
}
