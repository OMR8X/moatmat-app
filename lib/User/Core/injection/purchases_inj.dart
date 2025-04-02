import 'package:moatmat_app/User/Features/purchase/data/datasources/date_source.dart';
import 'package:moatmat_app/User/Features/purchase/data/repository/reppository.dart';
import 'package:moatmat_app/User/Features/purchase/domain/repository/repository.dart';
import 'package:moatmat_app/User/Features/purchase/domain/use_cases/get_user_purchased_uc.dart';
import 'package:moatmat_app/User/Features/purchase/domain/use_cases/pucrhase_list_of_item.dart';
import 'package:moatmat_app/User/Features/purchase/domain/use_cases/purchase_item_uc.dart';

import '../../Features/purchase/data/datasources/purchased_local_datasource.dart';
import 'app_inj.dart';

purchasesInjector() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<PurchaseItemUC>(
    () => PurchaseItemUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetUserPurchasedItemsUC>(
    () => GetUserPurchasedItemsUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<PurchaseListOfItemUC>(
    () => PurchaseListOfItemUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<PurchasesRepository>(
    () => PurchasesReporisotyrImpl(
      dataSource: locator(),
      localDatasource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<PurchasedItemsRemoteDataSource>(
    () => PurchasedItemsRemoteDataSourceImpl(client: locator(), cacheManager: locator()),
  );
  locator.registerFactory<PurchasedLocalDatasource>(
    () => PurchasedLocalDatasourceImplement(cacheManager: locator()),
  );
}
