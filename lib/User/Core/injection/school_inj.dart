import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/school/data/datasources/ds.dart';
import 'package:moatmat_app/User/Features/school/data/repository/repository.dart';
import 'package:moatmat_app/User/Features/school/domain/repository/repository.dart';
import 'package:moatmat_app/User/Features/school/domain/usecases/get_school_uc.dart';

injectSchool() {
  injectUC();
  injectRepo();
  injectDS();
}

void injectUC() {
  locator.registerFactory<GetSchoolUc>(
    () => GetSchoolUc(repository: locator())
  );
}

void injectRepo() {
  locator.registerFactory<SchoolRepository>(
    () => SchoolRepositoryImpl(dataSoucre: locator())
  );
}

void injectDS() {
  locator.registerFactory<SchoolDataSoucre>(
    () => SchoolDataSoucreImpl(client: locator())
  );
}
