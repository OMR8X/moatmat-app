import 'package:dartz/dartz.dart';

import '../../../../Core/errors/export_errors.dart';
import '../entites/user_data.dart';
import '../repository/users_repository.dart';

class InsertUserData {
  final UserRepository repository;

  InsertUserData({required this.repository});
  Future<Either<Failure, Unit>> call({
    required UserData userData,
  }) async {
    return await repository.insertUserData(
      userData: userData,
    );
  }
}
