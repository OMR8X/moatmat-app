import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../Core/errors/exceptions.dart';
import '../../domain/entities/cached_asset.dart';
import '../../domain/repository/asset_cache_repository.dart';
import '../../domain/requests/cache_asset_request.dart';
import '../../domain/requests/retrieve_asset_request.dart';
import '../datasources/local_asset_data_source.dart';
import '../datasources/remote_asset_data_source.dart';

class AssetCacheRepositoryImpl implements AssetCacheRepository {
  final LocalAssetDataSource localDataSource;
  final RemoteAssetDataSource remoteDataSource;

  AssetCacheRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, String>> cacheAsset({
    required CacheAssetRequest request,
  }) async {
    try {
      // Check if asset is already cached to prevent duplicates
      final isAlreadyCached = await localDataSource.isAssetCached(fileName: request.fileName, repositoryId: request.fileRepositoryId);
      if (isAlreadyCached) {
        final cachedAsset = await localDataSource.getCachedAsset(fileName: request.fileName, repositoryId: request.fileRepositoryId);
        return Right(cachedAsset.path);
      }

      // Download the asset
      final assetData = await remoteDataSource.downloadAsset(request: request);

      // Save to local storage
      final cachedAssetModel = await localDataSource.saveAsset(data: assetData, request: request);
      //
      return Right(cachedAssetModel);
    } on AssetNotExistsException {
      return const Left(AssetNotExistsFailure());
    } catch (e) {
      return const Left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, File>> retrieveAsset({
    required RetrieveAssetRequest request,
  }) async {
    try {
      // Get cached asset file
      final cachedFile = await localDataSource.getCachedAsset(fileName: request.fileName, repositoryId: request.fileRepositoryId);

      // Verify file still exists and is accessible
      if (await cachedFile.exists()) {
        return Right(cachedFile);
      } else {
        return const Left(FileNotFoundFailure());
      }
    } on AssetFileCorruptedException {
      return const Left(AssetFileCorruptedFailure());
    } on AssetCacheException {
      return const Left(AssetCacheFailure());
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return const Left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isAssetCached({
    required RetrieveAssetRequest request,
  }) async {
    try {
      final isCached = await localDataSource.isAssetCached(fileName: request.fileName, repositoryId: request.fileRepositoryId);
      return Right(isCached);
    } on AssetCacheException {
      return const Left(AssetCacheFailure());
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return const Left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCachedAssets() async {
    try {
      await localDataSource.clearCachedAssets();
      return const Right(unit);
    } catch (e) {
      return const Left(AnonFailure());
    }
  }
}
