import '../../../tests/data/models/question_m.dart';
import '../../domain/entites/bank.dart';
import 'information_m.dart';

class BankModel extends Bank {
  BankModel({
    required super.id,
    required super.teacherEmail,
    required super.information,
    required super.questions,
  });

  factory BankModel.fromJson(Map json) {
    return BankModel(
      id: json['id'],
      teacherEmail: json['teacher_email'],
      information: BankInformationModel.fromJson(json['information']),
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
      questions: bank.questions,
    );
  }
  toJson() {
    return {
      "teacher_email": teacherEmail,
      "information": BankInformationModel.fromClass(information).toJson(),
      "questions": List.generate(
        questions.length,
        (i) => QuestionModel.fromClass(questions[i]).toJson(),
      ),
    };
  }
}
