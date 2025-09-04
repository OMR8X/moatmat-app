import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';

import '../repository/asset_cache_repository.dart';

class ClearCacheUC {
  final AssetCacheRepository repository;

  ClearCacheUC({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.clearCachedAssets();
  }
}
