import 'package:moatmat_app/User/Features/tests/domain/entities/mini_test.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/video.dart';

class TestInformation {
  final String title;
  final String classs;
  final String material;
  final String teacher;
  final int? price;
  final String? password;
  final int? period;
  final List<String>? images;
  final List<Video>? video;
  final List<String>? files;
  final MiniTest? previous;

  TestInformation({
    required this.title,
    required this.classs,
    required this.material,
    required this.teacher,
    required this.price,
    required this.password,
    required this.period,
    required this.images,
    required this.video,
    required this.files,
    required this.previous,
  });
  TestInformation copyWith({
    String? title,
    String? classs,
    String? material,
    String? teacher,
    int? price,
    String? password,
    int? period,
    List<Video>? video,
    List<String>? images,
    List<String>? files,
    MiniTest? previous,
  }) {
    return TestInformation(
      title: title ?? this.title,
      classs: classs ?? this.classs,
      material: material ?? this.material,
      teacher: teacher ?? this.teacher,
      price: price ?? this.price,
      password: password ?? this.password,
      period: period ?? this.period,
      video: video ?? this.video,
      images: images ?? this.images,
      files: files ?? this.files,
      previous: previous ?? this.previous,
    );
  }
}
