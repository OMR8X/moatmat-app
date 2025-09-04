import 'package:dartz/dartz.dart';

import '../../../../Core/errors/export_errors.dart';
import '../entites/user_data.dart';
import '../repository/users_repository.dart';

class SignOutUC {
  final UserRepository repository;

  SignOutUC({required this.repository});
  Future<Either<Failure, Unit>> call() async {
    return await repository.signOut();
  }
}
