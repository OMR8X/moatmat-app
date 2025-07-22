import 'package:dio/dio.dart';

import '../../../../Core/functions/coders/decode.dart';

class CacheAssetRequest {
  final String fileUrl;
  final String fileName;
  final String fileRepositoryId;
  final CancelToken cancelToken;
  final Function(int received, int total)? onProgress;

  CacheAssetRequest({
    required this.fileRepositoryId,
    required this.fileName,
    required this.fileUrl,
    required this.cancelToken,
    required this.onProgress,
  });

  factory CacheAssetRequest.fromSupabaseLink({
    required String link,
    required CancelToken cancelToken,
    required void Function(int, int)? onProgress,
  }) {
    final fileRepositoryId = link.split("/").firstWhere((e) => int.tryParse(e) != null);
    final originalFileName = link.split("/").last;
    final fileName = decodeFileNameKeepExtension(originalFileName);
    return CacheAssetRequest(
      fileRepositoryId: fileRepositoryId,
      fileName: fileName,
      fileUrl: link,
      cancelToken: cancelToken,
      onProgress: onProgress,
    );
  }

  String get fileExtension => fileUrl.split("/").last.split('.').last;
}
