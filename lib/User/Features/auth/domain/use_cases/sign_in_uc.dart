import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entites/user_data.dart';
import '../repository/users_repository.dart';

class SignInUC {
  final UserRepository repository;

  SignInUC({required this.repository});
  Future<Either<Failure, Unit>> call({
    required String email,
    required String password,
  }) async {
    return await repository.signIn(email: email, password: password);
  }
}
