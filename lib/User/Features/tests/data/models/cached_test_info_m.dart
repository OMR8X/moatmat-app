class CachedTestInfoModel {
  final int testId;
  final String title;
  final DateTime cachedAt;
  final int sizeInBytes;
  final int questionCount;
  final int assetCount;
  final bool isValid;
  final String teacher;
  final String material;
  final String classs;

  CachedTestInfoModel({
    required this.testId,
    required this.title,
    required this.cachedAt,
    required this.sizeInBytes,
    required this.questionCount,
    required this.assetCount,
    required this.isValid,
    required this.teacher,
    required this.material,
    required this.classs,
  });

  factory CachedTestInfoModel.fromJson(Map<String, dynamic> json) {
    return CachedTestInfoModel(
      testId: json['testId'],
      title: json['title'],
      cachedAt: DateTime.parse(json['cachedAt']),
      sizeInBytes: json['sizeInBytes'],
      questionCount: json['questionCount'],
      assetCount: json['assetCount'],
      isValid: json['isValid'],
      teacher: json['teacher'],
      material: json['material'],
      classs: json['classs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testId': testId,
      'title': title,
      'cachedAt': cachedAt.toIso8601String(),
      'sizeInBytes': sizeInBytes,
      'questionCount': questionCount,
      'assetCount': assetCount,
      'isValid': isValid,
      'teacher': teacher,
      'material': material,
      'classs': classs,
    };
  }

  CachedTestInfoModel copyWith({
    int? testId,
    String? title,
    DateTime? cachedAt,
    int? sizeInBytes,
    int? questionCount,
    int? assetCount,
    bool? isValid,
    String? teacher,
    String? material,
    String? classs,
  }) {
    return CachedTestInfoModel(
      testId: testId ?? this.testId,
      title: title ?? this.title,
      cachedAt: cachedAt ?? this.cachedAt,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      questionCount: questionCount ?? this.questionCount,
      assetCount: assetCount ?? this.assetCount,
      isValid: isValid ?? this.isValid,
      teacher: teacher ?? this.teacher,
      material: material ?? this.material,
      classs: classs ?? this.classs,
    );
  }
}
