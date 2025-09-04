import 'package:moatmat_app/Features/school/domain/entities/school_information.dart';

class School {
  const School({required this.id, required this.information});

  final int id;
  final SchoolInformation information;

  School copyWith({
    int? id,
    SchoolInformation? information,
  }) {
    return School(
      id: id ?? this.id,
      information: information ?? this.information,
    );
  }
}
