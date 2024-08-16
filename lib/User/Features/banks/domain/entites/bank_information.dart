class BankInformation {
  final String title; //
  final String classs; //
  final String material;
  final String teacher;
  final String folder;
  final int price; //
  final String? video;
  final List<String>? files;

  BankInformation({
    required this.title,
    required this.classs,
    required this.material,
    required this.teacher,
    required this.folder,
    required this.price,
    required this.video,
    required this.files,
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
    String? folder,
    List<String>? files,
  }) {
    return BankInformation(
      title: title ?? this.title,
      classs: classs ?? this.classs,
      material: material ?? this.material,
      teacher: teacher ?? this.teacher,
      price: price ?? this.price,
      video: video ?? this.video,
      folder: video ?? this.folder,
      files: files ?? this.files,
    );
  }
}