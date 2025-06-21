import 'package:flutter/foundation.dart';
import 'package:moatmat_app/User/Features/auth/data/models/teacher_data_m.dart';
import 'package:moatmat_app/User/Features/tests/data/models/test_m.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/mini_test.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/injection/app_inj.dart';
import '../../../auth/domain/entites/teacher_data.dart';
import '../../../auth/domain/entites/user_data.dart';
import '../../domain/entities/outer_test.dart';
import '../models/outer_test_model.dart';

abstract class TestsDataSource {
  // material teachers
  Future<List<(String, int)>> getMaterialTestClasses({
    required String material,
  });
  // material teachers
  Future<List<(String, int)>> getSchoolTestClasses({
    required String schoolId,
    required String material,
  });
  // material teachers
  Future<List<(TeacherData, int)>> getMaterialTestsTeachers({
    required String clas,
    required String material,
  });
  // schools teachers
  Future<List<(TeacherData, int)>> getSchoolTestsTeachers({
    required String clas,
    required String schoolId,
    required String material,
  });
  Future<List<(Test, int)>> getTeacherTests({
    required String teacherEmail,
    required String clas,
    required String material,
  });
  //
  // get outer test
  Future<OuterTest> getOuterTestById({required int id});
  // test by id
  Future<Test> getTestById({required int id});
  //
  Future<List<Test>> getTestsByIds({
    required List<int> ids,
    bool showHidden = false,
  });
  //
  Future<bool> canDoTest({required MiniTest test});
}

class TestsDataSourceImpl implements TestsDataSource {
  final SupabaseClient client;

  TestsDataSourceImpl({required this.client});
  @override
  Future<List<(String, int)>> getSchoolTestClasses({
    required String schoolId,
    required String material,
  }) async {
    List<String> classes = [];
    var query = client.from("tests").select("information->>classs").eq("information->>material", material).eq("information->>school_id", schoolId).or("properties->>visible.eq.true,properties->>visible.is.null,properties.is.null"); //
    var res = await query;

    classes = res.map<String>((e) => e["classs"]).toList();

    return listStrToListWithCount(classes);
  }

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
    var query1 = client.from("tests").select("teacher_email").eq("information->>material", material).eq("information->>classs", clas).or(
          "properties->>visible.eq.true,properties->>visible.is.null",
        );

    //
    var res = await query1;
    //
    teachersEmails = res.map<String>((e) => e["teacher_email"]).toList();
    //
    teachersEmails.removeWhere((e) => e.isEmpty);
    //
    var query2 = client.from("teachers_data").select("").inFilter("email", teachersEmails.toSet().toList());
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
  Future<List<Test>> getTestsByIds({
    required List<int> ids,
    bool showHidden = false,
  }) async {
    print("debugging: ${ids.contains(2197)}");
    //
    final client = Supabase.instance.client;
    //
    List<Map<String, dynamic>> res = [];
    //
    if (showHidden) {
      res = await client.from("tests").select().inFilter("id", ids);
    } else {
      res = await client.from("tests").select().inFilter("id", ids).eq("properties->>visible", "true");
    }
    //
    if (res.isNotEmpty) {
      final test = res.map((e) => TestModel.fromJson(e)).toList();
      return test;
    }
    //
    return [];
  }

  @override
  Future<bool> canDoTest({required MiniTest test}) async {
    //
    debugPrint("test id is : ${test.id}");
    //
    // get all tests id that user done.
    // checks if test id in them.
    var res = await client.from("results").select('test_id').eq("user_id", locator<UserData>().uuid).eq("test_id", test.id);

    if (res.isNotEmpty) {
      return true;
    }

    return false;
  }

  @override
  Future<OuterTest> getOuterTestById({required int id}) async {
    final response = await Supabase.instance.client.from("outer_tests").select().eq("id", id).limit(1);
    if (response.isNotEmpty) {
      final List<OuterTest> tests = response.map((e) => OuterTestModel.fromJson(e)).toList();
      return tests.first;
    }
    throw NotFoundException();
  }

  @override
  Future<List<(TeacherData, int)>> getSchoolTestsTeachers({
    required String clas,
    required String schoolId,
    required String material,
  }) async {
    List<String> teachersEmails = [];
    List<TeacherData> teachers = [];

    // Step-by-step build query1
    var query1 = client.from("tests").select("teacher_email");

    query1 = query1.eq("information->>material", material);

    query1 = query1.eq("information->>school_id", schoolId).eq("information->>classs", clas).or("properties->>visible.eq.true,properties->>visible.is.null");

    var res = await query1;

    teachersEmails = res.map<String>((e) => e["teacher_email"]).toList();
    teachersEmails.removeWhere((e) => e.isEmpty);

    var query2 = client.from("teachers_data").select("").inFilter("email", teachersEmails.toSet().toList());

    var res2 = await query2;

    teachers = res2.map((e) => TeacherDataModel.fromJson(e)).toList();

    return listTeacherToListWithCount(teachers, teachersEmails);
  }
}

List<(Test, int)> testsToBanksWithCount(List<Test> list) {
  Map<int, int> value = {};
  for (var l in list) {
    if (value[l.id] != null) {
      value[l.id] = (value[l.id]!) + 1;
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
