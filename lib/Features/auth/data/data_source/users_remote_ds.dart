import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Core/services/cache/cache_manager.dart';
import 'package:moatmat_app/Core/services/device_s.dart';
import 'package:moatmat_app/Features/update/domain/entites/update_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../main.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import '../../../../Core/services/cache/cache_constant.dart';
import '../../domain/entites/teacher_data.dart';
import '../../domain/entites/user_data.dart';
import '../models/teacher_data_m.dart';
import '../models/user_data_m.dart';

abstract class UsersRemoteDataSource {
  // sign in with google
  Future<Unit> startSignInWithGoogle();
  // signIn
  Future<Unit> signIn({
    required String email,
    required String password,
  });
  // signUp
  Future<Unit> signUp({
    required UserData userData,
    required String password,
  });
  //
  // update User Data
  Future<Unit> updateUserData({
    required UserData userData,
  });
  // insert User Data
  Future<Unit> insertUserData({
    required UserData userData,
  });
  //
  // sign out
  Future<Unit> signOut();
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

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final CacheManager cacheManager;
  final SupabaseClient client;

  UsersRemoteDataSourceImpl({
    required this.client,
    required this.cacheManager,
  });
  @override
  Future<UserData> getUserData({required String uuid}) async {
    //
    await addUpdateData();
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
      updateCachedUserData(userData);
      //
      return userData;
    } else {
      //
      await removeUpdateData();
      //
      throw MissingUserDataException();
    }
  }

  addUpdateData() async {
    //
    if (!locator.isRegistered<UpdateInfo>()) {
      return;
    }
    //
    Map data = client.auth.currentUser?.userMetadata ?? {};
    //
    data["version"] = locator<UpdateInfo>().appVersion;
    //
    await client.auth.updateUser(UserAttributes(data: data));
    //
    await client.auth.refreshSession();
    //
    return;
  }

  removeUpdateData() async {
    //
    await client.auth.updateUser(UserAttributes(data: {"version": 0}));
    //
    await client.auth.refreshSession();
    //
    return;
  }

  @override
  Future<Unit> signIn({required String email, required String password}) async {
    //
    await removeCachedUserData();
    //
    email = email.toLowerCase().trim();
    password = password.trim();
    //
    await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    //
    String? uuid = client.auth.currentUser?.id;
    //
    if (uuid != null) {
      //
      final userData = await getUserData(uuid: uuid);
      //
      await updateUserData(userData: userData.copyWith(deviceId: DeviceService().deviceId));

      //
      return unit;
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<Unit> signUp({
    required UserData userData,
    required String password,
  }) async {
    //
    await removeCachedUserData();
    //
    /// [Trim email && password]
    //
    userData = userData.copyWith(email: userData.email.toLowerCase().trim());
    password = password.trim();
    //
    /// [Sign Up]
    //
    try {
      await client.auth.signUp(email: userData.email, password: password);
    } catch (e) {
      rethrow;
    }
    //
    //
    String? uuid = client.auth.currentUser?.id;
    //
    if (uuid != null) {
      //
      final similarEmails = await Supabase.instance.client.from("users_data").select().eq("email", userData.email);
      //
      userData = userData.copyWith(
        uuid: uuid,
        deviceId: DeviceService().deviceId,
      );
      //
      if (similarEmails.isEmpty) {
        //
        await insertUserData(userData: userData);
        //
      } else {
        //
        await updateUserData(userData: userData);
        //
      }
      return unit;
    }
    //
    throw UnknownException();
  }

  @override
  Future<Unit> updateUserData({
    required UserData userData,
    bool removeBalance = false,
  }) async {
    //
    await removeCachedUserData();
    //
    await addUpdateData();
    //
    Map jsonUserData = UserDataModel.fromClass(userData).toJson();
    //
    if (removeBalance) {
      jsonUserData.remove("balance");
    }
    //
    await client.from("users_data").update(jsonUserData).eq("email", userData.email);
    //
    await removeUpdateData();
    //
    updateCachedUserData(UserDataModel.fromJson(jsonUserData));
    //
    return unit;
  }

  @override
  Future<Unit> insertUserData({required UserData userData}) async {
    //
    await removeCachedUserData();
    //
    await addUpdateData();
    //
    Map jsonUserData = UserDataModel.fromClass(userData).toJson();
    //
    await client.from("users_data").insert(jsonUserData);
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
    //
    var client = Supabase.instance.client;
    //
    await client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.recovery,
    );
    //
    await client.auth.updateUser(
      UserAttributes(password: password),
    );
    //
    return unit;
  }

  @override
  Future<TeacherData> getTeacherData() async {
    //
    var query = client.from("teachers_data").select().eq("email", client.auth.currentUser!.email!);
    //
    List res = await query;
    //
    if (res.isNotEmpty) {
      final teacherData = TeacherDataModel.fromJson(res.first);
      return teacherData;
    } else {
      throw Exception();
    }
  }

  Future<void> updateCachedUserData(UserData userData) async {
    //
    await cacheManager().write(CacheConstant.userDataKey(userData.uuid), UserDataModel.fromClass(userData).toJson());
    //
    await cacheManager().write(CacheConstant.userCreateKey(userData.uuid), DateTime.now().toString());
    //
    return;
  }

  Future<void> removeCachedUserData({UserData? userData}) async {
    //
    if (userData == null) {
      if (locator.isRegistered<UserData>()) {
        userData = locator<UserData>();
      } else {
        return;
      }
    }
    //
    await cacheManager().read(CacheConstant.userDataKey(userData.uuid));
    //
    await cacheManager().remove(CacheConstant.userCreateKey(userData.uuid));
    //
    await removeCachedPurchases();
    //
    return;
  }

  Future<void> removeCachedPurchases() async {
    //
    await cacheManager().read(CacheConstant.purchasedItemsCreateKey);
    //
    await cacheManager().remove(CacheConstant.purchasedItemsDataKey);
    //
    return;
  }

  @override
  Future<Unit> startSignInWithGoogle() async {
    //
    await removeCachedUserData();
    //
    //
    late GoogleSignIn googleSignIn;
    //
    googleSignIn = GoogleSignIn(
      clientId: "359748080763-81e9q7f7e49a9lqsi157jed7f38rht0h.apps.googleusercontent.com",
      serverClientId: "359748080763-nbkeod4kohlntuul48bvfhk620tg1sup.apps.googleusercontent.com",
      scopes: ["email", "profile"],
    );
    //
    //
    final googleUser = await googleSignIn.signIn();
    //
    if (googleUser == null) {
      Fluttertoast.showToast(msg: "error code : 327");
      throw CancelException();
    }

    final googleAuth = await googleUser.authentication;

    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      Fluttertoast.showToast(msg: "error code : 335");
      throw const UnknownException();
    }
    //
    //
    // Sign in with Supabase without nonce
    await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    //
    //
    String? uuid = client.auth.currentUser?.id;
    //
    if (uuid != null) {
      //
      //
      //
      final userData = await getUserData(uuid: uuid);
      //
      //
      //
      await updateUserData(userData: userData.copyWith(deviceId: DeviceService().deviceId));
      //
      //
      return unit;
    } else {
      //
      //
      Fluttertoast.showToast(msg: "error code : 366");
      //
      throw UnknownException();
    }
  }

  @override
  Future<Unit> signOut() async {
    try {
      final manager = locator<CacheManager>();
      await manager().remove(CacheConstant.userDataKey(locator<UserData>().uuid));
      await removeCachedPurchases();
    } catch (e) {}
    //
    try {
      await locator<SupabaseClient>().auth.signOut();
    } catch (e) {}
    //
    try {
      late GoogleSignIn googleSignIn;
      //
      if (Platform.isIOS) {
        googleSignIn = GoogleSignIn(
          clientId: "359748080763-81e9q7f7e49a9lqsi157jed7f38rht0h.apps.googleusercontent.com",
        );
      } else {
        googleSignIn = GoogleSignIn(
          serverClientId: "359748080763-nbkeod4kohlntuul48bvfhk620tg1sup.apps.googleusercontent.com",
        );
      }
      //
      await googleSignIn.signOut();
    } catch (e) {}

    try {
      if (locator.isRegistered<UserData>()) {
        await updateUserData(userData: locator<UserData>().copyWith(deviceId: ""));
      }
    } catch (e) {}
    return unit;
  }
}
