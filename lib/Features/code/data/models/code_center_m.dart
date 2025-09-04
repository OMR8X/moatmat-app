import '../../domain/entites/code_center.dart';

class CodeCenterModel extends CodeCenter {
  CodeCenterModel(
      {required super.id,
      required super.name,
      required super.description,
      required super.governorate,
      required super.phone,
      required super.icon});

  factory CodeCenterModel.fromJson(Map<String, dynamic> json) {
    return CodeCenterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      governorate: json['governorate'] as String? ?? "",
      phone: json['phone'] as String,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'governorate': governorate,
      'phone': phone,
      'icon': icon,
    };
  }
}
