import 'package:moatmat_app/User/Features/banks/domain/entites/b_question_answer.dart';

class BankQuestion {
  final int id;
  final String? question;

  final String? explain;
  final String? equation;
  final String? image;
  final List<BankAnswer> answers;
  BankQuestion({
    required this.id,
    required this.explain,
    required this.equation,
    required this.question,
    required this.image,
    required this.answers,
  });
  BankQuestion copyWith({
    int? id,
    String? question,
    String? image,
    String? explain,
    String? equation,
    List<BankAnswer>? answers,
  }) {
    return BankQuestion(
      id: id ?? this.id,
      explain: explain ?? this.explain,
      question: question ?? this.question,
      equation: equation ?? this.equation,
      image: image ?? this.image,
      answers: answers ?? this.answers,
    );
  }
}
