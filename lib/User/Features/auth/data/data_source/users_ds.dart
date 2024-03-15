import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../domain/entites/user_data.dart';
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
    var query = client.from("users_data").select();
    query.eq("uuid", uuid);
    List res = await query;
    if (res.isNotEmpty) {
      final userData = UserDataModel.fromJson(res.first);
      return userData;
    } else {
      throw Exception();
    }
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
      return await getUserData(uuid: uuid);
    } else {
      throw AnonException();
    }
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
    if (uuid != null) {
      userData = userData.copyWith(uuid: uuid);
      await updateUserData(userData: userData);
      return userData;
    } else {
      throw AnonException();
    }
  }

  @override
  Future<Unit> updateUserData(
      {required UserData userData, bool removeBalande = false}) async {
    Map json = UserDataModel.fromClass(userData).toJson();
    if (removeBalande) {
      json.remove("balance");
    }
    var query = client.from("users_data").upsert(json);
    query.eq("uuid", userData.uuid);
    await query;
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
}
