import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/update/domain/entites/update_info.dart';

abstract class UpdateRepository {
  Future<Either<Exception, UpdateInfo>> checkUpdateState();
}
