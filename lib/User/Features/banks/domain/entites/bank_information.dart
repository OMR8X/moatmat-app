class BankInformation {
  final String title; //
  final String classs; //
  final String material;
  final String teacher;
  final int price; //
  final String? video;

  BankInformation({
    required this.title,
    required this.classs,
    required this.material,
    required this.teacher,
    required this.price,
    required this.video,
  });
  BankInformation copyWith({
    String? title,
    String? classs,
    String? material,
    String? teacher,
    int? price,
    String? password,
    int? period,
    String? video,
  }) {
    return BankInformation(
      title: title ?? this.title,
      classs: classs ?? this.classs,
      material: material ?? this.material,
      teacher: teacher ?? this.teacher,
      price: price ?? this.price,
      video: video ?? this.video,
    );
  }
}
/*
password
period
*/