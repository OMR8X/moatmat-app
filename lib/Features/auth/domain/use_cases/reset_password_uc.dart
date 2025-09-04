import 'package:dartz/dartz.dart';

import '../../../../Core/errors/export_errors.dart';
import '../repository/users_repository.dart';

class ResetPasswordUC {
  final UserRepository repository;

  ResetPasswordUC({required this.repository});
  Future<Either<Failure, Unit>> call({
    required String email,
    required String password,
    required String token,
  }) async {
    return repository.resetPassword(
      email: email,
      password: password,
      token: token,
    );
  }
}
