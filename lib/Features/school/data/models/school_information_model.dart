import 'package:moatmat_app/Features/school/domain/entities/school_information.dart';

class SchoolInformationModel extends SchoolInformation {
  SchoolInformationModel({
    required super.name,
    required super.description
  });

  factory SchoolInformationModel.fromClass(SchoolInformation schoolInfo) {
    return SchoolInformationModel(
      name: schoolInfo.name,
      description: schoolInfo.description,
    );
  }

  factory SchoolInformationModel.fromJson(Map<String, dynamic> json) {
    return SchoolInformationModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}