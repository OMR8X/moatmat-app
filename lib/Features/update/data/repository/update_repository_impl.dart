import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Features/update/data/datasources/update_remote_ds.dart';
import 'package:moatmat_app/Features/update/domain/entites/update_info.dart';
import 'package:moatmat_app/Features/update/domain/repository/update_repository.dart';

class UpdateRepositoryImpl implements UpdateRepository {
  final UpdateRemoteDS dataSource;

  UpdateRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Exception, UpdateInfo>> checkUpdateState() async {
    try {
      var res = await dataSource.checkUpdateState();
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }
}
