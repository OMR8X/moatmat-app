import 'package:moatmat_app/User/Features/tests/domain/entities/answer.dart';

class TestQuestion {
  final int id;
  final String? question;
    final String? explain;
    final String? equation;
  final String? image;
  final int? time;
  final bool editable;
  final List<TestAnswer> answers;

  TestQuestion({
    required this.id,
    required this.question,
    required this.explain,
    required this.equation,
    required this.image,
    required this.time,
    required this.editable,
    required this.answers,
  });
  TestQuestion copyWith({
    int? id,
    String? question,
    String? explain,
    String? equation,
    String? image,
    int? time,
    bool? editable,
    List<TestAnswer>? answers,
  }) {
    return TestQuestion(
      id: id ?? this.id,
      explain: explain ?? this.explain,
      equation: equation ?? this.equation,
      question: question ?? this.question,
      image: image ?? this.image,
      time: time ?? this.time,
      editable: editable ?? this.editable,
      answers: answers ?? this.answers,
    );
  }
}
