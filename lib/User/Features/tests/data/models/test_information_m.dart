import 'package:moatmat_app/User/Features/tests/domain/entities/test_information.dart';

import 'mini_test_m.dart';

class TestInformationModel extends TestInformation {
  TestInformationModel({
    required super.title,
    required super.classs,
    required super.material,
    required super.teacher,
    required super.folder,
    required super.price,
    required super.password,
    required super.period,
    required super.video,
    required super.files,
    required super.previous,
  });

  factory TestInformationModel.fromJson(Map json) {
    return TestInformationModel(
      title: json["title"],
      classs: json["classs"],
      material: json["material"],
      teacher: json["teacher"],
      price: json["price"],
      password: json["password"],
      period: json["period"],
      video: json["video"],
      folder: json["folder"] ?? "المجلد الرئيسي",
      files: List.generate(
        (json["files"] as List? ?? []).length,
        (i) => json["files"][i],
      ),
      previous: json["previous"] != null
          ? MiniTestModel.fromJson(json["previous"])
          : null,
    );
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
      video: information.video,
      folder: information.folder,
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
      "folder": folder,
      "price": price,
      "password": password,
      "period": period,
      "video": video,
      "files": files ?? <String>[],
      "previous": previous == null
          ? previous
          : MiniTestModel.fromClass(previous!).toJson()
    };
  }
}
