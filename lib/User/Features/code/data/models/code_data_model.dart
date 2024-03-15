
import '../../domain/entites/code_data.dart';

class CodeDataModel extends CodeData {
  CodeDataModel({
    required super.id,
    required super.amount,
    required super.used,
    super.check1,
    super.check2,
  });
  factory CodeDataModel.fromJson(Map json) {
    return CodeDataModel(
      id: json["id"],
      amount: json["amount"],
      check1: json["check1"] != null ? DateTime.parse(json["check1"]) : null,
      check2: json["check2"] != null ? DateTime.parse(json["check2"]) : null,
      used: json["used"],
    );
  }
  factory CodeDataModel.fromClass(CodeData codeData) {
    return CodeDataModel(
      id: codeData.id,
      amount: codeData.amount,
      check1: codeData.check1,
      check2: codeData.check2,
      used: codeData.used,
    );
  }
  toJson() {
    return {
      "amount": amount,
      "check1": check1,
      "check2": check2,
      "used": used,
    };
  }
}
