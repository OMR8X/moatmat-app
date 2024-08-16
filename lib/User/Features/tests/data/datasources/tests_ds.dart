import 'package:flutter/foundation.dart';
import 'package:moatmat_app/User/Features/auth/data/models/teacher_data_m.dart';
import 'package:moatmat_app/User/Features/tests/data/models/test_m.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/mini_test.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../auth/domain/entites/teacher_data.dart';
import '../../../auth/domain/entites/user_data.dart';

abstract class TestsDataSource {
  // material teachers
  Future<List<(String, int)>> getMaterialTestClasses({
    required String material,
  });
  // material teachers
  Future<List<(TeacherData, int)>> getMaterialTestsTeachers({
    required String clas,
    required String material,
  });
  Future<List<(Test, int)>> getTeacherTests({
    required String teacherEmail,
    required String clas,
    required String material,
  });
  // test by id
  Future<Test> getTestById({required int id});
  //
  Future<bool> canDoTest({required MiniTest test});
}

class TestsDataSourceImpl implements TestsDataSource {
  final SupabaseClient client;

  TestsDataSourceImpl({required this.client});
  @override
  Future<List<(String, int)>> getMaterialTestClasses({
    required String material,
  }) async {
    //
    List<String> classes = [];
    //
    var query = client
//
        .from("tests")
//
        .select("information->>classs")
//
        .eq("information->>material", material)
//

        .or("properties->>visible.eq.true,properties->>visible.is.null,properties.is.null");
    //
    var res = await query;
    //
    classes = res.map<String>((e) => e["classs"]).toList();
    //
    return listStrToListWithCount(classes);
  }

  @override
  Future<List<(TeacherData, int)>> getMaterialTestsTeachers({
    required String clas,
    required String material,
  }) async {
    //
    List<String> teachersEmails = [];
    //
    List<TeacherData> teachers = [];
    //
    var query1 = client
        .from("tests")
        .select("teacher_email")
        //
        .eq("information->>material", material)
        //
        .eq("information->>classs", clas)
        //
        .or("properties->>visible.eq.true,properties->>visible.is.null,properties.is.null");

    //
    var res = await query1;
    //
    teachersEmails = res.map<String>((e) => e["teacher_email"]).toList();
    //
    teachersEmails.removeWhere((e) => e.isEmpty);
    //
    //
    var query2 = client
        .from("teachers_data")
        .select("")
        .inFilter("email", teachersEmails);
    //
    var res2 = await query2;
    //
    teachers = res2.map((e) => TeacherDataModel.fromJson(e)).toList();
    //
    return listTeacherToListWithCount(teachers, teachersEmails);
  }

  @override
  Future<List<(Test, int)>> getTeacherTests({
    required String teacherEmail,
    required String clas,
    required String material,
  }) async {
    List<Test> tests = [];
    //
    var query = client
        .from("tests")
        //
        .select()
        //
        .eq("teacher_email", teacherEmail)
        //
        .eq("information->>material", material)
        //
        .eq("information->>classs", clas)
        //
        .or("properties->>visible.eq.true,properties->>visible.is.null,properties.is.null");
    //
    var res = await query;
    //
    tests = res.map<Test>((e) => TestModel.fromJson(e)).toList();
    return testsToBanksWithCount(tests);
  }

  @override
  Future<Test> getTestById({required int id}) async {
    List<Test> tests = [];
    var res = await client.from("tests").select().eq("id", id);
    tests = res.map<Test>((e) => TestModel.fromJson(e)).toList();
    if (tests.isEmpty) throw Exception();
    return (tests.first);
  }

  @override
  Future<bool> canDoTest({required MiniTest test}) async {
    //
    debugPrint("test id is : ${test.id}");
    //
    // get all tests id that user done.
    // checks if test id in them.
    var res = await client
        .from("results")
        .select('test_id')
        .eq("user_id", locator<UserData>().uuid)
        .eq("test_id", test.id);

    if (res.isNotEmpty) {
      return true;
    }

    return false;
  }
}

List<(Test, int)> testsToBanksWithCount(List<Test> list) {
  Map<int, int> value = {};
  for (var l in list) {
    if (value[l.id] != null) {
      value[l.id] = value[l.id]! + 1;
    } else {
      value[l.id] = 1;
    }
  }
  List<(Test, int)> res = [];
  value.forEach((key, value) {
    Test b = list.firstWhere((e) => e.id == key);
    res.add((b, value));
  });
  return res;
}

List<(TeacherData, int)> listTeacherToListWithCount(
    List<TeacherData> list, List<String> teacherStr) {
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
    var t = list.where((e) => e.email == key);
    if (t.isNotEmpty) {
      res.add((t.first, value));
    }
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
