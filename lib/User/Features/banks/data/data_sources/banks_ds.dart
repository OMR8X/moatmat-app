import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/banks/data/models/bank_m.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BanksDataSource {
  // material teachers
  Future<List<(String, int)>> getMaterialBankClasses({
    required String material,
  });
  // material teachers
  Future<List<(String, int)>> getMaterialBanksTeachers({
    required String clas,
    required String material,
  });
  // teacher banks
  Future<List<(Bank, int)>> getTeacherBanks({
    required String teacher,
    required String clas,
    required String material,
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
    var res = await client.from("banks").select("information->>classs").eq(
          "information->>material",
          material,
        );
    //
    classes = res.map<String>((e) => e["classs"]).toList();
    //
    classes.removeWhere((e) => e.isEmpty);

    return listToListWithCount(classes);
  }

  @override
  Future<List<(String, int)>> getMaterialBanksTeachers({
    required String clas,
    required String material,
  }) async {
    //
    List<String> teachers = [];
    //

    var res = await client
        .from("banks")
        .select("information->>teacher")
        .eq("information->>material", material)
        .eq("information->>classs", clas);
    //
    teachers = res.map<String>((e) => e["teacher"]).toList();
    //
    teachers.removeWhere((e) => e.isEmpty);
    //
    return listToListWithCount(teachers);
  }

  @override
  Future<List<(Bank, int)>> getTeacherBanks({
    required String teacher,
    required String clas,
    required String material,
  }) async {
    List<Bank> banks = [];
    //
    var res = await client
        .from("banks")
        .select()
        .eq("information->>teacher", teacher)
        .eq("information->>material", material)
        .eq("information->>classs", clas);
    //
    banks = res.map<Bank>((e) => BankModel.fromJson(e)).toList();
    return banksToBanksWithCount(banks);
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

List<(String, int)> listToListWithCount(List<String> list) {
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
