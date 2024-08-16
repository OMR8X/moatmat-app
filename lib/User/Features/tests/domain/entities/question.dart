
import 'answer.dart';
import 'question_word_color.dart';

class Question {
  final int id;
  //
  final String? upperImageText;
  //
  final String? lowerImageText;
  //
  final String? image;
  //
  final String? video;
  //
  final String? explain;
  //
  final String? explainImage;
  //
  final int? period;
  //
  final bool? editable;
  //
  final List<Answer> answers;
  //
  final List<String> equations;
  //
  final List<QuestionWordColor> colors;

  Question copyWith({
    int? id,
    String? lowerImageText,
    String? upperImageText,
    String? image,
    String? explainImage,
    String? video,
    String? explain,
    int? period,
    bool? editable,
    List<Answer>? answers,
    List<String>? equations,
    List<QuestionWordColor>? colors,
  }) {
    return Question(
      id: id ?? this.id,
      lowerImageText: lowerImageText ?? this.lowerImageText,
      upperImageText: upperImageText ?? this.upperImageText,
      image: image ?? this.image,
      video: video ?? this.video,
      explain: explain ?? this.explain,
      period: period ?? this.period,
      editable: editable ?? this.editable,
      answers: answers ?? this.answers,
      equations: equations ?? this.equations,
      colors: colors ?? this.colors,
      explainImage: explainImage ?? this.explainImage,
    );
  }

  bool isNotEmpty() {
    bool con1 = upperImageText != null && upperImageText != "";
    bool con2 = lowerImageText != null && lowerImageText != "";
    bool con3 = image != null && image != "";
    bool con4 = video != null && video != "";

    return con1 || con2 || con3 || con4;
  }

  const Question({
    required this.id,
    required this.lowerImageText,
    required this.upperImageText,
    required this.image,
    required this.video,
    required this.explain,
    required this.period,
    required this.editable,
    required this.answers,
    required this.equations,
    required this.colors,
    required this.explainImage,
  });
}