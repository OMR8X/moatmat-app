import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:moatmat_app/Core/functions/coders/decode.dart';
import 'package:moatmat_app/Core/services/cache/cache_constant.dart';
import 'package:moatmat_app/Features/buckets/domain/requests/cache_asset_request.dart';
import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/services/cache/cache_manager.dart';
import '../../../../Core/services/encryption_s.dart';

abstract class LocalAssetDataSource {
  /// Save asset data to local storage
  Future<String> saveAsset({
    required Uint8List data,
    required CacheAssetRequest request,
  });

  /// Retrieve cached asset by URL
  Future<File> getCachedAsset({
    required String fileName,
    required String repositoryId,
  });

  /// Check if asset exists in cache
  Future<File?> isAssetCached({
    required int fileSize,
    required String fileName,
    required String repositoryId,
  });

  /// Get cache directory path
  Future<String> getCacheDirectoryPath();

  /// Delete all assets for a specific ID
  Future<void> deleteAssetsByID({required String repositoryId});

  /// Clear all cached assets
  Future<void> clearCachedAssets();
}

class LocalAssetDataSourceImpl implements LocalAssetDataSource {
  static const String _cacheDirectoryName = 'cached_assets';
  late final Directory _cacheDirectorPath;
  final CacheManager cacheManager;

  LocalAssetDataSourceImpl({required Directory cacheDirectoryPath, required this.cacheManager}) : _cacheDirectorPath = cacheDirectoryPath;

  @override
  Future<String> saveAsset({
    required Uint8List data,
    required CacheAssetRequest request,
  }) async {
    try {
      debugPrint("debugging: saving asset to local storage");
      final cacheDir = await _getCacheDirectory();
      final id = request.fileRepositoryId;
      final fileName = decodeFileName(request.fileName);

      // Create ID-based directory structure
      debugPrint("debugging: creating id directory");
      final idDir = Directory('${cacheDir.path}/$id');
      if (!await idDir.exists()) {
        await idDir.create(recursive: true);
      }
      debugPrint("debugging: created id directory -> $idDir -> $fileName -> ${decodeFileName(request.fileName)}");
      final filePath = '${idDir.path}/$fileName';

      // Encrypt the file data before saving (in background thread)
      debugPrint("debugging: encrypting data");
      final encryptedData = await EncryptionService.encryptBinaryDataAsync(data);

      // Save the encrypted asset file
      debugPrint("debugging: saving encrypted data");
      final file = File(filePath);
      await file.writeAsBytes(encryptedData);

      debugPrint("debugging: saved asset to local storage");

      return filePath;
    } catch (e) {
      if (e is AssetCacheException) rethrow;
      debugPrint('Failed to save asset: ${e.toString()}');
      throw AssetCacheException();
    }
  }

  @override
  Future<File> getCachedAsset({
    required String fileName,
    required String repositoryId,
  }) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final idDir = Directory('${cacheDir.path}/$repositoryId');
      final filePath = '${idDir.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        // Read encrypted data and decrypt it (in background thread)
        final encryptedData = await file.readAsBytes();
        final decryptedData = await EncryptionService.decryptBinaryDataAsync(encryptedData);
        // Create a temporary file with decrypted data
        final tempDir = Directory.systemTemp;
        final tempFilePath = '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}_$fileName';
        final tempFile = File(tempFilePath);
        await tempFile.writeAsBytes(decryptedData);
        return tempFile;
      }
      return file;
    } catch (e) {
      debugPrint('Failed to get cached asset: ${e.toString()}');
      throw AssetCacheException();
    }
  }

  @override
  Future<File?> isAssetCached({
    required int fileSize,
    required String fileName,
    required String repositoryId,
  }) async {
    try {
      final cachedAsset = await getCachedAsset(fileName: fileName, repositoryId: repositoryId);

      // Check if file size matches the expected size
      final fileStats = await cachedAsset.stat();
      final localFileSize = fileStats.size;

      // Return true only if file exists AND sizes match
      debugPrint("debugging: localFileSize $localFileSize");
      debugPrint("debugging: fileSize $fileSize");
      return localFileSize == fileSize ? cachedAsset : null;
    } catch (e) {
      debugPrint('Error checking cached asset: ${e.toString()}');
      return null;
    }
  }

  @override
  Future<String> getCacheDirectoryPath() async {
    final cacheDir = await _getCacheDirectory();
    return cacheDir.path;
  }

  @override
  Future<void> deleteAssetsByID({required String repositoryId}) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final idDir = Directory('${cacheDir.path}/$repositoryId');

      if (await idDir.exists()) {
        // Delete the entire ID directory and all its contents
        await idDir.delete(recursive: true);
      }
    } catch (e) {
      throw AssetCacheException();
    }
  }

  @override
  Future<void> clearCachedAssets() async {
    try {
      final cacheDir = await _getCacheDirectory();
      await cacheManager().remove(CacheConstant.cachedTestsDataKey);
      await cacheDir.delete(recursive: true);
    } catch (e) {
      throw AssetCacheException();
    }
  }

  /// Get or create the cache directory
  Future<Directory> _getCacheDirectory() async {
    try {
      final cacheDir = Directory('${_cacheDirectorPath.path}/$_cacheDirectoryName');
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }
      return cacheDir;
    } catch (e) {
      throw AssetCacheException();
    }
  }
}
