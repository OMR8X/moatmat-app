import 'package:moatmat_app/User/Core/injection/app_inj.dart';

import '../services/cache/cache_manager.dart';

injectCache() {
  locator.registerLazySingleton<CacheManager>(() => CacheManager());
}
