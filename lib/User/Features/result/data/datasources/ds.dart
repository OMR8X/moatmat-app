import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/services/cache/cache_constant.dart';
import 'package:moatmat_app/User/Core/services/cache/cache_manager.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/User/Features/auth/domain/use_cases/get_user_data.dart';
import 'package:moatmat_app/User/Features/result/data/models/result_m.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/result.dart';

abstract class ResultsDataSource {
  Future<Unit> addResult({required Result result});
  Future<List<Result>> getLatestResults();
  //
  Future<List<Result>> getMyResults();
  Future<List<Result>> getMyRepositoryResults({int? testId, int? bankId});
}

class ResultsDataSourceImpl implements ResultsDataSource {
  final CacheManager cacheManager;
  final SupabaseClient client;

  ResultsDataSourceImpl({
    required this.client,
    required this.cacheManager,
  });
  @override
  Future<Unit> addResult({required Result result}) async {
    //
    var res = await locator<GetUserDataUC>().call(
      uuid: locator<UserData>().uuid,
    );
    //
    await res.fold(
      (l) async {
        debugPrint("getting exception while getting user data");
        await addToOtherResults(result);
      },
      (r) async {
        result = result.copyWith(userNumber: r.id.toString());
        Map resultJson = ResultModel.fromClass(result).toJson(); //
        try {
          await client.from("results").insert(resultJson);
        } on Exception {
          debugPrint("getting exception while uploading result");
          await addToOtherResults(result);
        }
      },
    );
    //
    return unit;
  }

  ///
  Future<void> addToOtherResults(Result result) async {
    List resultsJson = [];
    if (cacheManager().exist(CacheConstant.resultsKey)) {
      resultsJson = await cacheManager().read(CacheConstant.resultsKey);
    }
    resultsJson.add(ResultModel.fromClass(result).toJson(addId: true));
    await cacheManager().write(CacheConstant.resultsKey, resultsJson);
    debugPrint("done caching result");
  }

  @override
  Future<List<Result>> getLatestResults() async {
    var res = await client.from("results").select();
    List<Result> results = res.map((e) => ResultModel.fromJson(e)).toList();
    return results;
  }

  @override
  Future<List<Result>> getMyResults() async {
    //
    var res = await client
        .from("results")
        .select()
        .or(
          "user_id.eq.${locator<UserData>().uuid},user_number.eq.${locator<UserData>().id}",
        )
        .order("id");
    //
    List<Result> results = [];
    //
    results = res.map((e) => ResultModel.fromJson(e)).toList();
    //
    return results;
  }

  @override
  Future<List<Result>> getMyRepositoryResults({int? testId, int? bankId}) async {
    //
    List<Map<String, dynamic>> res = [];
    //
    if (testId != null) {
      res = await client
          .from("results")
          .select()
          .eq("test_id", testId)
          .or(
            "user_id.eq.${locator<UserData>().uuid},user_number.eq.${locator<UserData>().id}",
          )
          .order("id");
      //
    } else if (bankId != null) {
      res = await client
          .from("results")
          .select()
          .eq("bank_id", bankId)
          .or(
            "user_id.eq.${locator<UserData>().uuid},user_number.eq.${locator<UserData>().id}",
          )
          .order("id");
      //
    }
    //
    List<Result> results = [];
    //
    results = res.map((e) => ResultModel.fromJson(e)).toList();
    //
    return results;
  }
}
