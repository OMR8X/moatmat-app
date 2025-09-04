import 'package:moatmat_app/Features/banks/data/models/bank_properties_m.dart';
import 'package:moatmat_app/Features/banks/domain/entites/bank_properties.dart';

import '../../../tests/data/models/question_m.dart';
import '../../domain/entites/bank.dart';
import 'information_m.dart';

class BankModel extends Bank {
  BankModel({
    required super.id,
    required super.teacherEmail,
    required super.information,
    required super.properties,
    required super.questions,
  });

  factory BankModel.fromJson(Map json) {
    return BankModel(
      id: json['id'],
      teacherEmail: json['teacher_email'],
      information: BankInformationModel.fromJson(json['information']),
      properties: BankPropertiesModel.fromJson(json['properties']),
      questions: List.generate(
        (json['questions'] as List).length,
        (i) => QuestionModel.fromJson(json['questions'][i]),
      ),
    );
  }

  factory BankModel.fromClass(Bank bank) {
    return BankModel(
      id: bank.id,
      teacherEmail: bank.teacherEmail,
      information: bank.information,
      properties: bank.properties,
      questions: bank.questions,
    );
  }
  toJson() {
    return {
      "teacher_email": teacherEmail,
      "information": BankInformationModel.fromClass(information).toJson(),
      "properties": BankPropertiesModel.fromClass(properties).toJson(),
      "questions": List.generate(
        questions.length,
        (i) => QuestionModel.fromClass(questions[i]).toJson(),
      ),
    };
  }
}
