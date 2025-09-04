import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'media links in lib/User/media_list.json are reachable',
    () async {
      final file = File('lib/User/media_list.json');
      final content = await file.readAsString();
      final dynamic jsonData = json.decode(content);
      print('Starting validation: total items = ${(jsonData as List).length}');
      expect(jsonData is List, isTrue);

      final items = List<Map<String, dynamic>>.from(jsonData);
      final List<Map<String, dynamic>> remainingItems = List<Map<String, dynamic>>.from(jsonData);
      final List<Map<String, dynamic>> broken = [];
      final List<Map<String, dynamic>> working = [];
      int currentIndex = 0;
      final totalItems = items.length;
      final String brokenFilePath = 'test/broken_media_links.json';
      final String workingFilePath = 'test/working_media_links.json';

      // Create or clear the result files
      await File(brokenFilePath).writeAsString('[]');
      await File(workingFilePath).writeAsString('[]');

      // Function to update result files
      Future<void> updateResultFiles() async {
        await File(brokenFilePath).writeAsString(jsonEncode(broken));
        await File(workingFilePath).writeAsString(jsonEncode(working));
      }

      // Function to update original file with remaining items
      Future<void> updateOriginalFile() async {
        await file.writeAsString(jsonEncode(remainingItems));
        print('Updated original file. Remaining items: ${remainingItems.length}');
      }

      // Process items and remove them from the original list
      while (items.isNotEmpty) {
        final item = items.removeAt(0);
        // Remove the processed item from remaining items
        remainingItems.removeWhere((element) => element['id'] == item['id']);
        currentIndex++;
        print('Processing item: ${item['id'] ?? 'unknown'}');

        String? url;
        // Data always has prefixed_name containing the URL
        if (item.containsKey('prefixed_name') && item['prefixed_name'] != null) {
          url = item['prefixed_name'] as String?;
          print('Item ${item['id']}: found prefixed_name URL');
        }

        if (url == null) {
          broken.add({'id': item['id'], 'reason': 'no_url_found'});
          print('Item ${item['id']}: no URL found.');
          await updateResultFiles();
          await updateOriginalFile();
          print('Progress: $currentIndex/$totalItems (${(currentIndex / totalItems * 100).toStringAsFixed(1)}%)');
          continue;
        }

        final uri = Uri.parse(url);
        final HttpClient client = HttpClient();
        try {
          print('Item ${item['id']}: checking URL: $url');
          final HttpClientRequest request = await client.headUrl(uri);
          final HttpClientResponse response = await request.close().timeout(Duration(seconds: 15));
          final status = response.statusCode;
          print('Item ${item['id']}: response status = $status');

          if (status < 200 || status >= 400) {
            broken.add({'id': item['id'], 'url': url, 'status': status});
            await updateResultFiles();
          } else {
            working.add({'id': item['id'], 'url': url, 'status': status});
            await updateResultFiles();
          }
        } catch (e) {
          broken.add({'id': item['id'], 'url': url, 'error': e.toString()});
          print('Item ${item['id']}: error validating URL: $e');
          await updateResultFiles();
        } finally {
          client.close();
        }

        // Update the original file with remaining items
        await updateOriginalFile();

        print('Progress: $currentIndex/$totalItems (${(currentIndex / totalItems * 100).toStringAsFixed(1)}%)');
      }

      print('Final results:');
      print('Broken media links count: ${broken.length}');
      print('Working media links count: ${working.length}');

      for (final b in broken) {
        print('BROKEN: $b');
      }

      expect(broken.isEmpty, isTrue, reason: 'There are broken media links: $broken');
    },
    timeout: Timeout(Duration(hours: 10)),
  );
}
// https://kckjiyqmxbrhsrbdlujw.supabase.co/storage/v1/object/public/tests/History/372/2024.06.27.01.19.56.261276.jpg
