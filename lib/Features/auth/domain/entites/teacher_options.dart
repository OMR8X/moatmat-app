class TeacherOptions {
  final bool allowInsert;
  final bool allowUpdate;
  final bool allowDelete;
  final bool allowScanning;
  final bool? isTeacher;
  final bool? isUploader;
  final bool? isAdmin;

  TeacherOptions({
    required this.allowInsert,
    required this.allowUpdate,
    required this.allowDelete,
    required this.allowScanning,
    this.isTeacher,
    this.isUploader,
    this.isAdmin,
  });
  TeacherOptions copyWith({
    bool? allowInsert,
    bool? allowUpdate,
    bool? allowDelete,
    bool? allowScanning,
    bool? isTeacher,
    bool? isUploader,
    bool? isAdmin,
  }) {
    return TeacherOptions(
      allowInsert: allowInsert ?? this.allowInsert,
      allowUpdate: allowUpdate ?? this.allowUpdate,
      allowDelete: allowDelete ?? this.allowDelete,
      allowScanning: allowScanning ?? this.allowScanning,
      isAdmin: isAdmin ?? this.isAdmin,
      isTeacher: isTeacher ?? this.isTeacher,
      isUploader: isUploader ?? this.isUploader,
    );
  }
}
