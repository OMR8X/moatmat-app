import 'package:moatmat_app/User/Features/banks/data/data_sources/banks_ds.dart';
import 'package:moatmat_app/User/Features/banks/data/repository/repository.dart';
import 'package:moatmat_app/User/Features/banks/domain/repository/repository.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_bank_by_id.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_material_bank_classes_uc.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_material_banks_teacher_uc.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_teacher_banks_uc.dart';
import 'package:moatmat_app/User/Features/result/data/datasources/ds.dart';
import 'package:moatmat_app/User/Features/result/data/repository/repository.dart';
import 'package:moatmat_app/User/Features/result/domain/repository/repository.dart';
import 'package:moatmat_app/User/Features/result/domain/usecases/add_result_uc.dart';
import 'package:moatmat_app/User/Features/result/domain/usecases/get_latest_results_uc.dart';
import 'package:moatmat_app/User/Features/result/domain/usecases/get_my_results_uc.dart';

import '../../Features/auth/data/data_source/users_ds.dart';
import '../../Features/auth/data/repository/users_repository_impl.dart';
import '../../Features/auth/domain/repository/users_repository.dart';
import '../../Features/auth/domain/use_cases/get_user_data.dart';
import '../../Features/auth/domain/use_cases/reset_password_uc.dart';
import '../../Features/auth/domain/use_cases/sign_in_uc.dart';
import '../../Features/auth/domain/use_cases/sign_up_uc.dart';
import '../../Features/auth/domain/use_cases/update_user_data_uc.dart';
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
    () => ResultsDataSourceImpl(client: locator()),
  );
}
