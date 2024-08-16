import 'package:moatmat_app/User/Features/tests/data/datasources/tests_ds.dart';
import 'package:moatmat_app/User/Features/tests/domain/repository/t_repository.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/can_do_test_uc.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/get_test_by_id.dart';

import '../../Features/tests/data/repository/t_repository.dart';
import '../../Features/tests/domain/usecases/get_material_test_classes_uc.dart';
import '../../Features/tests/domain/usecases/get_material_tests_teacher_uc.dart';
import '../../Features/tests/domain/usecases/get_teacher_tests_uc.dart';
import 'app_inj.dart';

injectTests() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<GetMaterialTestClassesUC>(
    () => GetMaterialTestClassesUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetMaterialTestsTeachersUC>(
    () => GetMaterialTestsTeachersUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetTeacherTestsUC>(
    () => GetTeacherTestsUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetTestByIdUC>(
    () => GetTestByIdUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<CanDoTestUC>(
    () => CanDoTestUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<TestsRepository>(
    () => TestsRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<TestsDataSource>(
    () => TestsDataSourceImpl(client: locator()),
  );
}
