import '../../../../Core/injection/app_inj.dart';
import 'group.dart';
import 'teacher_options.dart';

class TeacherData {
  final String name;
  final String email;
  final int price;
  final String purchaseDescription;
  final TeacherOptions options;
  //
  final String? description;
  final String? image;
  //
  Map<String, dynamic> banksFolders;
  Map<String, dynamic> testsFolders;
  //
  List<Group> groups;
  List<int> courseSubscribersTests;

  TeacherData({
    required this.name,
    required this.email,
    required this.options,
    required this.description,
    required this.image,
    required this.purchaseDescription,
    required this.price,
    required this.banksFolders,
    required this.testsFolders,
    required this.groups,
    required this.courseSubscribersTests,
  });
  updateBanksFolders(Map<String, dynamic> banksFolders) {}

  updateTestsFolders(Map<String, dynamic> testsFolders) {}

  TeacherData copyWith({
    String? name,
    String? email,
    String? purchaseDescription,
    TeacherOptions? options,
    String? description,
    String? image,
    int? price,
    Map<String, dynamic>? banksFolders,
    Map<String, dynamic>? testsFolders,
    List<Group>? groups,
    List<int>? courseSubscribersTests,
  }) {
    return TeacherData(
      name: name ?? this.name,
      email: email ?? this.email,
      options: options ?? this.options,
      purchaseDescription: purchaseDescription ?? this.purchaseDescription,
      price: price ?? this.price,
      description: description ?? this.description,
      image: image ?? this.image,
      testsFolders: testsFolders ?? this.testsFolders,
      banksFolders: banksFolders ?? this.banksFolders,
      groups: groups ?? this.groups,
      courseSubscribersTests: courseSubscribersTests ?? this.courseSubscribersTests,
    );
  }
}
