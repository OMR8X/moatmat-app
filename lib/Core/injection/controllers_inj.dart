import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Features/buckets/domain/usecases/cache_asset_uc.dart';
import 'package:moatmat_app/Features/school/domain/usecases/get_schools_usecase.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/cache_test_uc.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/clear_cached_tests_uc.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/delete_cached_test_uc.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/get_cached_tests_uc.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/get_school_test_classes_uc.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/get_school_tests_teacher_uc.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/get_test_by_id.dart';
import 'package:moatmat_app/Presentation/offline/states/offline_tests_bloc.dart';
import 'package:moatmat_app/Presentation/school/state/bloc/school_tests_bloc.dart';

import '../../Presentation/tests/state/download_test/download_test_bloc.dart';

injectControllers() {
  locator.registerSingleton(
    SchoolTestsBloc(
      locator<GetSchoolUc>(),
      locator<GetSchoolTestClassesUC>(),
      locator<GetSchoolTestsTeacherUC>(),
    ),
  );

  locator.registerFactory(
    () => DownloadTestBloc(
      locator<GetTestByIdUC>(),
      locator<CacheAssetUC>(),
      locator<CacheTestUC>(),
      locator<GetCachedTestsUC>(),
      locator<DeleteCachedTestUC>(),
    ),
  );
  locator.registerFactory(
    () => OfflineTestsBloc(
      getCachedTestsUsecase: locator<GetCachedTestsUC>(),
      clearCachedTestsUsecase: locator<ClearCachedTestsUC>(),
      deleteCachedTestUsecase: locator<DeleteCachedTestUC>(),
    ),
  );
}
