import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../Core/errors/export_errors.dart';
import '../requests/retrieve_asset_request.dart';
import '../repository/asset_cache_repository.dart';

class RetrieveAssetUC {
  final AssetCacheRepository repository;

  RetrieveAssetUC({required this.repository});

  Future<Either<Failure, File>> call({
    required RetrieveAssetRequest request,
  }) async {
    return await repository.retrieveAsset(request: request);
  }
}
