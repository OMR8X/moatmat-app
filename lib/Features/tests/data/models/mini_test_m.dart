
import '../../domain/entities/mini_test.dart';

class MiniTestModel extends MiniTest {
  MiniTestModel({
    required super.id,
    required super.title,
    required super.material,
  });

  factory MiniTestModel.fromJson(Map<String, dynamic> json) {
    return MiniTestModel(
      id: json['id'],
      title: json['title'],
      material: json['material'],
    );
  }
  factory MiniTestModel.fromClass(MiniTest test) {
    return MiniTestModel(
      id: test.id,
      title: test.title,
      material: test.material,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'material': material,
    };
  }
}
