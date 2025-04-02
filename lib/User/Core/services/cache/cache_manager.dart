
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/services/cache/cache_constant.dart';
import 'package:moatmat_app/User/Features/result/data/models/result_m.dart';
import 'package:moatmat_app/User/Features/result/domain/usecases/add_result_uc.dart';
import 'package:path_provider/path_provider.dart';

import 'cache_client.dart';

/// callable class
class CacheManager {
  late CacheClient _cacheClient;

  /// initiate cache clients
  Future<void> init() async {
    //
    _cacheClient = HiveClient();
    //
    await _cacheClient.init(await getApplicationDocumentsDirectory());
    //
  }

  Future<void> uploadResults() async {
    //
    final List results = await _cacheClient.read(CacheConstant.resultsKey) ?? [];
    //
    await _cacheClient.remove(CacheConstant.resultsKey);
    //
    for (var result in results) {
      await locator<AddResultUC>().call(result: ResultModel.fromJson(result));
    }
    //
  }

  /// return cache client instance
  CacheClient call() {
    return _cacheClient;
  }

  /// check if cache is valid and exists
  Future<bool> isValid(String createdKey, String dataKey) async {
    //
    if(kDebugMode){
      return false;
    }
    //
    bool createdDateExisted = _cacheClient.exist(createdKey);
    bool dataExisted = _cacheClient.exist(dataKey);
    //
    if (!createdDateExisted || !dataExisted) {
      return false;
    }
    //
    DateTime now = DateTime.now();
    DateTime then = DateTime.parse(await _cacheClient.read(createdKey));
    //
    if (now.difference(then).inSeconds > CacheConstant.cacheValidSeconds) {
      debugPrint("not valid");
      return false;
    }
    return dataExisted && createdDateExisted;
  }
}
