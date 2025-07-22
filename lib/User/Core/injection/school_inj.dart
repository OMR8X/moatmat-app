import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/school/data/repository/school_repository_impl.dart';
import 'package:moatmat_app/User/Features/school/domain/repository/repository.dart';

import '../../Features/school/data/datasources/school_datasource.dart';
import '../../Features/school/domain/usecases/get_schools_usecase.dart';

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
