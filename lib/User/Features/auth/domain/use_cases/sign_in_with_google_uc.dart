import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../repository/users_repository.dart';

class SignInUCWithGoogleUC {
  final UserRepository repository;

  SignInUCWithGoogleUC({required this.repository});
  Future<Either<Failure, Unit>> call() async {
    return await repository.startSignInWithGoogle();
  }
}
