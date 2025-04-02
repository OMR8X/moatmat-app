import 'package:moatmat_app/User/Features/banks/data/data_sources/banks_ds.dart';
import 'package:moatmat_app/User/Features/banks/data/repository/repository.dart';
import 'package:moatmat_app/User/Features/banks/domain/repository/repository.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_bank_by_id.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_banks_by_ids_uc.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_material_bank_classes_uc.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_material_banks_teacher_uc.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_teacher_banks_uc.dart';
import 'app_inj.dart';

injectBanks() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<GetBanksByIdsUC>(
    () => GetBanksByIdsUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetMaterialBankClassesUC>(
    () => GetMaterialBankClassesUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetMaterialBanksTeachersUC>(
    () => GetMaterialBanksTeachersUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetTeacherBanksUC>(
    () => GetTeacherBanksUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetBankByIdUC>(
    () => GetBankByIdUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<BanksRepository>(
    () => BanksRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<BanksDataSource>(
    () => BanksDataSourceImpl(client: locator()),
  );
}
