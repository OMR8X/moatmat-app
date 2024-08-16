import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/injection/app_inj.dart';
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

  CodesDataSourceImpl({required this.client});
  @override
  Future<Unit> scanCode({required String code}) async {
    //
    final data = client.auth.currentUser?.userMetadata ?? {};
    //
    data["code"] = code;
    //
    await client.auth.updateUser(
      UserAttributes(
        data: data,
      ),
    );
    //
    await client.auth.refreshSession();
    //
    print(await client.auth.currentUser?.userMetadata?["code"]);
    //
    // do check 1
    await doCheck(code: code, key: "check1");
    //
    // get data and do check 1
    var res = await client.from("codes").select().eq("id", code);
    //
    if (res.isNotEmpty) {
      //
      final codeData = CodeDataModel.fromJson(res.first);
      //
      if (codeData.used == true && codeData.check2 != null) {
        throw CodesUsedException();
      }
      //
      print("before is ${locator<UserData>().balance}");
      await increaseBalance(codeData);

      //
      //
      // do check 2
      await doCheck(code: code, key: "check2", used: true);
    }
    return unit;
  }

  Future<void> doCheck({
    required String code,
    required String key,
    bool? used,
  }) async {
    Map json = {key: DateTime.now().toString()};
    if (used == true) {
      json["used"] = true;
    }
    var query = client.from("codes");
    await query.update(json).eq("id", code);
  }

  Future<void> increaseBalance(CodeData codeData) async {
    //
    var userData = locator<UserData>();
    //
    userData = userData.copyWith(balance: userData.balance + codeData.amount);
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
    var res = await client
        .from("centers")
        .select()
        .or("governorate.eq.$governorate,governorate.is.null");
    //
    if (res.isEmpty) return [];
    //
    List<CodeCenter> centers = res.map((e) {
      return CodeCenterModel.fromJson(e);
    }).toList();
    //
    return centers;
  }
}
