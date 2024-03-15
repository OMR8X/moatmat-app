import 'package:moatmat_app/User/Features/banks/data/models/bank_q_m.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';

class BankModel extends Bank {
  BankModel({
    required super.id,
    required super.cost,
    required super.title,
    required super.clas,
    required super.material,
    required super.teacher,
    required super.questions,
  });
  factory BankModel.fromJson(Map json) {
    return BankModel(
      id: json["id"],
      cost: json["cost"],
      title: json["title"],
      clas: json["class"],
      material: json["material"],
      teacher: json["teacher"],
      questions: List.generate((json["questions"] as List).length, (i) {
        var map = (json["questions"][i] as Map);
        map["id"] = i;
        return BankQuestionModel.fomJson(map);
      }),
    );
  }
  factory BankModel.fromClass(Bank bank) {
    return BankModel(
      id: bank.id,
      cost: bank.cost,
      title: bank.title,
      clas: bank.clas,
      material: bank.material,
      teacher: bank.teacher,
      questions: bank.questions,
    );
  }
  toJson() {
    return {
      "id": id,
      "cost": cost,
      "title": title,
      "clas": clas,
      "material": material,
      "teacher": teacher,
      "questions": questions
          .map<Map>(
            (e) => BankQuestionModel.fromClass(e).toJson(),
          )
          .toList(),
    };
  }
}
