import 'dart:convert';

import 'package:moatmat_app/User/Features/auth/data/models/user_data_m.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/services/cache/cache_constant.dart';
import '../../../../Core/services/cache/cache_manager.dart';
import '../../domain/entites/user_data.dart';

abstract class UserLocalDataSource {
  // get User Data
  Future<UserData> getUserData({
    required String uuid,
    bool force = false,
  });
}

class UserLocalDataSourceImplement implements UserLocalDataSource {
  final CacheManager cacheManager;

  UserLocalDataSourceImplement({required this.cacheManager});
  @override
  Future<UserData> getUserData({
    required String uuid,
    bool force = false,
  }) async {
    //
    final valid = await cacheManager.isValid(
      createdKey: CacheConstant.userCreateKey(uuid),
      dataKey: CacheConstant.userDataKey(uuid),
    );
    if (!valid && !force) {
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
