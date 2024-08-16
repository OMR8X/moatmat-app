import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/User/Features/reports/data/models/report_d_m.dart';
import 'package:moatmat_app/User/Features/reports/domain/entities/reposrt_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../banks/domain/entites/bank.dart';
import '../../../tests/domain/entities/test.dart';

abstract class ReportsDataSource {
  Future<Unit> reportOnTest({
    required String message,
    required String teacher,
    required String name,
    required int testID,
    required int questionID,
  });
  Future<Unit> reportOnBank({
    required String message,
    required String teacher,
    required String name,
    required int bankID,
    required int questionID,
  });
  Future<List<ReportData>> getReports();
}

class ReportsDataSourceImple implements ReportsDataSource {
  final SupabaseClient client;

  ReportsDataSourceImple({required this.client});

  @override
  Future<Unit> reportOnBank({
    required String message,
    required String teacher,
    required String name,
    required int bankID,
    required int questionID,
  }) async {
    ReportData report = ReportData(
      id: 0,
      message: message,
      userName: locator<UserData>().name,
      questionID: questionID,
      testId: null,
      bankId: bankID,
      name: name,
      teacher: teacher,
    );
    var data = ReportDataModel.fromClass(report).toJson(); 
    await client.from("reports").insert(data);
    return unit;
  }

  @override
  Future<Unit> reportOnTest({
    required String message,
    required String teacher,
    required String name,
    required int testID,
    required int questionID,
  }) async {
    ReportData report = ReportData(
      id: 0,
      message: message,
      userName: locator<UserData>().name,
      questionID: questionID,
      testId: testID,
      bankId: null,
      name: name,
      teacher: teacher,
    );
    var data = ReportDataModel.fromClass(report).toJson();
    await client.from("reports").insert(data);
    return unit;
  }

  @override
  Future<List<ReportData>> getReports() async {
    var res = await client.from("reports").select();
    List<ReportData> reports = [];
    reports = res.map((e) => ReportDataModel.fromJson(e)).toList();
    return reports;
  }
}
