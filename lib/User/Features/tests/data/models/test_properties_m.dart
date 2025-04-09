import 'package:flutter/foundation.dart';

import '../../domain/entities/test_properties.dart';

class TestPropertiesModel extends TestProperties {
  TestPropertiesModel({
    required super.exploreAnswers,
    required super.showAnswers,
    required super.timePerQuestion,
    required super.repeatable,
    required super.visible,
    required super.scrollable,
  });
  factory TestPropertiesModel.fromJson(Map json) {
    return TestPropertiesModel(
      exploreAnswers: json["explore_answers"],
      showAnswers: json["show_answers"],
      timePerQuestion: json["time_per_question"],
      repeatable: json["repeatable"],
      visible: json["visible"],
      scrollable: kDebugMode ? true : json["scrollable"],
    );
  }
  factory TestPropertiesModel.fromClass(TestProperties properties) {
    return TestPropertiesModel(
      exploreAnswers: properties.exploreAnswers,
      showAnswers: properties.showAnswers,
      timePerQuestion: properties.timePerQuestion,
      repeatable: properties.repeatable,
      visible: properties.visible,
      scrollable: properties.scrollable,
    );
  }

  toJson() {
    return {
      "explore_answers": exploreAnswers,
      "show_answers": showAnswers,
      "time_per_question": timePerQuestion,
      "repeatable": repeatable,
      "visible": visible,
      "scrollable": scrollable,
    };
  }
}
