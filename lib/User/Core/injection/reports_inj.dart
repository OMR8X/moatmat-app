import 'package:moatmat_app/User/Features/reports/data/datasources/ds.dart';
import 'package:moatmat_app/User/Features/reports/data/repository/repository.dart';
import 'package:moatmat_app/User/Features/reports/domain/repository/reports_repository.dart';
import 'package:moatmat_app/User/Features/reports/domain/usecases/get_reports_uc.dart';
import 'package:moatmat_app/User/Features/reports/domain/usecases/report_on_bank_uc.dart';
import 'package:moatmat_app/User/Features/reports/domain/usecases/report_on_test_uc.dart';

import '../../Features/auth/data/data_source/users_ds.dart';
import '../../Features/auth/data/repository/users_repository_impl.dart';
import '../../Features/auth/domain/repository/users_repository.dart';
import '../../Features/auth/domain/use_cases/get_user_data.dart';
import '../../Features/auth/domain/use_cases/reset_password_uc.dart';
import '../../Features/auth/domain/use_cases/sign_in_uc.dart';
import '../../Features/auth/domain/use_cases/sign_up_uc.dart';
import '../../Features/auth/domain/use_cases/update_user_data_uc.dart';
import 'app_inj.dart';

injectReports() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<ReportOnBankUseCase>(
    () => ReportOnBankUseCase(
      repository: locator(),
    ),
  );
  locator.registerFactory<ReportOnTestUseCase>(
    () => ReportOnTestUseCase(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetReportsUC>(
    () => GetReportsUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<ReportsRepository>(
    () => ReportRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<ReportsDataSource>(
    () => ReportsDataSourceImple(client: locator()),
  );
}
