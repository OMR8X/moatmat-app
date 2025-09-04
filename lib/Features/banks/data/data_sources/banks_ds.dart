import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/banks/data/models/bank_m.dart';
import 'package:moatmat_app/Features/banks/domain/entites/bank.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/data/models/teacher_data_m.dart';
import '../../../auth/domain/entites/teacher_data.dart';

abstract class BanksDataSource {
  // material teachers
  Future<List<(String, int)>> getMaterialBankClasses({
    required String material,
  });
  // material teachers
  Future<List<(TeacherData, int)>> getMaterialBanksTeachers({
    required String clas,
    required String material,
  });
  // teacher banks
  Future<List<(Bank, int)>> getTeacherBanks({
    required String teacherEmail,
    required String clas,
    required String material,
  });
  //
  //
  Future<List<Bank>> getBanksByIds({
    required List<int> ids,
  });
  // bank by id
  Future<Bank> getBankById({required int id});
}

class BanksDataSourceImpl implements BanksDataSource {
  final SupabaseClient client;

  BanksDataSourceImpl({required this.client});
  @override
  Future<List<(String, int)>> getMaterialBankClasses({
    required String material,
  }) async {
    //
    List<String> classes = [];
    //
    var res = await client.from("banks").select("information->>classs").eq("information->>material", material).or("properties->>visible.eq.true,properties->>visible.is.null,properties.is.null");
    //
    classes = res.map<String>((e) => e["classs"]).toList();
    //
    classes.removeWhere((e) => e.isEmpty);

    return listStrToListWithCount(classes);
  }

  @override
  Future<List<(TeacherData, int)>> getMaterialBanksTeachers({
    required String clas,
    required String material,
  }) async {
    //
    List<String> teachersEmails = [];
    //
    List<TeacherData> teachers = [];

    var query1 = await client.from("banks").select("teacher_email").eq("information->>material", material).eq("information->>classs", clas).or("properties->>visible.eq.true,properties->>visible.is.null");
    //
    var res = query1;
    //
    teachersEmails = res.map<String>((e) => e["teacher_email"]).toList();
    //
    teachersEmails.removeWhere((e) => e.isEmpty);
    //
    var query2 = client
        .from("teachers_data")
        .select("")
        //x
        .inFilter("email", teachersEmails.toSet().toList());
    //
    var res2 = await query2;
    //
    teachers = res2.map((e) => TeacherDataModel.fromJson(e)).toList();
    //
    return listTeacherToListWithCount(teachers, teachersEmails);
  }

  @override
  Future<List<(Bank, int)>> getTeacherBanks({
    required String teacherEmail,
    required String clas,
    required String material,
  }) async {
    List<Bank> banks = [];
    //
    var res = await client.from("banks").select().eq("teacher_email", teacherEmail).eq("information->>material", material).eq("information->>classs", clas).or("properties->>visible.eq.true,properties->>visible.is.null,properties.is.null");
    //
    banks = res.map<Bank>((e) => BankModel.fromJson(e)).toList();
    return banksToBanksWithCount(banks);
  }

  @override
  Future<List<Bank>> getBanksByIds({
    required List<int> ids,
  }) async {
    //
    final client = Supabase.instance.client;
    //
    final res = await client.from("banks").select().inFilter("id", ids).or(
          "properties->>visible.eq.true,properties->>visible.is.null,properties.is.null",
        );

    //
    if (res.isNotEmpty) {
      final banks = res.map((e) => BankModel.fromJson(e)).toList();
      return banks;
    }
    //
    return [];
  }

  @override
  Future<Bank> getBankById({required int id}) async {
    List<Bank> banks = [];
    var res = await client.from("banks").select().eq("id", id);
    banks = res.map<Bank>((e) => BankModel.fromJson(e)).toList();
    if (banks.isEmpty) throw Exception();
    return (banks.first);
  }
}

List<(Bank, int)> banksToBanksWithCount(List<Bank> list) {
  Map<int, int> value = {};
  for (var l in list) {
    if (value[l.id] != null) {
      value[l.id] = value[l.id]! + 1;
    } else {
      value[l.id] = 1;
    }
  }
  List<(Bank, int)> res = [];
  value.forEach((key, value) {
    Bank b = list.firstWhere((e) => e.id == key);
    res.add((b, value));
  });
  return res;
}

List<(TeacherData, int)> listTeacherToListWithCount(List<TeacherData> list, List<String> teacherStr) {
  Map<String, int> value = {};
  for (var l in teacherStr) {
    if (value[l] != null) {
      value[l] = value[l]! + 1;
    } else {
      value[l] = 1;
    }
  }
  //
  List<(TeacherData, int)> res = [];
  value.forEach((key, value) {
    var t = list.where((e) => e.email == key).first;
    res.add((t, value));
  });
  return res;
}

List<(String, int)> listStrToListWithCount(List<String> list) {
  Map<String, int> value = {};
  for (var l in list) {
    if (value[l] != null) {
      value[l] = value[l]! + 1;
    } else {
      value[l] = 1;
    }
  }
  //
  List<(String, int)> res = [];
  value.forEach((key, value) {
    res.add((key, value));
  });
  return res;
}
