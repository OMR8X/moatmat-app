import 'package:moatmat_app/User/Features/tests/data/models/test_m.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class TestsDataSource {
  // material teachers
  Future<List<(String, int)>> getMaterialTestClasses({
    required String material,
  });
  // material teachers
  Future<List<(String, int)>> getMaterialTestsTeachers({
    required String clas,
    required String material,
  });
  Future<List<(Test, int)>> getTeacherTests({
    required String teacher,
    required String clas,
    required String material,
  });
  // test by id
  Future<Test> getTestById({required int id});
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
    var res = await client.from("tests").select("class").eq(
          "material",
          material,
        );
    //
    classes = res.map<String>((e) => e["class"]).toList();
    //
    classes.removeWhere((e) => e.isEmpty);

    return listToListWithCount(classes);
  }

  @override
  Future<List<(String, int)>> getMaterialTestsTeachers({
    required String clas,
    required String material,
  }) async {
    //
    List<String> teachers = [];
    //

    var res = await client
        .from("tests")
        .select("teacher")
        .eq("material", material)
        .eq("class", clas);
    //
    teachers = res.map<String>((e) => e["teacher"]).toList();
    //
    teachers.removeWhere((e) => e.isEmpty);
    //
    return listToListWithCount(teachers);
  }

  @override
  Future<List<(Test, int)>> getTeacherTests({
    required String teacher,
    required String clas,
    required String material,
  }) async {
    List<Test> tests = [];
    //
    var res = await client
        .from("tests")
        .select()
        .eq("teacher", teacher)
        .eq("material", material)
        .eq("class", clas);
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
