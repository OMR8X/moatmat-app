import 'answer.dart';
import 'question.dart';

class OuterTest {
  ///
  final int id;

  ///
  final OuterTestInformation information;

  ///
  final List<OuterTestForm> forms;

  ///
  OuterTest({
    required this.id,
    required this.information,
    required this.forms,
  });
}

class OuterTestInformation {
  //
  final int length;
  //
  final String title;
  //
  final String material;
  //
  final String classs;
  //
  final String teacher;
  //
  final DateTime date;
  //
  final PaperType paperType;

  OuterTestInformation({
    required this.paperType,
    required this.length,
    required this.title,
    required this.material,
    required this.classs,
    required this.teacher,
    required this.date,
  });
}

class OuterTestForm {
  final int id;
  final List<OuterQuestion> questions;

  OuterTestForm({
    required this.id,
    required this.questions,
  });

  OuterTestForm copyWith({
    int? id,
    List<OuterQuestion>? questions,
  }) {
    return OuterTestForm(
      id: id ?? this.id,
      questions: questions ?? this.questions,
    );
  }
}

class OuterQuestion {
  final int id;
  final int trueAnswer;

  OuterQuestion({
    required this.id,
    required this.trueAnswer,
  });
  OuterQuestion copyWith({
    int? id,
    int? trueAnswer,
  }) {
    return OuterQuestion(
      id: id ?? this.id,
      trueAnswer: trueAnswer ?? this.trueAnswer,
    );
  }

  Question toQuestion() {
    return Question(
      id: id,
      lowerImageText: "السؤال رقم : ${id + 1}",
      upperImageText: "",
      image: "",
      video: "",
      explain: "",
      period: null,
      editable: null,
      equations: [],
      colors: [],
      explainImage: null,
      //
      answers: List.generate(
        5,
        (index) {
          return Answer(
            id: 0,
            text: "",
            equations: [],
            trueAnswer: trueAnswer == index,
            image: "",
          );
        },
      ),
    );
  }
}

enum PaperType { A4, A5, A6 }
