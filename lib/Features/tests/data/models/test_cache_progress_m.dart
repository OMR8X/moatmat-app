enum CacheProgressStatus {
  initializing,
  downloading,
  processing,
  completed,
  failed,
}

class TestCacheProgressModel {
  final int testId;
  final int totalAssets;
  final int downloadedAssets;
  final String currentAssetName;
  final double progressPercentage;
  final CacheProgressStatus status;
  final String? errorMessage;

  TestCacheProgressModel({
    required this.testId,
    required this.totalAssets,
    required this.downloadedAssets,
    required this.currentAssetName,
    required this.progressPercentage,
    required this.status,
    this.errorMessage,
  });

  factory TestCacheProgressModel.fromJson(Map<String, dynamic> json) {
    return TestCacheProgressModel(
      testId: json['testId'],
      totalAssets: json['totalAssets'],
      downloadedAssets: json['downloadedAssets'],
      currentAssetName: json['currentAssetName'],
      progressPercentage: json['progressPercentage'].toDouble(),
      status: CacheProgressStatus.values[json['status']],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testId': testId,
      'totalAssets': totalAssets,
      'downloadedAssets': downloadedAssets,
      'currentAssetName': currentAssetName,
      'progressPercentage': progressPercentage,
      'status': status.index,
      'errorMessage': errorMessage,
    };
  }

  TestCacheProgressModel copyWith({
    int? testId,
    int? totalAssets,
    int? downloadedAssets,
    String? currentAssetName,
    double? progressPercentage,
    CacheProgressStatus? status,
    String? errorMessage,
  }) {
    return TestCacheProgressModel(
      testId: testId ?? this.testId,
      totalAssets: totalAssets ?? this.totalAssets,
      downloadedAssets: downloadedAssets ?? this.downloadedAssets,
      currentAssetName: currentAssetName ?? this.currentAssetName,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  static TestCacheProgressModel initializing(int testId) {
    return TestCacheProgressModel(
      testId: testId,
      totalAssets: 0,
      downloadedAssets: 0,
      currentAssetName: 'Initializing...',
      progressPercentage: 0.0,
      status: CacheProgressStatus.initializing,
    );
  }

  static TestCacheProgressModel completed(int testId, int totalAssets) {
    return TestCacheProgressModel(
      testId: testId,
      totalAssets: totalAssets,
      downloadedAssets: totalAssets,
      currentAssetName: 'Completed',
      progressPercentage: 100.0,
      status: CacheProgressStatus.completed,
    );
  }

  static TestCacheProgressModel failed(int testId, String errorMessage) {
    return TestCacheProgressModel(
      testId: testId,
      totalAssets: 0,
      downloadedAssets: 0,
      currentAssetName: 'Failed',
      progressPercentage: 0.0,
      status: CacheProgressStatus.failed,
      errorMessage: errorMessage,
    );
  }
}
