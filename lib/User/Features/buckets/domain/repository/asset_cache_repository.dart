import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import '../entities/cached_asset.dart';
import '../requests/cache_asset_request.dart';
import '../requests/retrieve_asset_request.dart';

abstract class AssetCacheRepository {
  /// Cache an asset from the given URL
  /// Returns the cached asset information on success
  Future<Either<Failure, String>> cacheAsset({
    required CacheAssetRequest request,
  });

  /// Retrieve a cached asset by its original URL
  /// Returns a File object pointing to the cached asset
  Future<Either<Failure, File>> retrieveAsset({
    required RetrieveAssetRequest request,
  });

  /// Check if an asset is cached for the given URL
  Future<Either<Failure, bool>> isAssetCached({
    required RetrieveAssetRequest request,
  });

  /// Clear all cached assets
  Future<Either<Failure, Unit>> clearCachedAssets();
}
