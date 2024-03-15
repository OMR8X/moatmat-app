import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/result/data/models/result_m.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../tests/domain/entities/test.dart';
import '../../domain/entities/result.dart';

abstract class ResultsDataSource {
  Future<Unit> addResult({required Result result,required Test test});
  Future<List<Result>> getLatestResults();
}

class ResultsDataSourceImpl implements ResultsDataSource {
  final SupabaseClient client;

  ResultsDataSourceImpl({required this.client});
  @override
  Future<Unit> addResult({required Result result,required Test test}) async {
    Map data = ResultModel.fromClass(result).toJson();
    await client.from("results").insert(data);
    return unit;
  }

  @override
  Future<List<Result>> getLatestResults() async {
    var res = await client.from("results").select();
    List<Result> results = res.map((e) => ResultModel.fromJson(e)).toList();
    return results;
  }
}
