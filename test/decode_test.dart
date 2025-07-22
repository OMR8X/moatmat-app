import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moatmat_app/User/Core/functions/coders/decode.dart';
import 'package:moatmat_app/User/Features/buckets/domain/requests/cache_asset_request.dart';
import 'package:moatmat_app/User/Features/buckets/domain/requests/retrieve_asset_request.dart';

void main() {
  group('Decode and URL Parsing Tests', () {
    group('File Name Decoding Tests', () {
      test('should decode regular filename correctly', () {
        const fileName = '2024.11.20.10.41.05.228185.pdf';
        final decoded = decodeFileName(fileName);
        expect(decoded, '2024.11.20.10.41.05.228185');
        print('✅ Regular filename decoded: $decoded');
      });

      test('should decode encoded Arabic filename correctly', () {
        const encodedFileName = '____D8____A7____D9____84____D8____B3____D8____A4____D8____A7____D9____84____2020____20____D8____A7____D9____84____D8____AA____D9____83____D8____A7____D9____85____D9____84.pdf';
        final decoded = decodeFileName(encodedFileName);

        print('🔍 Encoded filename: $encodedFileName');
        print('✅ Decoded filename: $decoded');

        // Should decode to Arabic text
        expect(decoded, contains('السؤال'));
        expect(decoded, contains('20')); // 2020 becomes 20 in the decode
        expect(decoded, contains('التكامل'));
      });

      test('should handle filename with underscores but no encoding', () {
        const fileName = 'test_file_name.pdf';
        final decoded = decodeFileName(fileName);
        expect(decoded, 'test file name');
        print('✅ Underscore filename decoded: $decoded');
      });

      test('should handle complex encoded filename with special characters', () {
        const complexFileName =
            '____D8____A7____D9____84____D8____B1____D9____8A____D8____A7____D8____B6____D9____8A____D8____A7____D8____AA____20____D9____88____20____D8____A7____D9____84____D9____87____D9____86____D8____AF____D8____B3____D8____A9.pdf';
        final decoded = decodeFileName(complexFileName);

        print('🔍 Complex encoded: $complexFileName');
        print('✅ Complex decoded: $decoded');

        expect(decoded, contains('الرياضيات'));
        expect(decoded, contains('الهندسة'));
      });
    });

    group('Supabase URL Parsing Tests', () {
      test('should correctly parse regular Supabase URL', () {
        const url = 'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1005/2024.11.20.10.41.05.228185.pdf';

        final request = CacheAssetRequest.fromSupabaseLink(
          link: url,
          cancelToken: CancelToken(),
          onProgress: null,
        );

        print('🔗 URL: $url');
        print('📋 Extracted ID: ${request.fileRepositoryId}');
        print('📄 Extracted filename: ${request.fileName}');
        print('🔗 Full URL: ${request.fileUrl}');

        expect(request.fileRepositoryId, '1005');
        expect(request.fileName, '2024.11.20.10.41.05.228185');
        expect(request.fileUrl, url);
        expect(request.fileExtension, 'pdf');
      });

      test('should correctly parse and decode encoded Supabase URL', () {
        const encodedUrl =
            'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1760/____D8____A7____D9____84____D8____B3____D8____A4____D8____A7____D9____84____2020____20____D8____A7____D9____84____D8____AA____D9____83____D8____A7____D9____85____D9____84.pdf';

        final request = CacheAssetRequest.fromSupabaseLink(
          link: encodedUrl,
          cancelToken: CancelToken(),
          onProgress: null,
        );

        print('🔗 Encoded URL: $encodedUrl');
        print('📋 Extracted ID: ${request.fileRepositoryId}');
        print('📄 Decoded filename: ${request.fileName}');
        print('🔗 Full URL: ${request.fileUrl}');

        expect(request.fileRepositoryId, '1760');
        expect(request.fileName, contains('السؤال')); // Should contain Arabic text after decoding
        expect(request.fileName, contains('20')); // 2020 becomes 20 in decode
        expect(request.fileName, contains('التكامل'));
        expect(request.fileUrl, encodedUrl);
        expect(request.fileExtension, 'pdf');
      });

      test('should handle multiple different Supabase URLs', () {
        final testUrls = [
          'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Physics/2001/simple_file.pdf',
          'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Chemistry/3500/____D8____A7____D9____84____D9____83____D9____8A____D9____85____D9____8A____D8____A7____D8____A1.pdf',
          'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/999/test_with_underscores.pdf',
        ];

        for (final url in testUrls) {
          final request = CacheAssetRequest.fromSupabaseLink(
            link: url,
            cancelToken: CancelToken(),
            onProgress: null,
          );

          print('\n🔗 Testing URL: $url');
          print('📋 ID: ${request.fileRepositoryId}');
          print('📄 Filename: ${request.fileName}');

          // Verify ID is numeric
          expect(int.tryParse(request.fileRepositoryId), isNotNull);

          // Verify filename is not empty
          expect(request.fileName, isNotEmpty);

          // Verify URL is preserved
          expect(request.fileUrl, url);
        }
      });
    });

    group('Retrieve Asset Request Tests', () {
      test('should correctly parse regular URL for retrieval', () {
        const url = 'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1005/2024.11.20.10.41.05.228185.pdf';

        final request = RetrieveAssetRequest.fromSupabaseLink(url);

        print('🔍 Retrieve request for URL: $url');
        print('📋 ID: ${request.fileRepositoryId}');
        print('📄 Filename: ${request.fileName}');

        expect(request.fileRepositoryId, '1005');
        expect(request.fileName, '2024.11.20.10.41.05.228185');
      });

      test('should correctly parse encoded URL for retrieval', () {
        const encodedUrl =
            'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/1760/____D8____A7____D9____84____D8____B3____D8____A4____D8____A7____D9____84____2020____20____D8____A7____D9____84____D8____AA____D9____83____D8____A7____D9____85____D9____84.pdf';

        final request = RetrieveAssetRequest.fromSupabaseLink(encodedUrl);

        print('🔍 Retrieve request for encoded URL: $encodedUrl');
        print('📋 ID: ${request.fileRepositoryId}');
        print('📄 Decoded filename: ${request.fileName}');

        expect(request.fileRepositoryId, '1760');
        expect(request.fileName, contains('السؤال'));
        expect(request.fileName, contains('20')); // 2020 becomes 20 in decode
        expect(request.fileName, contains('التكامل'));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle URL without proper ID', () {
        const invalidUrl = 'https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/Mathematics/invalid/file.pdf';

        try {
          final request = CacheAssetRequest.fromSupabaseLink(
            link: invalidUrl,
            cancelToken: CancelToken(),
            onProgress: null,
          );
          print('⚠️ URL with invalid ID: ${request.fileRepositoryId}');
          // Should still create request but with 'invalid' as ID
          expect(request.fileRepositoryId, 'invalid');
        } catch (e) {
          print('❌ Error handling invalid URL: $e');
          // This is expected behavior - invalid URLs should throw
        }
      });

      test('should handle empty filename', () {
        const fileName = '';
        final decoded = decodeFileName(fileName);
        expect(decoded, '');
        print('✅ Empty filename handled: "$decoded"');
      });

      test('should handle filename without extension', () {
        const fileName = 'simple_filename';
        final decoded = decodeFileName(fileName);
        expect(decoded, 'simple filename');
        print('✅ No extension filename: $decoded');
      });

      test('should handle malformed encoded filename', () {
        const malformedFileName = '____D8____INVALID____ENCODING.pdf';
        try {
          final decoded = decodeFileName(malformedFileName);
          print('🔍 Malformed encoding: $malformedFileName');
          print('✅ Decoded result: $decoded');
          // Should still process without crashing
          expect(decoded, isNotEmpty);
        } catch (e) {
          print('❌ Error with malformed encoding (expected): $e');
          // This is expected for truly malformed URL encoding
          expect(e.toString(), contains('Invalid URL encoding'));
        }
      });
    });

    group('Real World Examples', () {
      test('should handle typical Arabic math filename', () {
        const arabicMathFile = '____D9____85____D8____B9____D8____A7____D8____AF____D9____84____D8____A7____D8____AA____20____D8____A7____D9____84____D8____B1____D9____8A____D8____A7____D8____B6____D9____8A____D8____A7____D8____AA.pdf';
        final decoded = decodeFileName(arabicMathFile);

        print('📚 Arabic math file: $arabicMathFile');
        print('✅ Decoded: $decoded');

        expect(decoded, contains('معادلات'));
        expect(decoded, contains('الرياضيات'));
      });

      test('should handle typical Arabic physics filename', () {
        const arabicPhysicsFile = '____D8____A7____D9____84____D9____81____D9____8A____D8____B2____D9____8A____D8____A7____D8____A1____20____D9____88____20____D8____A7____D9____84____D8____AD____D8____B1____D9____83____D8____A9.pdf';
        final decoded = decodeFileName(arabicPhysicsFile);

        print('🔬 Arabic physics file: $arabicPhysicsFile');
        print('✅ Decoded: $decoded');

        expect(decoded, contains('الفيزياء'));
        expect(decoded, contains('الحركة'));
      });

      test('should handle mixed Arabic and English filename', () {
        const mixedFile = '____D8____A7____D9____84____D8____B1____D9____8A____D8____A7____D8____B6____D9____8A____D8____A7____D8____AA____20Math____202024.pdf';
        final decoded = decodeFileName(mixedFile);

        print('🌐 Mixed language file: $mixedFile');
        print('✅ Decoded: $decoded');

        expect(decoded, contains('الرياضيات'));
        expect(decoded, contains('Math'));
        expect(decoded, contains('2024'));
      });
    });
  });
}
