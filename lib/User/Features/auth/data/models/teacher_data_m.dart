import '../../domain/entites/teacher_data.dart';
import '../../domain/entites/teacher_options.dart';
import 'teacher_options.dart';

class TeacherDataModel extends TeacherData {
  TeacherDataModel({
    required super.name,
    required super.purchaseDescription,
    required super.email,
    required super.image,
    required super.description,
    required super.options,
    required super.price,
  });
  factory TeacherDataModel.fromJson(Map json) {
    return TeacherDataModel(
      name: json["name"],
      email: json["email"],
      description: json["description"],
      purchaseDescription: json["purchase_description"],
      image: json["image"],
      price: json["price"],
      options: json["teacher_options"] != null
          ? TeacherOptionsModel.fromJson(
              json["teacher_options"],
            )
          : TeacherOptions(
              allowInsert: false,
              allowUpdate: false,
              allowDelete: false,
            ),
    );
  }
  factory TeacherDataModel.fromClass(TeacherData teacherData) {
    return TeacherDataModel(
      name: teacherData.name,
      email: teacherData.email,
      description: teacherData.description,
      image: teacherData.image,
      purchaseDescription: teacherData.purchaseDescription,
      options: teacherData.options,
      price: teacherData.price,
    );
  }

  toJson() {
    return {
      "name": name.trim(),
      "email": email.trim(),
      "price": price,
      "purchase_description": purchaseDescription,
      "teacher_options": TeacherOptionsModel.fromClass(options).toJson(),
    };
  }
}
