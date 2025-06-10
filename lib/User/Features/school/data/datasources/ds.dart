import 'package:moatmat_app/User/Features/school/data/models/school_m.dart';
import 'package:moatmat_app/User/Features/school/domain/entities/school.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SchoolDataSoucre {
  Future<List<School>> getSchool();
}

class SchoolDataSoucreImpl extends SchoolDataSoucre {
  final SupabaseClient client;

  SchoolDataSoucreImpl({required this.client});

  @override
  Future<List<School>> getSchool() async {
    var res = await client.from("schools").select();
    //
    List<School> schools = [];
    //
    schools = res.map((e) => SchoolModel.fromJson(e)).toList();
    //
    return schools;
  }
}
