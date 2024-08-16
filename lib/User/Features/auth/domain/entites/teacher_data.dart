import 'teacher_options.dart';

class TeacherData {
  final String name;
  final String email;
  final TeacherOptions options;
  //
  final String? description;
  final String purchaseDescription;
  final String? image;
  //
  final int price;

  TeacherData({
    required this.name,
    required this.email,
    required this.options,
    required this.description,
    required this.image,
    required this.price,
    required this.purchaseDescription,
  });

  TeacherData copyWith({
    String? name,
    String? email,
    TeacherOptions? options,
    String? description,
    String? purchaseDescription,
    String? image,
    int? price,
  }) {
    return TeacherData(
      name: name ?? this.name,
      email: email ?? this.email,
      options: options ?? this.options,
      description: description ?? this.description,
      purchaseDescription: purchaseDescription ?? this.purchaseDescription,
      image: image ?? this.image,
      price: price ?? this.price,
    );
  }
}
