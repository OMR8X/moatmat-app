import 'package:moatmat_app/User/Features/tests/domain/entities/test_information.dart';

class TestInformationModel extends TestInformation {
  TestInformationModel({
    required super.title,
    required super.classs,
    required super.material,
    required super.teacher,
    required super.price,
    required super.password,
    required super.period,
    required super.video,
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
      "period": period,
      "video": video,
    };
  }
}
