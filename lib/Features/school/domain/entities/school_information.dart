class SchoolInformation {
  final String name;
  final String description;

  SchoolInformation({required this.name, required this.description});

  SchoolInformation copyWith({
    String? name,
    String? description,
  }) {
    return SchoolInformation(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
