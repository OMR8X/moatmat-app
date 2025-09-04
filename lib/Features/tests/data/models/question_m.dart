import 'package:moatmat_app/Features/tests/data/models/answer_m.dart';
import 'package:moatmat_app/Features/tests/data/models/question_w_color_m.dart';
import 'package:moatmat_app/Features/tests/domain/entities/question.dart';

class QuestionModel extends Question {
  QuestionModel({
    required super.id,
    required super.upperImageText,
    required super.lowerImageText,
    required super.explain,
    required super.explainImage,
    required super.equations,
    required super.image,
    required super.period,
    required super.editable,
    required super.answers,
    required super.video,
    required super.colors,
  });
  factory QuestionModel.fromJson(Map json) {
    return QuestionModel(
      id: json["id"],
      upperImageText: json["upper_image_text"],
      lowerImageText: json["lower_image_text"],
      explain: json["explain"],
      explainImage: json["explain_image"],
      equations: List.generate(
        (json["equations"] as List?)?.length ?? 0,
        (i) => json["equations"][i],
      ),
      image: json["image"],
      period: json["period"],
      editable: json["editable"],
      answers: List.generate(
        (json["answers"] as List).length,
        (i) {
          Map answer = json["answers"][i];
          answer["id"] = i;
          return AnswerModel.fromJson(answer);
        },
      ),
      video: json["video"],
      colors: List.generate(
        (json["colors"] as List?)?.length ?? 0,
        (i) => QuestionWordColorModel.fromJson(json["colors"][i]),
      ),
    );
  }
  factory QuestionModel.fromClass(Question question) {
    return QuestionModel(
      id: question.id,
      upperImageText: question.upperImageText,
      lowerImageText: question.lowerImageText,
      explain: question.explain,
      equations: question.equations,
      image: question.image,
      period: question.period,
      editable: question.editable,
      answers: question.answers,
      video: question.video,
      colors: question.colors,
      explainImage: question.explainImage,
    );
  }
  Map toJson() {
    return {
      "id": id,
      "upper_image_text": upperImageText,
      "lower_image_text": lowerImageText,
      "explain": explain,
      "explain_image": explainImage,
      "equations": equations,
      "image": image,
      "period": period,
      "editable": editable,
      "video": video,
      "colors": List.generate(
        colors.length,
        (i) => QuestionWordColorModel.fromClass(colors[i]).toJson(),
      ),
      "answers": List.generate(
        answers.length,
        (i) {
          return AnswerModel.fromClass(answers[i]).toJson();
        },
      ),
    };
  }
}
