import 'package:dartz/dartz.dart';

import '../../../../Core/errors/export_errors.dart';
import '../entites/user_data.dart';
import '../repository/users_repository.dart';

class SignUpUC {
  final UserRepository repository;

  SignUpUC({required this.repository});
  Future<Either<Failure, Unit>> call({
    required UserData userData,
    required String password,
  }) async {
    return await repository.signUp(
      userData: userData,
      password: password,
    );
  }
}
