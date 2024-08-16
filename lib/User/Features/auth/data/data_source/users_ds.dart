import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/services/device_s.dart';
import 'package:moatmat_app/User/Features/update/domain/entites/update_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../domain/entites/teacher_data.dart';
import '../../domain/entites/user_data.dart';
import '../models/teacher_data_m.dart';
import '../models/user_data_m.dart';

abstract class UsersDataSource {
  // signIn
  Future<UserData> signIn({
    required String email,
    required String password,
  });
  // signUp
  Future<UserData> signUp({
    required UserData userData,
    required String password,
  });
  //
  // update User Data
  Future<Unit> updateUserData({
    required UserData userData,
  });
  //
  // get User Data
  Future<UserData> getUserData({required String uuid});
  //
  // get teacher Data
  Future<TeacherData> getTeacherData();
  //
  Future<Unit> resetPassword({
    required String email,
    required String password,
    required String token,
  });
}

class UsersDataSourceImpl implements UsersDataSource {
  final SupabaseClient client;

  UsersDataSourceImpl({required this.client});
  @override
  Future<UserData> getUserData({required String uuid}) async {
    //
    await addUpdateData();
    //
    client.from("users_data").select().eq("uuid", uuid);
    //
    var query = client.from("users_data").select().eq("uuid", uuid);
    //
    List res = await query;
    //
    if (res.isNotEmpty) {
      //
      final userData = UserDataModel.fromJson(res.first);
      //
      await removeUpdateData();
      //
      return userData;
    } else {
      //
      await removeUpdateData();
      //
      throw Exception();
    }
  }

  addUpdateData() async {
    //
    Map data = client.auth.currentUser?.userMetadata ?? {};
    //
    data["version"] = locator<UpdateInfo>().appVersion;
    //
    await client.auth.updateUser(
      UserAttributes(
        data: data,
      ),
    );
    //
    await client.auth.refreshSession();
    //
    return;
  }

  removeUpdateData() async {
    //
    await client.auth.updateUser(
      UserAttributes(
        data: {"version": 0},
      ),
    );
    //
    await client.auth.refreshSession();
    //
    return;
  }

  @override
  Future<UserData> signIn({
    required String email,
    required String password,
  }) async {
    email = email.toLowerCase().trim();
    await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    String? uuid = client.auth.currentUser?.id;
    if (uuid != null) {
      final userData = await getUserData(uuid: uuid);
      await updateUserData(
        userData: userData.copyWith(deviceId: DeviceService().deviceId),
      );
      return userData;
    } else {
      throw AnonException();
    }
    //
    //
  }

  @override
  Future<UserData> signUp({
    required UserData userData,
    required String password,
  }) async {
    //
    userData = userData.copyWith(email: userData.email.toLowerCase().trim());
    //
    await client.auth.signUp(
      email: userData.email,
      password: password,
    );
    //
    String? uuid = client.auth.currentUser?.id;
    //
    if (uuid != null) {
      //
      userData = userData.copyWith(uuid: uuid);
      //
      await updateUserData(userData: userData);
      //
      await updateUserData(
        userData: userData.copyWith(deviceId: DeviceService().deviceId),
      );
      //
      return userData;
    } else {
      throw AnonException();
    }
  }

  @override
  Future<Unit> updateUserData({
    required UserData userData,
    bool removeBalance = false,
  }) async {
    //
    await addUpdateData();
    //
    Map json = UserDataModel.fromClass(userData).toJson();
    //
    if (removeBalance) {
      json.remove("balance");
    }
    //
    //
    var emails = await client.from("users_data").select().eq(
          "uuid",
          userData.uuid,
        );

    //
    if (emails.isEmpty) {
      await client.from("users_data").insert(json).eq(
            "uuid",
            userData.uuid,
          );
    } else {
      await client.from("users_data").update(json).eq(
            "uuid",
            userData.uuid,
          );
    }
    //
    await removeUpdateData();
    //
    return unit;
  }

  @override
  Future<Unit> resetPassword({
    required String email,
    required String password,
    required String token,
  }) async {
    var client = Supabase.instance.client;
    await client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.recovery,
    );
    await client.auth.updateUser(
      UserAttributes(password: password),
    );
    return unit;
  }

  @override
  Future<TeacherData> getTeacherData() async {
    //
    var query = client
        .from("teachers_data")
        .select()
        .eq("email", client.auth.currentUser!.email!);
    //
    List res = await query;
    if (res.isNotEmpty) {
      final teacherData = TeacherDataModel.fromJson(res.first);
      return teacherData;
    } else {
      throw Exception();
    }
  }
}
