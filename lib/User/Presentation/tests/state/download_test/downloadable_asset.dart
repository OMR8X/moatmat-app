import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

enum AssetType {
  video,
  image,
  file,
}

enum DownloadState {
  pending,
  downloading,
  completed,
  failed,
}

class DownloadableAsset extends Equatable {
  final String url;
  final AssetType type;
  final DownloadState state;
  final double progress; // 0.0 to 100.0
  final String? errorMessage;
  final CancelToken cancelToken;

  const DownloadableAsset({
    required this.url,
    required this.type,
    this.state = DownloadState.pending,
    this.progress = 0.0,
    this.errorMessage,
    required this.cancelToken,
  });

  DownloadableAsset copyWith({
    String? url,
    AssetType? type,
    DownloadState? state,
    double? progress,
    String? errorMessage,
    CancelToken? cancelToken,
  }) {
    return DownloadableAsset(
      url: url ?? this.url,
      type: type ?? this.type,
      state: state ?? this.state,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      cancelToken: cancelToken ?? this.cancelToken,
    );
  }

  @override
  String toString() {
    return 'DownloadableAsset(url: $url, type: $type, state: $state, progress: $progress)';
  }

  @override
  List<Object?> get props => [url, type, state, progress, errorMessage, cancelToken];
}
