class Answer {
  final String? text;
  final List<String>? equations;
  final bool? trueAnswer;
  final String? image;

  Answer({
    required this.text,
    required this.equations,
    required this.trueAnswer,
    required this.image,
  });

  Answer copyWith({
    String? text,
    List<String>? equation,
    bool? trueAnswer,
    String? image,
  }) {
    return Answer(
      text: text ?? this.text,
      equations: equation ?? this.equations,
      trueAnswer: trueAnswer ?? this.trueAnswer,
      image: image ?? this.image,
    );
  }

  bool isNotEmpty() {
    bool con1 = text != null && text != "";
    bool con2 = image != null && image != "";

    return con1 || con2;
  }
}
