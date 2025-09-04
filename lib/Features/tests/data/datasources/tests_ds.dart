import 'package:flutter/foundation.dart';
import 'package:moatmat_app/Features/auth/data/models/teacher_data_m.dart';
import 'package:moatmat_app/Features/tests/data/models/test_model.dart';
import 'package:moatmat_app/Features/tests/domain/entities/mini_test.dart';
import 'package:moatmat_app/Features/tests/domain/entities/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/injection/app_inj.dart';
import '../../../../Core/services/cache/cache_manager.dart';
import '../../../../Core/services/cache/cache_constant.dart';
import '../../../auth/domain/entites/teacher_data.dart';
import '../../../auth/domain/entites/user_data.dart';
import '../../../buckets/data/datasources/local_asset_data_source.dart';
import '../../domain/entities/outer_test.dart';
import '../models/outer_test_model.dart';
import 'package:dartz/dartz.dart';

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
  //
  // Cache methods
  Future<Unit> cacheTest({required Test test});
  Future<List<Test>> getCachedTests();
  Future<Unit> clearCachedTests();
  Future<Unit> deleteCachedTest({required int testId});
}

class TestsDataSourceImpl implements TestsDataSource {
  final SupabaseClient client;
  final CacheManager cacheManager;
  final LocalAssetDataSource localAssetDataSource;

  TestsDataSourceImpl({
    required this.client,
    required this.cacheManager,
    required this.localAssetDataSource,
  });
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

  @override
  Future<Unit> cacheTest({required Test test}) async {
    try {
      // Get existing cached tests
      List<Map<dynamic, dynamic>> cachedTestsJson = [];
      if (cacheManager().exist(CacheConstant.cachedTestsDataKey)) {
        final existing = await cacheManager().read(CacheConstant.cachedTestsDataKey);
        cachedTestsJson = List<Map<dynamic, dynamic>>.from(existing ?? []);
      }

      // Check if test is already cached (prevent duplicates)
      final existingIndex = cachedTestsJson.indexWhere((cached) => cached['id'] == test.id);

      // Convert test to JSON
      final testJson = TestModel.fromClass(test).toJson();
      testJson['id'] = test.id; // Ensure ID is included

      if (existingIndex != -1) {
        // Update existing cached test
        cachedTestsJson[existingIndex] = testJson;
      } else {
        // Add new cached test
        cachedTestsJson.add(testJson);
      }

      // Save to cache
      await cacheManager().write(CacheConstant.cachedTestsDataKey, cachedTestsJson);
      await cacheManager().write(CacheConstant.cachedTestsCreateKey, DateTime.now().toString());

      return unit;
    } catch (e) {
      debugPrint("Cache test exception: $e");
      throw CacheException();
    }
  }

  @override
  Future<List<Test>> getCachedTests() async {
    try {
      // Check if cache is valid
      final isValid = await cacheManager.isValid(
        createdKey: CacheConstant.cachedTestsCreateKey,
        dataKey: CacheConstant.cachedTestsDataKey,
        duration: const Duration(days: 15),
      );

      if (!isValid) {
        throw InvalidCacheException();
      }

      // Read cached tests
      final cachedData = await cacheManager().read(CacheConstant.cachedTestsDataKey);
      if (cachedData == null) {
        return [];
      }
      // Convert JSON to Test objects
      final cachedTestsJson = List<Map<dynamic, dynamic>>.from(cachedData);
      return cachedTestsJson.map((testJson) => TestModel.fromJson(testJson)).toList();
    } on InvalidCacheException catch (e) {
      throw InvalidCacheException();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Unit> clearCachedTests() async {
    try {
      // Remove cached tests data and create keys
      await cacheManager().remove(CacheConstant.cachedTestsDataKey);
      await cacheManager().remove(CacheConstant.cachedTestsCreateKey);

      return unit;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Unit> deleteCachedTest({required int testId}) async {
    try {
      // Get existing cached tests
      List<Map<dynamic, dynamic>> cachedTestsJson = [];
      if (cacheManager().exist(CacheConstant.cachedTestsDataKey)) {
        final existing = await cacheManager().read(CacheConstant.cachedTestsDataKey);
        cachedTestsJson = List<Map<dynamic, dynamic>>.from(existing ?? []);
      }

      // Remove the test with the specified ID
      cachedTestsJson.removeWhere((test) => test['id'] == testId);

      // Save the updated list back to cache
      await cacheManager().write(CacheConstant.cachedTestsDataKey, cachedTestsJson);

      // Delete all assets associated with this test ID
      try {
        await localAssetDataSource.deleteAssetsByID(repositoryId: testId.toString());
        debugPrint("Successfully deleted assets for test ID: $testId");
      } catch (e) {
        debugPrint("Warning: Failed to delete assets for test ID $testId: $e");
        // Continue execution even if asset deletion fails
      }

      return unit;
    } catch (e) {
      debugPrint("Delete cached test exception: $e");
      throw CacheException();
    }
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
