import '../../../../Core/functions/string_to_paper_type.dart';
import '../../domain/entities/outer_test.dart';

class OuterTestInformationModel extends OuterTestInformation {
  OuterTestInformationModel({
    required super.paperType,
    required super.length,
    required super.title,
    required super.material,
    required super.classs,
    required super.teacher,
    required super.date,
  });
  factory OuterTestInformationModel.fromJson(Map json) {
    return OuterTestInformationModel(
      length: json['length'],
      paperType: stringToPaperType(json['paper_type']),
      title: json['title'],
      teacher: json['teacher'],
      classs: json['classs'],
      material: json['material'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }
  factory OuterTestInformationModel.fromClass(OuterTestInformation information) {
    return OuterTestInformationModel(
      length: information.length,
      title: information.title,
      material: information.material,
      classs: information.classs,
      teacher: information.teacher,
      date: information.date,
      paperType: information.paperType,
    );
  }

  toJson() {
    return {
      'paper_type': paperType.name,
      'length': length,
      'title': title,
      'classs': classs,
      'teacher': teacher,
      'material': material,
      'date': date.toString(),
    };
  }
}
