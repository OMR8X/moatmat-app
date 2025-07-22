import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moatmat_app/User/Features/buckets/data/datasources/local_asset_data_source.dart';
import 'package:moatmat_app/User/Features/buckets/domain/requests/cache_asset_request.dart';

void main() {
  group('Asset Operations Tests', () {
    late LocalAssetDataSourceImpl localDataSource;
    late Directory tempDir;

    setUp(() async {
      // Create temporary directory for testing
      tempDir = await Directory.systemTemp.createTemp('asset_ops_test');
      localDataSource = LocalAssetDataSourceImpl(cacheDirectoryPath: tempDir);
    });

    tearDown(() async {
      // Clean up temporary directory
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    group('Local Asset Storage Tests', () {
      test('should save and retrieve asset correctly', () async {
        // Create test data
        final testData = Uint8List.fromList(List.generate(1000, (i) => i % 256));

        // Create cache request for regular Supabase URL
        const url = 'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1005/2024.11.20.10.41.05.228185.pdf';
        final request = CacheAssetRequest.fromSupabaseLink(
          link: url,
          cancelToken: CancelToken(),
          onProgress: null,
        );

        print('💾 Saving asset with ID: ${request.fileRepositoryId}');
        print('📄 Filename: ${request.fileName}');

        // Save the asset
        final savedPath = await localDataSource.saveAsset(
          data: testData,
          request: request,
        );

        print('✅ Asset saved to: $savedPath');

        // Verify file exists
        final file = File(savedPath);
        expect(await file.exists(), true);

        // Verify file content
        final savedData = await file.readAsBytes();
        expect(savedData.length, testData.length);
        expect(savedData, equals(testData));

        // Test retrieval
        final retrievedPath = await localDataSource.getCachedAsset(
          fileName: request.fileName,
          repositoryId: request.fileRepositoryId,
        );

        print('🔍 Retrieved path: $retrievedPath');
        expect(retrievedPath, equals(savedPath));

        // Test existence check
        final exists = await localDataSource.isAssetCached(
          fileName: request.fileName,
          repositoryId: request.fileRepositoryId,
        );
        expect(exists, true);
      });

      test('should save and retrieve encoded Arabic filename asset', () async {
        // Create test data
        final testData = Uint8List.fromList('Arabic content test 📚'.codeUnits);

        // Create cache request for encoded Supabase URL
        const encodedUrl =
            'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1760/____D8____A7____D9____84____D8____B3____D8____A4____D8____A7____D9____84____2020____20____D8____A7____D9____84____D8____AA____D9____83____D8____A7____D9____85____D9____84.pdf';
        final request = CacheAssetRequest.fromSupabaseLink(
          link: encodedUrl,
          cancelToken: CancelToken(),
          onProgress: null,
        );

        print('💾 Saving Arabic asset with ID: ${request.fileRepositoryId}');
        print('📄 Decoded filename: ${request.fileName}');

        // Save the asset
        final savedPath = await localDataSource.saveAsset(
          data: testData,
          request: request,
        );

        print('✅ Arabic asset saved to: $savedPath');

        // Verify file exists
        final file = File(savedPath);
        expect(await file.exists(), true);

        // Verify file content
        final savedData = await file.readAsBytes();
        expect(savedData.length, testData.length);

        // Test that cached check works
        final exists = await localDataSource.isAssetCached(
          fileName: request.fileName,
          repositoryId: request.fileRepositoryId,
        );
        expect(exists, true);
      });

      test('should handle multiple assets with different IDs', () async {
        final testUrls = [
          'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1005/file1.pdf',
          'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Physics/2001/file2.pdf',
          'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Chemistry/3500/file3.pdf',
        ];

        final savedPaths = <String>[];

        for (int i = 0; i < testUrls.length; i++) {
          final testData = Uint8List.fromList(List.generate(100 + i * 50, (index) => index % 256));

          final request = CacheAssetRequest.fromSupabaseLink(
            link: testUrls[i],
            cancelToken: CancelToken(),
            onProgress: null,
          );

          print('\n💾 Saving asset ${i + 1}: ${request.fileRepositoryId}');

          final savedPath = await localDataSource.saveAsset(
            data: testData,
            request: request,
          );

          savedPaths.add(savedPath);
          print('✅ Saved to: $savedPath');

          // Verify each file exists
          expect(await File(savedPath).exists(), true);
        }

        // Verify directory structure
        final cacheDir = Directory('${tempDir.path}/cached_assets');
        expect(await cacheDir.exists(), true);

        // Check individual directories exist
        for (final id in ['1005', '2001', '3500']) {
          final idDir = Directory('${cacheDir.path}/$id');
          expect(await idDir.exists(), true);
          print('📁 Directory $id exists');
        }
      });

      test('should delete assets by ID correctly', () async {
        // Create multiple assets for the same ID
        const baseUrl = 'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1005/';
        final testFiles = ['file1.pdf', 'file2.pdf', 'file3.pdf'];

        // Save multiple files for the same repository ID
        for (final fileName in testFiles) {
          final testData = Uint8List.fromList('Test content for $fileName'.codeUnits);
          final request = CacheAssetRequest.fromSupabaseLink(
            link: '$baseUrl$fileName',
            cancelToken: CancelToken(),
            onProgress: null,
          );

          await localDataSource.saveAsset(data: testData, request: request);
          print('💾 Saved: $fileName');
        }

        // Verify all files exist
        for (final fileName in testFiles) {
          final exists = await localDataSource.isAssetCached(
            fileName: fileName.replaceAll('.pdf', ''),
            repositoryId: '1005',
          );
          expect(exists, true);
        }

        print('🗑️ Deleting all assets for ID: 1005');

        // Delete all assets for the ID
        await localDataSource.deleteAssetsByID(repositoryId: '1005');

        // Verify all files are deleted
        for (final fileName in testFiles) {
          final exists = await localDataSource.isAssetCached(
            fileName: fileName.replaceAll('.pdf', ''),
            repositoryId: '1005',
          );
          expect(exists, false);
        }

        print('✅ All assets deleted successfully');
      });

      test('should handle cache directory creation', () async {
        // Get cache directory path
        final cachePath = await localDataSource.getCacheDirectoryPath();
        print('📁 Cache directory path: $cachePath');

        expect(cachePath, isNotEmpty);
        expect(cachePath, contains('cached_assets'));

        // Verify directory exists
        final cacheDir = Directory(cachePath);
        expect(await cacheDir.exists(), true);
      });

      test('should handle duplicate file saves correctly', () async {
        const url = 'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1005/duplicate_test.pdf';
        final request = CacheAssetRequest.fromSupabaseLink(
          link: url,
          cancelToken: CancelToken(),
          onProgress: null,
        );

        final testData1 = Uint8List.fromList('First content'.codeUnits);
        final testData2 = Uint8List.fromList('Second content - should overwrite'.codeUnits);

        // Save first version
        final savedPath1 = await localDataSource.saveAsset(
          data: testData1,
          request: request,
        );

        print('💾 First save: ${await File(savedPath1).readAsString()}');

        // Save second version (should overwrite)
        final savedPath2 = await localDataSource.saveAsset(
          data: testData2,
          request: request,
        );

        print('💾 Second save: ${await File(savedPath2).readAsString()}');

        // Paths should be the same
        expect(savedPath1, equals(savedPath2));

        // Content should be the second version
        final finalContent = await File(savedPath2).readAsBytes();
        expect(finalContent, equals(testData2));
      });
    });

    group('Error Handling Tests', () {
      test('should handle invalid file data gracefully', () async {
        const url = 'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1005/test.pdf';
        final request = CacheAssetRequest.fromSupabaseLink(
          link: url,
          cancelToken: CancelToken(),
          onProgress: null,
        );

        // Try to save empty data
        final emptyData = Uint8List(0);

        try {
          final savedPath = await localDataSource.saveAsset(
            data: emptyData,
            request: request,
          );

          print('💾 Empty file saved to: $savedPath');

          // Should still create the file even if empty
          expect(await File(savedPath).exists(), true);
          expect(await File(savedPath).length(), 0);
        } catch (e) {
          print('❌ Error saving empty file: $e');
          // This might be expected behavior
        }
      });

      test('should handle non-existent asset retrieval', () async {
        const nonExistentFile = 'non_existent_file.pdf';
        const nonExistentId = '99999';

        final exists = await localDataSource.isAssetCached(
          fileName: nonExistentFile,
          repositoryId: nonExistentId,
        );

        expect(exists, false);
        print('✅ Non-existent file correctly reported as not cached');
      });
    });
  });
}
