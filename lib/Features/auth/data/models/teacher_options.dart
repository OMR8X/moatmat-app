import '../../domain/entites/teacher_options.dart';

class TeacherOptionsModel extends TeacherOptions {
  TeacherOptionsModel({
    required super.allowInsert,
    required super.allowUpdate,
    required super.allowDelete,
    required super.allowScanning,
    super.isAdmin,
    super.isTeacher,
    super.isUploader,
  });
  //
  factory TeacherOptionsModel.fromJson(Map json) {
    return TeacherOptionsModel(
      allowInsert: json["allow_insert"] ?? false,
      allowUpdate: json["allow_update"] ?? false,
      allowDelete: json["allow_delete"] ?? false,
      allowScanning: json["allow_scanning"] ?? false,
      isAdmin: json["is_admin"] ?? false,
      isTeacher: json["is_teacher"] ?? false,
      isUploader: json["is_uploader"] ?? false,
    );
  }
  factory TeacherOptionsModel.fromClass(TeacherOptions options) {
    return TeacherOptionsModel(
      allowInsert: options.allowInsert,
      allowUpdate: options.allowUpdate,
      allowDelete: options.allowDelete,
      allowScanning: options.allowScanning,
      isAdmin: options.isAdmin,
      isTeacher: options.isTeacher,
      isUploader: options.isUploader,
    );
  }
  toJson() {
    return {
      "allow_insert": allowInsert,
      "allow_update": allowUpdate,
      "allow_delete": allowDelete,
      "allow_scanning": allowScanning,
      "is_admin": isAdmin,
      "is_teacher": isTeacher,
      "is_uploader": isUploader,
    };
  }
}
