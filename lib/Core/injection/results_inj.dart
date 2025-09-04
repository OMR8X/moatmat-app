import 'package:moatmat_app/Features/result/data/datasources/ds.dart';
import 'package:moatmat_app/Features/result/data/repository/repository.dart';
import 'package:moatmat_app/Features/result/domain/repository/repository.dart';
import 'package:moatmat_app/Features/result/domain/usecases/add_result_uc.dart';
import 'package:moatmat_app/Features/result/domain/usecases/get_latest_results_uc.dart';
import 'package:moatmat_app/Features/result/domain/usecases/get_my_results_uc.dart';

import '../../Features/result/domain/usecases/get_my_repository_results_uc.dart';
import 'app_inj.dart';

injectResults() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<GetLatestResultUC>(
    () => GetLatestResultUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetMyRepositoryResultsUc>(
    () => GetMyRepositoryResultsUc(
      repository: locator(),
    ),
  );
  locator.registerFactory<AddResultUC>(
    () => AddResultUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetMyResultsUC>(
    () => GetMyResultsUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<ResultsRepository>(
    () => ResultsRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<ResultsDataSource>(
    () => ResultsDataSourceImpl(client: locator(), cacheManager: locator()),
  );
}
