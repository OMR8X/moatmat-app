import 'package:moatmat_app/User/Features/code/domain/use_cases/get_codes_centers_uc.dart';

import '../../Features/code/data/data_sources/codes_ds.dart';
import '../../Features/code/data/repository/codes_repository_impl.dart';
import '../../Features/code/domain/repository/codes_repository.dart';
import '../../Features/code/domain/use_cases/generate_code_uc.dart';
import '../../Features/code/domain/use_cases/scan_code_uc.dart';
import 'app_inj.dart';

codesInjector() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<UseCodeUC>(
    () => UseCodeUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GenerateCodeUC>(
    () => GenerateCodeUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetCodesCentersUC>(
    () => GetCodesCentersUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<CodesRepository>(
    () => CodesRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<CodesDataSource>(
    () => CodesDataSourceImpl(
      client: locator(),
      cacheManager: locator(),
    ),
  );
}
