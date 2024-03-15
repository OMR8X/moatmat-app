import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/injection/app_inj.dart';
import '../../../auth/domain/entites/user_data.dart';
import '../../domain/entites/code_data.dart';
import '../models/code_data_model.dart';

abstract class CodesDataSource {
  Future<Unit> scanCode({required String code});
  Future<CodeData> generateCode({required int amount});
}

class CodesDataSourceImpl implements CodesDataSource {
  final SupabaseClient client;

  CodesDataSourceImpl({required this.client});
  @override
  Future<Unit> scanCode({required String code}) async {
    //
    await client.auth.updateUser(
      UserAttributes(
        data: {"code": code},
      ),
    );
    //
    await client.auth.refreshSession();
    //
    // do check 1
    await doCheck(code: code, key: "check1");
    //
    // get data and do check 1
    var res = await client.from("codes").select().eq("id", code);
    if (res.isNotEmpty) {
      //
      final codeData = CodeDataModel.fromJson(res.first);
      //
      if (codeData.used == true) throw CodesUsedException();
      //
      await increaseBalance(codeData);
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
    var query = client.from("users_data");
    await query.update({"balance": userData.balance}).eq("uuid", userData.uuid);
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
}
/*
((((auth.jwt() -> 'user_metadata'::text) ->> 'code'::text) = (id)::text)
OR
(((auth.jwt() -> 'user_metadata'::text) ->> 'code'::text) = (id)::text))
*/