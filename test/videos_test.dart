import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  group('Video URL Validation Tests', () {
    test('Check which video URLs are not working', () async {
      // Read the JSON file
      final file = File('test/videos-list.json');
      final jsonString = await file.readAsString();
      final List<dynamic> videosList = jsonDecode(jsonString);

      print('Starting URL validation for ${videosList.length} videos...\n');

      List<Map<String, dynamic>> failedUrls = [];
      List<Map<String, dynamic>> successfulUrls = [];
      int processedCount = 0;

      for (final video in videosList) {
        processedCount++;
        final String url = video['video_url'] ?? '';
        final int testId = video['test_id'] ?? 0;
        final String testTitle = video['test_title'] ?? 'No Title';
        final int videoId = video['video_id'] ?? 0;

        if (url.isEmpty) {
          failedUrls.add({
            'video_id': videoId,
            'test_id': testId,
            'test_title': testTitle,
            'url': url,
            'error': 'Empty URL',
            'status_code': null,
          });
          continue;
        }

        try {
          print('Checking URL $processedCount/${videosList.length}: Video ID $videoId');

          // Create a HEAD request with timeout to check if URL exists
          final response = await http.head(
            Uri.parse(url),
            headers: {
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            },
          ).timeout(const Duration(seconds: 10));

          if (response.statusCode >= 200 && response.statusCode < 400) {
            successfulUrls.add({
              'video_id': videoId,
              'test_id': testId,
              'test_title': testTitle,
              'status_code': response.statusCode,
            });
          } else {
            failedUrls.add({
              'video_id': videoId,
              'test_id': testId,
              'test_title': testTitle,
              'url': url,
              'error': 'HTTP Error',
              'status_code': response.statusCode,
            });
          }
        } catch (e) {
          failedUrls.add({
            'video_id': videoId,
            'test_id': testId,
            'test_title': testTitle,
            'url': url,
            'error': e.toString(),
            'status_code': null,
          });
        }

        // Add a small delay to avoid overwhelming the server
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Print results
      print('\n${'=' * 80}');
      print('VIDEO URL VALIDATION RESULTS');
      print('=' * 80);
      print('Total videos checked: ${videosList.length}');
      print('Successful URLs: ${successfulUrls.length}');
      print('Failed URLs: ${failedUrls.length}');
      print('Success rate: ${((successfulUrls.length / videosList.length) * 100).toStringAsFixed(1)}%');

      if (failedUrls.isNotEmpty) {
        print('\n${'-' * 80}');
        print('FAILED URLS DETAILS:');
        print('-' * 80);

        for (int i = 0; i < failedUrls.length; i++) {
          final failed = failedUrls[i];
          print('\n${i + 1}. VIDEO ID: ${failed['video_id']}');
          print('   TEST ID: ${failed['test_id']}');
          print('   TEST TITLE: ${failed['test_title']}');
          print('   ERROR: ${failed['error']}');
          if (failed['status_code'] != null) {
            print('   STATUS CODE: ${failed['status_code']}');
          }
          if (failed['url'].toString().isNotEmpty) {
            print('   URL: ${failed['url']}');
          }
        }

        // Generate a summary report file
        final reportFile = File('test/video-url-report.json');
        final report = {
          'timestamp': DateTime.now().toIso8601String(),
          'total_videos': videosList.length,
          'successful_count': successfulUrls.length,
          'failed_count': failedUrls.length,
          'success_rate': (successfulUrls.length / videosList.length) * 100,
          'failed_urls': failedUrls,
        };

        await reportFile.writeAsString(const JsonEncoder.withIndent('  ').convert(report));
        print('\n${'-' * 80}');
        print('Detailed report saved to: test/video-url-report.json');
      }

      // The test will fail if there are any failed URLs to bring attention to the issues
      if (failedUrls.isNotEmpty) {
        fail('Found ${failedUrls.length} non-working video URLs. Check the console output and test/video-url-report.json for details.');
      }
    }, timeout: const Timeout(Duration(hours: 5)));

    test('Generate summary of failed URLs by error type', () async {
      final reportFile = File('test/video-url-report.json');

      if (!await reportFile.exists()) {
        print('No report file found. Run the main URL validation test first.');
        return;
      }

      final reportString = await reportFile.readAsString();
      final Map<String, dynamic> report = jsonDecode(reportString);
      final List<dynamic> failedUrls = report['failed_urls'] ?? [];

      if (failedUrls.isEmpty) {
        print('No failed URLs found in the report.');
        return;
      }

      // Group failures by error type
      Map<String, List<Map<String, dynamic>>> errorGroups = {};
      for (final failed in failedUrls) {
        final String error = failed['error'] ?? 'Unknown Error';
        errorGroups.putIfAbsent(error, () => []);
        errorGroups[error]!.add(failed);
      }

      print('\n${'=' * 80}');
      print('FAILED URLS SUMMARY BY ERROR TYPE');
      print('=' * 80);

      for (final errorType in errorGroups.keys) {
        final count = errorGroups[errorType]!.length;
        print('\n$errorType: $count failures');
        print('-' * 40);

        for (final failed in errorGroups[errorType]!) {
          print('  • Test ID: ${failed['test_id']} | Video ID: ${failed['video_id']}');
          print('    Title: ${failed['test_title']}');
          if (failed['status_code'] != null) {
            print('    Status: ${failed['status_code']}');
          }
        }
      }
    }, timeout: const Timeout(Duration(hours: 5)));
  });
}
