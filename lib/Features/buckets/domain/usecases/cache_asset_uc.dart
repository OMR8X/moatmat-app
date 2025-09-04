import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:moatmat_app/Features/buckets/domain/requests/cache_asset_request.dart';

import '../../../../Core/errors/export_errors.dart';
import '../../../../Core/functions/coders/decode.dart';
import '../entities/cached_asset.dart';
import '../repository/asset_cache_repository.dart';

class CacheAssetUC {
  final AssetCacheRepository repository;

  CacheAssetUC({required this.repository});

  Future<Either<Failure, String>> call({
    required CacheAssetRequest request,
  }) async {
    return await repository.cacheAsset(request: request);
  }
}
