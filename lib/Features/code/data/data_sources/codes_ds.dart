import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Features/auth/domain/use_cases/get_user_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/injection/app_inj.dart';
import '../../../../Core/services/cache/cache_constant.dart';
import '../../../../Core/services/cache/cache_manager.dart';
import '../../../auth/data/models/user_data_m.dart';
import '../../../auth/domain/entites/user_data.dart';
import '../../../auth/domain/use_cases/update_user_data_uc.dart';
import '../../domain/entites/code_center.dart';
import '../../domain/entites/code_data.dart';
import '../models/code_center_m.dart';
import '../models/code_data_model.dart';

abstract class CodesDataSource {
  Future<Unit> scanCode({required String code});
  Future<CodeData> generateCode({required int amount});
  Future<List<CodeCenter>> getCodesCenters({
    required String governorate,
  });
}

class CodesDataSourceImpl implements CodesDataSource {
  final SupabaseClient client;
  final CacheManager cacheManager;

  CodesDataSourceImpl({required this.client, required this.cacheManager});
  @override
  Future<Unit> scanCode({required String code}) async {
    var response = await Supabase.instance.client.rpc("use_code", params: {
      "code_key": code,
      "user_email_key": locator<UserData>().email,
    });

    //
    try {
      //
      if (response["status"]) {
        //
        final userData = UserDataModel.fromJson(response["user_data"]);
        //
        await removeCachedUserData();
        //
        updateCachedUserData(userData);
        //
        await locator.unregister<UserData>();
        //
        locator.registerFactory<UserData>(() => userData);
        //
        return unit;
      } else {
        throw CodesUsedException();
      }
    } on Exception {
      rethrow;
    }
  }

  Future<void> increaseBalance(int amount) async {
    //
    var userData = locator<UserData>();
    //
    userData = userData.copyWith(balance: userData.balance + amount);
    //
    await locator<UpdateUserDataUC>().call(userData: userData);
    //
    return;
  }

  @override
  Future<CodeData> generateCode({required int amount}) async {
    var codeData = CodeDataModel(
      id: "",
      amount: amount,
      used: false,
      check1: null,
      check2: null,
    );
    var query = client.from("codes");
    var res = await query.insert(codeData.toJson()).select();
    codeData = CodeDataModel.fromJson(res.first);
    return codeData;
  }

  @override
  Future<List<CodeCenter>> getCodesCenters({
    required String governorate,
  }) async {
    //
    final client = Supabase.instance.client;
    //
    var res = await client.from("centers").select().or("governorate.eq.$governorate,governorate.is.null");
    //
    if (res.isEmpty) return [];
    //
    List<CodeCenter> centers = res.map((e) {
      return CodeCenterModel.fromJson(e);
    }).toList();
    //
    return centers;
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
    return;
  }

  Future<void> updateCachedUserData(UserData userData) async {
    //
    await cacheManager().write(CacheConstant.userDataKey(userData.uuid), UserDataModel.fromClass(userData).toJson());
    //
    await cacheManager().write(CacheConstant.userCreateKey(userData.uuid), DateTime.now().toString());
    //
    return;
  }
}
