import 'package:moatmat_app/User/Features/auth/domain/entites/user_like.dart';

import '../../../tests/domain/entities/test.dart';

class UserData {
  final String uuid;
  final int balance;
  final String name;
  final String email;
  final String motherName;
  final String age;
  final String classroom;
  final String schoolName;
  final String governorate;
  final String phoneNumber;
  final String whatsappNumber;
  final List<UserLike> likes;
  final List<(int,String)> tests;

  UserData({
    required this.likes,
    required this.tests,
    required this.uuid,
    required this.balance,
    required this.name,
    required this.email,
    required this.motherName,
    required this.age,
    required this.classroom,
    required this.schoolName,
    required this.governorate,
    required this.phoneNumber,
    required this.whatsappNumber,
  });

  UserData copyWith({
    String? uuid,
    int? balance,
    String? name,
    String? email,
    String? motherName,
    String? age,
    String? classroom,
    String? schoolName,
    String? governorate,
    String? phoneNumber,
    String? whatsappNumber,
    List<UserLike>? likes,
    List<(int,String)>? tests,
  }) {
    return UserData(
      uuid: uuid ?? this.uuid,
      balance: balance ?? this.balance,
      name: name ?? this.name,
      email: email ?? this.email,
      motherName: motherName ?? this.motherName,
      age: age ?? this.age,
      classroom: classroom ?? this.classroom,
      schoolName: schoolName ?? this.schoolName,
      governorate: governorate ?? this.governorate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      likes: likes ?? this.likes,
      tests: tests ?? this.tests,
    );
  }
}
