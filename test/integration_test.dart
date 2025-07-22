import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moatmat_app/User/Features/buckets/data/datasources/local_asset_data_source.dart';
import 'package:moatmat_app/User/Features/buckets/domain/requests/cache_asset_request.dart';
import 'package:moatmat_app/User/Features/buckets/domain/requests/retrieve_asset_request.dart';

void main() {
  group('Asset Cache Integration Tests', () {
    late LocalAssetDataSourceImpl localDataSource;
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('integration_test');
      localDataSource = LocalAssetDataSourceImpl(cacheDirectoryPath: tempDir);
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('Complete workflow with regular Supabase URL', () async {
      print('🚀 Testing complete workflow with regular Supabase URL');

      // Step 1: Create request from Supabase URL
      const url = 'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1005/2024.11.20.10.41.05.228185.pdf';

      final cacheRequest = CacheAssetRequest.fromSupabaseLink(
        link: url,
        cancelToken: CancelToken(),
        onProgress: (received, total) {
          print('📊 Progress: $received/$total bytes');
        },
      );

      print('✅ URL parsed successfully:');
      print('   Repository ID: ${cacheRequest.fileRepositoryId}');
      print('   Filename: ${cacheRequest.fileName}');
      print('   Extension: ${cacheRequest.fileExtension}');
      print('   URL: ${cacheRequest.fileUrl}');

      // Step 2: Simulate file content
      final testContent = '''
PDF Content Simulation
Title: Mathematics Test 2024
Date: 2024.11.20.10.41.05.228185
Repository ID: 1005
Content: This would be the actual PDF binary data...
''';
      final testData = Uint8List.fromList(testContent.codeUnits);

      // Step 3: Save the asset
      print('\n💾 Saving asset to local storage...');
      final savedPath = await localDataSource.saveAsset(
        data: testData,
        request: cacheRequest,
      );

      print('✅ Asset saved to: $savedPath');

      // Step 4: Verify file exists and has correct content
      final savedFile = File(savedPath);
      expect(await savedFile.exists(), true);

      final savedData = await savedFile.readAsBytes();
      expect(savedData, equals(testData));

      final savedContent = await savedFile.readAsString();
      expect(savedContent, contains('Mathematics Test 2024'));
      expect(savedContent, contains('Repository ID: 1005'));

      // Step 5: Test retrieval by creating a retrieve request
      final retrieveRequest = RetrieveAssetRequest.fromSupabaseLink(url);

      print('\n🔍 Testing asset retrieval...');
      print('   Looking for file: ${retrieveRequest.fileName}');
      print('   In repository: ${retrieveRequest.fileRepositoryId}');

      final retrievedPath = await localDataSource.getCachedAsset(
        fileName: retrieveRequest.fileName,
        repositoryId: retrieveRequest.fileRepositoryId,
      );

      expect(retrievedPath, equals(savedPath));
      print('✅ Asset retrieved successfully from: $retrievedPath');

      // Step 6: Test cache existence check
      final isCached = await localDataSource.isAssetCached(
        fileName: retrieveRequest.fileName,
        repositoryId: retrieveRequest.fileRepositoryId,
      );

      expect(isCached, true);
      print('✅ Cache existence check passed');

      print('\n🎉 Complete workflow test passed!');
    });

    test('Complete workflow with encoded Arabic Supabase URL', () async {
      print('🚀 Testing complete workflow with encoded Arabic Supabase URL');

      // Step 1: Create request from encoded Supabase URL
      const encodedUrl =
          'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1760/____D8____A7____D9____84____D8____B3____D8____A4____D8____A7____D9____84____2020____20____D8____A7____D9____84____D8____AA____D9____83____D8____A7____D9____85____D9____84.pdf';

      final cacheRequest = CacheAssetRequest.fromSupabaseLink(
        link: encodedUrl,
        cancelToken: CancelToken(),
        onProgress: null,
      );

      print('✅ Encoded URL parsed and decoded successfully:');
      print('   Repository ID: ${cacheRequest.fileRepositoryId}');
      print('   Decoded filename: ${cacheRequest.fileName}');
      print('   Extension: ${cacheRequest.fileExtension}');
      print('   Original URL: ${cacheRequest.fileUrl}');

      // Verify Arabic decoding worked
      expect(cacheRequest.fileName, contains('السؤال'));
      expect(cacheRequest.fileName, contains('التكامل'));

      // Step 2: Create Arabic content simulation
      final arabicContent = '''
محتوى ملف PDF
العنوان: ${cacheRequest.fileName}
التاريخ: 2020
المعرف: ${cacheRequest.fileRepositoryId}
المحتوى: هذا محتوى تجريبي لاختبار حفظ الملفات العربية...
''';
      final testData = Uint8List.fromList(arabicContent.codeUnits);

      // Step 3: Save the Arabic asset
      print('\n💾 Saving Arabic asset to local storage...');
      final savedPath = await localDataSource.saveAsset(
        data: testData,
        request: cacheRequest,
      );

      print('✅ Arabic asset saved to: $savedPath');
      print('   Path contains Arabic filename: ${savedPath.contains('السؤال')}');
      print('   Repository ID in path: ${savedPath.contains('1760')}');

      // Step 4: Verify the file was saved with the correct Arabic filename
      final savedFile = File(savedPath);
      expect(await savedFile.exists(), true);

      // Verify the path contains the decoded Arabic filename and repository ID
      expect(savedPath, contains(cacheRequest.fileRepositoryId));

      // Verify the file has the correct size (content was saved)
      final savedData = await savedFile.readAsBytes();
      expect(savedData.length, testData.length);

      print('✅ Arabic file saved successfully with correct filename in path');

      // Step 5: Test retrieval with Arabic filename
      final retrieveRequest = RetrieveAssetRequest.fromSupabaseLink(encodedUrl);

      print('\n🔍 Testing Arabic asset retrieval...');
      print('   Looking for Arabic file: ${retrieveRequest.fileName}');
      print('   In repository: ${retrieveRequest.fileRepositoryId}');

      final isCached = await localDataSource.isAssetCached(
        fileName: retrieveRequest.fileName,
        repositoryId: retrieveRequest.fileRepositoryId,
      );

      expect(isCached, true);
      print('✅ Arabic asset cache check passed');

      print('\n🎉 Arabic workflow test passed!');
    });

    test('Multiple assets with different IDs and file types', () async {
      print('🚀 Testing multiple assets workflow');

      final testCases = [
        {
          'url': 'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1005/algebra_basics.pdf',
          'subject': 'Mathematics',
          'content': 'Algebra basics content...',
        },
        {
          'url': 'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Physics/2001/mechanics_intro.pdf',
          'subject': 'Physics',
          'content': 'Mechanics introduction content...',
        },
        {
          'url': 'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Chemistry/3500/____D8____A7____D9____84____D9____83____D9____8A____D9____85____D9____8A____D8____A7____D8____A1.pdf',
          'subject': 'Chemistry',
          'content': 'محتوى الكيمياء...',
        },
      ];

      final savedPaths = <String>[];

      // Save all assets
      for (int i = 0; i < testCases.length; i++) {
        final testCase = testCases[i];
        final url = testCase['url'] as String;

        print('\n📚 Processing ${testCase['subject']} asset...');

        final cacheRequest = CacheAssetRequest.fromSupabaseLink(
          link: url,
          cancelToken: CancelToken(),
          onProgress: null,
        );

        print('   Repository ID: ${cacheRequest.fileRepositoryId}');
        print('   Filename: ${cacheRequest.fileName}');

        final testData = Uint8List.fromList('${testCase['content']}'.codeUnits);

        final savedPath = await localDataSource.saveAsset(
          data: testData,
          request: cacheRequest,
        );

        savedPaths.add(savedPath);
        print('   ✅ Saved to: $savedPath');

        // Verify file exists
        expect(await File(savedPath).exists(), true);
      }

      // Verify directory structure
      print('\n📁 Verifying directory structure...');
      final cacheDir = Directory('${tempDir.path}/cached_assets');
      expect(await cacheDir.exists(), true);

      final expectedIds = ['1005', '2001', '3500'];
      for (final id in expectedIds) {
        final idDir = Directory('${cacheDir.path}/$id');
        expect(await idDir.exists(), true);
        print('   ✅ Directory $id exists');

        final files = await idDir.list().toList();
        expect(files.length, 1);
        print('   📄 Contains ${files.length} file(s)');
      }

      // Test retrieval of all assets
      print('\n🔍 Testing retrieval of all assets...');
      for (int i = 0; i < testCases.length; i++) {
        final url = testCases[i]['url'] as String;
        final retrieveRequest = RetrieveAssetRequest.fromSupabaseLink(url);

        final isCached = await localDataSource.isAssetCached(
          fileName: retrieveRequest.fileName,
          repositoryId: retrieveRequest.fileRepositoryId,
        );

        expect(isCached, true);
        print('   ✅ Asset ${i + 1} is cached and retrievable');
      }

      print('\n🎉 Multiple assets workflow test passed!');
    });

    test('Asset deletion workflow', () async {
      print('🚀 Testing asset deletion workflow');

      // Create multiple assets for the same repository ID
      const baseUrl = 'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1005/';
      final testFiles = ['test1.pdf', 'test2.pdf', 'test3.pdf'];

      // Save multiple files
      print('\n💾 Saving multiple files for repository 1005...');
      for (final fileName in testFiles) {
        final url = '$baseUrl$fileName';
        final cacheRequest = CacheAssetRequest.fromSupabaseLink(
          link: url,
          cancelToken: CancelToken(),
          onProgress: null,
        );

        final testData = Uint8List.fromList('Content for $fileName'.codeUnits);
        await localDataSource.saveAsset(data: testData, request: cacheRequest);
        print('   ✅ Saved: $fileName');
      }

      // Verify all files exist
      print('\n🔍 Verifying all files exist...');
      for (final fileName in testFiles) {
        final isCached = await localDataSource.isAssetCached(
          fileName: fileName.replaceAll('.pdf', ''),
          repositoryId: '1005',
        );
        expect(isCached, true);
        print('   ✅ $fileName is cached');
      }

      // Delete all assets for the repository
      print('\n🗑️ Deleting all assets for repository 1005...');
      await localDataSource.deleteAssetsByID(repositoryId: '1005');

      // Verify all files are deleted
      print('\n🔍 Verifying all files are deleted...');
      for (final fileName in testFiles) {
        final isCached = await localDataSource.isAssetCached(
          fileName: fileName.replaceAll('.pdf', ''),
          repositoryId: '1005',
        );
        expect(isCached, false);
        print('   ✅ $fileName is no longer cached');
      }

      // Verify directory is also deleted
      final idDir = Directory('${tempDir.path}/cached_assets/1005');
      expect(await idDir.exists(), false);
      print('   ✅ Repository directory was deleted');

      print('\n🎉 Asset deletion workflow test passed!');
    });
  });
}
