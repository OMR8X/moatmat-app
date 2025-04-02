class BankInformation {
  final String title; //
  final String classs; //
  final String material;
  final String teacher;
  final int price; //
  final List<String>? images;
  final List<String>? video;
  final List<String>? files;

  BankInformation({
    required this.title,
    required this.classs,
    required this.material,
    required this.teacher,
    required this.images,
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
    List<String>? video,
    List<String>? images,
    List<String>? files,
  }) {
    return BankInformation(
      title: title ?? this.title,
      classs: classs ?? this.classs,
      material: material ?? this.material,
      teacher: teacher ?? this.teacher,
      price: price ?? this.price,
      video: video ?? this.video,
      images: images ?? this.images,
      files: files ?? this.files,
    );
  }
}
