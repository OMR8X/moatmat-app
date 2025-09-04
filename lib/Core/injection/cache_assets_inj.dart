import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Core/services/api/api_manager.dart';
import 'package:moatmat_app/Core/services/cache/cache_manager.dart';
import 'package:moatmat_app/Features/buckets/data/datasources/local_asset_data_source.dart';
import 'package:moatmat_app/Features/buckets/data/datasources/remote_asset_data_source.dart';
import 'package:moatmat_app/Features/buckets/data/repository/asset_cache_repository_impl.dart';
import 'package:moatmat_app/Features/buckets/domain/usecases/cache_asset_uc.dart';
import 'package:moatmat_app/Features/buckets/domain/usecases/clear_cache_uc.dart';
import 'package:moatmat_app/Features/buckets/domain/usecases/retrieve_asset_uc.dart';
import 'package:path_provider/path_provider.dart';

import '../../Features/buckets/domain/repository/asset_cache_repository.dart';

Future<void> injectCacheAssets() async {
  await injectDS();
  await injectUC();
  await injectRepo();
}

Future<void> injectUC() async {
  locator.registerFactory<CacheAssetUC>(
    () => CacheAssetUC(
      repository: locator<AssetCacheRepository>(),
    ),
  );
  locator.registerFactory<RetrieveAssetUC>(
    () => RetrieveAssetUC(
      repository: locator<AssetCacheRepository>(),
    ),
  );
  locator.registerFactory<ClearCacheUC>(
    () => ClearCacheUC(
      repository: locator<AssetCacheRepository>(),
    ),
  );
  // locator.registerFactory<GetMaterialBankClassesUC>(
  //   () => GetMaterialBankClassesUC(
  //     repository: locator(),
  //   ),
  // );
}

Future<void> injectRepo() async {
  locator.registerFactory<AssetCacheRepository>(
    () => AssetCacheRepositoryImpl(
      localDataSource: locator<LocalAssetDataSource>(),
      remoteDataSource: locator<RemoteAssetDataSource>(),
    ),
  );
}

Future<void> injectDS() async {
  final appDir = await getApplicationDocumentsDirectory();

  locator.registerFactory<LocalAssetDataSource>(
    () => LocalAssetDataSourceImpl(
      cacheDirectoryPath: appDir,
      cacheManager: locator<CacheManager>(),
    ),
  );
  locator.registerFactory<RemoteAssetDataSource>(
    () => RemoteAssetDataSourceImpl(
      manager: locator<ApiManager>(),
    ),
  );
}
