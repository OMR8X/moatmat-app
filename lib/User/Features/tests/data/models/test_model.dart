import 'package:moatmat_app/User/Features/tests/data/models/question_m.dart';
import 'package:moatmat_app/User/Features/tests/data/models/test_information_m.dart';
import 'package:moatmat_app/User/Features/tests/data/models/test_properties_m.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';

class TestModel extends Test {
  TestModel({
    required super.id,
    required super.teacherEmail,
    required super.information,
    required super.properties,
    required super.questions,
  });
  factory TestModel.fromJson(Map json) {

    return TestModel(
      id: json['id'],
      teacherEmail: json['teacher_email'],
      information: TestInformationModel.fromJson(json['information']),
      properties: TestPropertiesModel.fromJson(json['properties']),
      questions: List.generate(
        (json['questions'] as List).length,
        (i) => QuestionModel.fromJson(json['questions'][i]),
      ),
    );
  }

  factory TestModel.fromClass(Test test) {
    return TestModel(
      id: test.id,
      teacherEmail: test.teacherEmail,
      information: test.information,
      properties: test.properties,
      questions: test.questions,
    );
  }
  toJson() {
    return {
      "teacher_email": teacherEmail,
      "information": TestInformationModel.fromClass(information).toJson(),
      "properties": TestPropertiesModel.fromClass(properties).toJson(),
      "questions": List.generate(
        questions.length,
        (i) => QuestionModel.fromClass(questions[i]).toJson(),
      ),
    };
  }
}
