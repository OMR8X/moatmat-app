import '../../domain/entites/bank_information.dart';

class BankInformationModel extends BankInformation {
  BankInformationModel({
    required super.title,
    required super.classs,
    required super.material,
    required super.teacher,
    required super.price,
    required super.video,
    required super.images,
    required super.files,
  });

  factory BankInformationModel.fromJson(Map json) {
    print(json["video"]);
    return BankInformationModel(
      title: json["title"],
      classs: json["classs"],
      material: json["material"],
      teacher: json["teacher"],
      price: json["price"],
      images: (json["images"] ?? []).cast<String>(),
      video: stringToList(json["video"]),
      files: List.generate(
        (json["files"] as List? ?? []).length,
        (i) => json["files"][i],
      ),
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

  factory BankInformationModel.fromClass(BankInformation information) {
    return BankInformationModel(
      title: information.title,
      classs: information.classs,
      material: information.material,
      teacher: information.teacher,
      price: information.price,
      video: information.video,
      images: information.images,
      files: information.files,
    );
  }

  toJson() {
    return {
      "title": title,
      "classs": classs,
      "material": material,
      "teacher": teacher,
      "price": price,
      "video": (video?.isNotEmpty ?? false) ? video!.join(",") : null,
      "images": images,
      "files": files,
    };
  }
}
