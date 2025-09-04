import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:moatmat_app/Core/services/encryption_s.dart';
import 'package:moatmat_app/Features/auth/domain/entites/user_like.dart';

class UserData {
  //
  final int id;
  //
  final String uuid;
  final String deviceId;
  //
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
  final List<(int, String)> tests;

  UserData({
    required this.id,
    required this.deviceId,
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

  String toQrValue() {

    String str = json.encode({
      "id": id,
      "name": name,
    });
    str = EncryptionService.encryptData(str);
    return str;
  }

  UserData copyWith({
    int? id,
    String? uuid,
    int? balance,
    String? name,
    String? email,
    String? motherName,
    String? age,
    String? classroom,
    String? schoolName,
    String? governorate,
    String? deviceId,
    String? phoneNumber,
    String? whatsappNumber,
    List<UserLike>? likes,
    List<(int, String)>? tests,
  }) {
    return UserData(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
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
