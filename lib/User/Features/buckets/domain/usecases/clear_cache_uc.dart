import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:moatmat_app/User/Features/buckets/domain/requests/cache_asset_request.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/functions/coders/decode.dart';
import '../entities/cached_asset.dart';
import '../repository/asset_cache_repository.dart';

class ClearCacheUC {
  final AssetCacheRepository repository;

  ClearCacheUC({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.clearCachedAssets();
  }
}
