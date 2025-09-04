import 'package:moatmat_app/Features/tests/domain/entities/test_information.dart';
import 'package:moatmat_app/Features/video/data/models/video_m.dart';

import 'mini_test_m.dart';

class TestInformationModel extends TestInformation {
  TestInformationModel({
    required super.title,
    required super.classs,
    required super.material,
    required super.teacher,
    required super.price,
    required super.password,
    required super.period,
    required super.videos,
    required super.images,
    required super.files,
    required super.previous,
  });

  factory TestInformationModel.fromJson(Map json) {
    print(json);
    return TestInformationModel(
      title: json["title"],
      classs: json["classs"],
      material: json["material"],
      teacher: json["teacher"],
      price: json["price"],
      password: json["password"],
      period: json["period"],
      images: (json["images"] ?? []).cast<String>(),
      videos: (json["videos"] as List?)?.map((e) => VideoModel.fromJson(e,tests: true)).toList(),
      files: List.generate(
        (json["files"] as List? ?? []).length,
        (i) => json["files"][i],
      ),
      previous: json["previous"] != null ? MiniTestModel.fromJson(json["previous"]) : null,
    );
  }

  static List<String> stringToList(String? value) {
    try {
      if (value == null || value == '') {
        return [];
      } else {
        return value.split(',');
      }
    } on Exception {
      return [];
    }
  }

  factory TestInformationModel.fromClass(TestInformation information) {
    return TestInformationModel(
      title: information.title,
      classs: information.classs,
      material: information.material,
      teacher: information.teacher,
      price: information.price,
      password: information.password,
      period: information.period,
      images: information.images,
      videos: information.videos,
      files: information.files,
      previous: information.previous,
    );
  }

  toJson() {
    return {
      "title": title,
      "classs": classs,
      "material": material,
      "teacher": teacher,
      "price": price,
      "password": password,
      "videos": (videos?.isNotEmpty ?? false) ? videos?.map((e) => VideoModel.fromClass(e).toJson(tests: true,addId: true)).toList() : [],
      "images": images,
      "period": period,
      "files": files ?? <String>[],
      "previous": previous == null ? previous : MiniTestModel.fromClass(previous!).toJson()
    };
  }
}
