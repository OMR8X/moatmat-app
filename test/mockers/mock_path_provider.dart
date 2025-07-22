import 'dart:io';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class MockPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return (Directory.systemTemp.createTempSync()).path;
  }
}

mockPathProviderPlatform() {
  PathProviderPlatform.instance = MockPathProviderPlatform();
}
