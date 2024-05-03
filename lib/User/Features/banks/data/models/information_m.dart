
import '../../domain/entites/bank_information.dart';

class BankInformationModel extends BankInformation {
  BankInformationModel({
    required super.title,
    required super.classs,
    required super.material,
    required super.teacher,
    required super.price,
    required super.video,
  });

  factory BankInformationModel.fromJson(Map json) {
    return BankInformationModel(
      title: json["title"],
      classs: json["classs"],
      material: json["material"],
      teacher: json["teacher"],
      price: json["price"],
      video: json["video"],
    );
  }
  factory BankInformationModel.fromClass(BankInformation information) {
    return BankInformationModel(
      title: information.title,
      classs: information.classs,
      material: information.material,
      teacher: information.teacher,
      price: information.price,
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
      "video": video,
    };
  }
}
