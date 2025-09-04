import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:moatmat_app/Core/services/api/api_manager.dart';
import 'package:moatmat_app/Features/buckets/domain/requests/cache_asset_request.dart';

import '../../../../Core/errors/exceptions.dart';

abstract class RemoteAssetDataSource {
  /// Download asset from URL
  Future<Uint8List> downloadAsset({required CacheAssetRequest request});

  /// Get file size (content length) from URL
  Future<int> getFileSize({required String fileUrl});
}

class RemoteAssetDataSourceImpl implements RemoteAssetDataSource {
  final ApiManager manager;

  RemoteAssetDataSourceImpl({required this.manager});

  @override
  Future<Uint8List> downloadAsset({required CacheAssetRequest request}) async {
    debugPrint("error ${request.fileUrl}");
    try {
      final uri = Uri.tryParse(request.fileUrl);
      if (uri == null || !uri.hasScheme || (!uri.isScheme('http') && !uri.isScheme('https'))) {
        throw AssetInvalidUrlException();
      }

      final response = await manager().get(
        request.fileUrl,
        responseType: ResponseType.stream,
        cancelToken: request.cancelToken,
      );

      if (response.statusCode != 200) {
        if ([404, 403, 401, 400].contains(response.statusCode)) throw AssetNotExistsException();
        throw AssetDownloadException();
      }

      final stream = response.data.stream;
      final contentLength = response.data.contentLength ?? 0;

      final bytesBuilder = BytesBuilder();
      int received = 0;

      await for (final chunk in stream) {
        received += chunk.length as int;
        bytesBuilder.add(chunk);
        if (contentLength > 0) {
          request.onProgress?.call(received, contentLength);
        }
      }
      final bytes = bytesBuilder.toBytes();
      return bytes;
    } on AssetNotExistsException {
      debugPrint("failure not found");
      rethrow;
    } catch (e) {
      debugPrint("failure $e");
      throw AssetDownloadException();
    }
  }

  @override
  Future<int> getFileSize({required String fileUrl}) async {
    try {
      final uri = Uri.tryParse(fileUrl);
      if (uri == null || !uri.hasScheme || (!uri.isScheme('http') && !uri.isScheme('https'))) {
        throw AssetInvalidUrlException();
      }

      final response = await manager().head(
        fileUrl,
      );

      if (response.statusCode != 200) {
        if ([404, 403, 401, 400].contains(response.statusCode)) throw AssetNotExistsException();
        throw AssetDownloadException();
      }

      final contentLength = response.headers.value('content-length');
      return contentLength != null ? int.parse(contentLength) : 0;
    } on AssetNotExistsException {
      debugPrint("failure not found");
      rethrow;
    } catch (e) {
      debugPrint("failure getting file size: $e");
      throw AssetDownloadException();
    }
  }
}
