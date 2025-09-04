import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Features/update/domain/repository/update_repository.dart';

import '../entites/update_info.dart';

class CheckUpdateStateUC {
  final UpdateRepository repository;

  CheckUpdateStateUC({required this.repository});
  Future<Either<Exception, UpdateInfo>> call() {
    return repository.checkUpdateState();
  }
}
