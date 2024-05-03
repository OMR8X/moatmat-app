class TestProperties {
  final bool? exploreAnswers;
  final bool? showAnswers;
  final bool? timePerQuestion;
  final bool? repeatable;
  final bool? visible;

  TestProperties({
    required this.exploreAnswers,
    required this.showAnswers,
    required this.timePerQuestion,
    required this.repeatable,
    required this.visible,
  });
  TestProperties copyWith({
    bool? exploreAnswers,
    bool? showAnswers,
    bool? timePerQuestion,
    bool? repeatable,
    bool? visible,
  }) {
    return TestProperties(
      exploreAnswers: exploreAnswers ?? this.exploreAnswers,
      showAnswers: showAnswers ?? this.showAnswers,
      timePerQuestion: timePerQuestion ?? this.timePerQuestion,
      repeatable: repeatable ?? this.repeatable,
      visible: visible ?? this.visible,
    );
  }
}
