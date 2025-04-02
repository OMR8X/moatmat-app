import 'dart:convert';

import 'package:moatmat_app/User/Features/auth/data/models/user_data_m.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/services/cache/cache_constant.dart';
import '../../../../Core/services/cache/cache_manager.dart';
import '../../domain/entites/user_data.dart';

abstract class UserLocalDataSource {
  // get User Data
  Future<UserData> getUserData({required String uuid});
}

class UserLocalDataSourceImplement implements UserLocalDataSource {
  final CacheManager cacheManager;

  UserLocalDataSourceImplement({required this.cacheManager});
  @override
  Future<UserData> getUserData({required String uuid}) async {
    //
    final valid = await cacheManager.isValid(
      CacheConstant.userCreateKey(uuid),
      CacheConstant.userDataKey(uuid),
    );
    if (!valid) {
      throw CacheException();
    }
    //
    final data = await cacheManager().read(CacheConstant.userDataKey(uuid));
    //
    if (data == null) {
      throw CacheException();
    }
    //
    final UserData userData = UserDataModel.fromJson(data);
    //
    return userData;
  }
}
