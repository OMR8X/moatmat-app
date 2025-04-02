
import '../../domain/entities/outer_test.dart';
import 'outer_test_form_model.dart';
import 'outer_test_information_model.dart';

class OuterTestModel extends OuterTest {
  OuterTestModel({
    required super.id,
    required super.information,
    required super.forms,
  });

  factory OuterTestModel.fromJson(Map json) {
    return OuterTestModel(
      id: json['id'],
      information: OuterTestInformationModel.fromJson(json['information']),
      forms: (json['forms'] as List).map((e) {
        return OuterTestFormModel.fromJson(e);
      }).toList(),
    );
  }
  factory OuterTestModel.fromClass(OuterTest test) {
    return OuterTestModel(
      id: test.id,
      information: test.information,
      forms: test.forms,
    );
  }

  toJson() {
    return {
      'information': OuterTestInformationModel.fromClass(information).toJson(),
      'forms': forms.map((e) {
        return OuterTestFormModel.fromClass(e).toJson();
      }).toList(),
    };
  }
}
