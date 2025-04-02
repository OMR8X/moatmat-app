import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entites/user_data.dart';
import '../repository/users_repository.dart';

class GetUserDataUC {
  final UserRepository repository;

  GetUserDataUC({required this.repository});
  Future<Either<Failure, UserData>> call({required String uuid, bool update = false}) async {
    return await repository.getUserData(uuid: uuid, update: update);
  }
}
