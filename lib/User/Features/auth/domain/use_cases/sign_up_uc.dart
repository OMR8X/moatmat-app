import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entites/user_data.dart';
import '../repository/users_repository.dart';
class SignUpUC {
  final UserRepository repository;

  SignUpUC({required this.repository});
  Future<Either<Failure, UserData>> call({
    required UserData userData,
    required String password,
  }) async {
    return await repository.signUp(
      userData: userData,
      password: password,
    );
  }
}
