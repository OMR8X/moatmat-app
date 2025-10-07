import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/Core/functions/coders/decode.dart';
import '../../../../Core/errors/export_errors.dart';
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
      debugPrint("debugging: caching asset -> ${request.fileName} -> ${request.fileRepositoryId}");
      debugPrint("debugging: caching asset -> ${decodeFileName(request.fileName)} -> ${request.fileRepositoryId}");
      // Check if asset is already cached to prevent duplicates
      final fileSize = await remoteDataSource.getFileSize(fileUrl: request.fileUrl);
      final File? cachedAssetResponse = await localDataSource.isAssetCached(
        fileName: request.fileName,
        repositoryId: request.fileRepositoryId,
        fileSize: fileSize,
      );

      if (cachedAssetResponse != null) {
        final cachedAsset = await localDataSource.getCachedAsset(fileName: request.fileName, repositoryId: request.fileRepositoryId);
        return Right(cachedAsset.path);
      }

      // Download the asset
      final assetData = await remoteDataSource.downloadAsset(request: request);

      // Save to local storage
      final cachedAssetModel = await localDataSource.saveAsset(data: assetData, request: request);
      //
      return Right(cachedAssetModel);
    } on Exception catch (e) {
      debugPrint("debugging: cacheAsset error $e");
      return Left(e.toFailure);
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
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, File?>> isAssetCached({
    required RetrieveAssetRequest request,
  }) async {
    try {
      // Get the expected file size from remote source
      int fileSize = 0;
      if (request.fileUrl != null) {
        try {
          fileSize = await remoteDataSource.getFileSize(fileUrl: request.fileUrl!);
        } catch (e) {
          debugPrint("Could not get file size: $e");
          // Continue with size 0 if we can't get the file size
        }
      }

      final File? isCached = await localDataSource.isAssetCached(
        fileName: request.fileName,
        repositoryId: request.fileRepositoryId,
        fileSize: fileSize,
      );
      return Right(isCached);
    } on Exception catch (e) {
      debugPrint("debugging: isAssetCached error $e");
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCachedAssets() async {
    try {
      await localDataSource.clearCachedAssets();
      return const Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }
}
