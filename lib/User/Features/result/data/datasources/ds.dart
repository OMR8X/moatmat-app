import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/User/Features/auth/domain/use_cases/get_user_data.dart';
import 'package:moatmat_app/User/Features/result/data/models/result_m.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../tests/domain/entities/test.dart';
import '../../domain/entities/result.dart';

abstract class ResultsDataSource {
  Future<Unit> addResult({required Result result});
  Future<List<Result>> getLatestResults();
  //
  Future<List<Result>> getMyResults();
}

class ResultsDataSourceImpl implements ResultsDataSource {
  final SupabaseClient client;

  ResultsDataSourceImpl({required this.client});
  @override
  Future<Unit> addResult({required Result result}) async {
    //
    var res = await locator<GetUserDataUC>().call(
      uuid: locator<UserData>().uuid,
    );
    //
    Map data = ResultModel.fromClass(result).toJson();
    //
    res.fold(
      (l) {
        data = ResultModel.fromClass(result).toJson();
      },
      (r) {
        result = result.copyWith(userNumber: r.id.toString());
        data = ResultModel.fromClass(result).toJson();
      },
    );
    //
    await client.from("results").insert(data);
    //
    return unit;
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
        .eq("user_id", locator<UserData>().uuid)
        .order("id");
    //
    if (res.isEmpty) return [];
    //
    List<Result> results = [];
    //
    results = res.map((e) => ResultModel.fromJson(e)).toList();
    //
    return results;
  }
}
