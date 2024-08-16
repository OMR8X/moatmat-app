import 'package:moatmat_app/User/Features/update/domain/repository/update_repository.dart';
import 'package:moatmat_app/User/Features/update/domain/usecases/check_update_state_uc.dart';

import '../../Features/update/data/datasources/update_remote_ds.dart';
import '../../Features/update/data/repository/update_repository_impl.dart';
import 'app_inj.dart';

injectUpdate() {
  injectUC();
  injectRepo();
  injectDS();
}

void injectUC() {
  locator.registerFactory<CheckUpdateStateUC>(
    () => CheckUpdateStateUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<UpdateRepository>(
    () => UpdateRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<UpdateRemoteDS>(
    () => UpdateRemoteDSImpl(),
  );
}
