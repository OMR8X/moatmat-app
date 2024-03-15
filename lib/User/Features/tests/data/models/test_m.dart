import 'package:moatmat_app/User/Features/banks/data/models/bank_q_m.dart';
import 'package:moatmat_app/User/Features/tests/data/models/question_m.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';

class TestModel extends Test {
  TestModel({
    required super.id,
    required super.title,
    required super.clas,
    required super.material,
    required super.teacher,
    required super.seconds,
    required super.password,
    required super.cost,
    required super.timePerQuestion,
    required super.explorable,
    required super.returnable,
    required super.questions,
  });
  factory TestModel.fromJson(Map json) {
    return TestModel(
      id: json["id"],
      title: json["title"],
      clas: json["class"],
      material: json["material"],
      teacher: json["teacher"],
      seconds: json["seconds"],
      password: json["password"],
      cost: json["cost"],
      timePerQuestion: json["time_per_question"] ?? false,
      explorable: json["explorable"] ?? false,
      returnable: json["returnable"] ?? false,
      questions: List.generate(
        (json["questions"] as List).length,
        (i) {
          var map = (json["questions"][i] as Map);
          map["id"] = i;
          return TestQuestionModel.fromJson(map);
        },
      ),
    );
  }
  toJson() {
    return {
      "id": id,
      "title": title,
      "class": clas,
      "material": material,
      "teacher": teacher,
      "seconds": seconds,
      "password": password,
      "cost": cost,
      "time_per_question": timePerQuestion,
      "explorable": explorable,
      "returnable": returnable,
      "questions": questions.map((e) {
        return TestQuestionModel.fromClass(e).toJson();
      }).toList(),
    };
  }

  factory TestModel.fromClass(Test test) {
    return TestModel(
      id: test.id,
      title: test.title,
      clas: test.clas,
      material: test.material,
      teacher: test.teacher,
      seconds: test.seconds,
      password: test.password,
      cost: test.cost,
      timePerQuestion: test.timePerQuestion,
      explorable: test.explorable,
      returnable: test.returnable,
      questions: test.questions,
    );
  }
}
