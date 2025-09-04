import 'package:equatable/equatable.dart';

class CachedAsset extends Equatable {
  final String originalUrl;
  final String localPath;
  final String fileType;
  final DateTime cachedAt;
  final int fileSize;

  const CachedAsset({
    required this.originalUrl,
    required this.localPath,
    required this.fileType,
    required this.cachedAt,
    required this.fileSize,
  });

  CachedAsset copyWith({
    String? originalUrl,
    String? localPath,
    String? fileType,
    DateTime? cachedAt,
    int? fileSize,
  }) {
    return CachedAsset(
      originalUrl: originalUrl ?? this.originalUrl,
      localPath: localPath ?? this.localPath,
      fileType: fileType ?? this.fileType,
      cachedAt: cachedAt ?? this.cachedAt,
      fileSize: fileSize ?? this.fileSize,
    );
  }

  @override
  List<Object?> get props => [
        originalUrl,
        localPath,
        fileType,
        cachedAt,
        fileSize,
      ];
}