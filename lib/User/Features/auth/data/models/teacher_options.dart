
import '../../domain/entites/teacher_options.dart';

class TeacherOptionsModel extends TeacherOptions {
  TeacherOptionsModel({
    required super.allowInsert,
    required super.allowUpdate,
    required super.allowDelete,
  });
  //
  factory TeacherOptionsModel.fromJson(Map json) {
    return TeacherOptionsModel(
      allowInsert: json["allow_insert"] ?? false,
      allowUpdate: json["allow_update"] ?? false,
      allowDelete: json["allow_delete"] ?? false,
    );
  }
  factory TeacherOptionsModel.fromClass(TeacherOptions options) {
    return TeacherOptionsModel(
      allowInsert: options.allowDelete,
      allowUpdate: options.allowUpdate,
      allowDelete: options.allowDelete,
    );
  }
  toJson() {
    return {
      "allow_insert": allowInsert,
      "allow_update": allowUpdate,
      "allow_delete": allowDelete,
    };
  }
}
