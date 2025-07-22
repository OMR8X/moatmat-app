import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<File> mockFile() async {
  // Create fake file in memory for testing
  final Uint8List fakeFileData = Uint8List.fromList([0, 1, 2, 3, 4, 5]); // Mocked file data
  const String fileName = 'fake_file2.pdf';
  // Get temporary directory path
  final Directory tempDir = await getApplicationDocumentsDirectory();
  return await File('${tempDir.path}/$fileName').writeAsBytes(fakeFileData);
}
