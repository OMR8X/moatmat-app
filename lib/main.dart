import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/services/device_s.dart';

import 'package:moatmat_app/User/Presentation/app_root.dart';
import 'package:moatmat_app/User/Presentation/banks/state/full_time_explore/full_time_explore_cubit.dart';
import 'package:moatmat_app/User/Presentation/banks/state/get_bank_c/get_bank_cubit.dart';
import 'package:moatmat_app/User/Presentation/banks/state/no_time_explore/no_time_explore_cubit.dart';
import 'package:moatmat_app/User/Presentation/banks/state/per_question_explore/per_question_explore_cubit.dart';
import 'package:moatmat_app/User/Presentation/home/state/cubit/notifications_cubit.dart';
import 'package:moatmat_app/User/Presentation/tests/state/get_test_c/get_test_cubit.dart';
import 'package:no_screenshot/no_screenshot.dart';

import 'User/Core/debug/bloc_observer.dart';
import 'User/Core/injection/app_inj.dart';
import 'User/Core/services/cache/cache_manager.dart';
import 'User/Core/services/supabase_s.dart';
import 'User/Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import 'User/Presentation/code/state/centers/codes_centers_cubit.dart';
import 'User/Presentation/code/state/codes_c/codes_cubit.dart';
import 'User/Presentation/folders/state/cubit/folders_manager_cubit.dart';
import 'User/Presentation/results/state/results/my_results_cubit.dart';
import 'User/Presentation/tests/state/full_time_explore/full_time_explore_cubit.dart';
import 'User/Presentation/tests/state/no_time_explore/no_time_explore_cubit.dart';
import 'User/Presentation/tests/state/per_question_explore/per_question_explore_cubit.dart';
import 'firebase_options.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  //
  await SupabaseServices.init();
  //
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //
  await initGetIt();
  //
  await DeviceService().init();
  //
  /// init app cache
  await locator<CacheManager>().init();
  //
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // bloc observer -> for debugging only
  if (kDebugMode) {
    Bloc.observer = MyBlocObserver();
  }
  // if (!kDebugMode) {
  await NoScreenshot.instance.screenshotOff();
  // }
  //
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => CodesCubit()),
        BlocProvider(create: (context) => FoldersManagerCubit()),
        BlocProvider(create: (context) => GetBankCubit()),
        BlocProvider(create: (context) => NoTimeExploreCubit()),
        BlocProvider(create: (context) => PerQuestionExploreCubit()),
        BlocProvider(create: (context) => FullTimeExploreCubit()),
        BlocProvider(create: (context) => TestNoTimeExploreCubit()),
        BlocProvider(create: (context) => TestPerQuestionExploreCubit()),
        BlocProvider(create: (context) => TestFullTimeExploreCubit()),
        BlocProvider(create: (context) => GetTestCubit()),
        BlocProvider(create: (context) => NotificationsCubit()),
        BlocProvider(create: (context) => CodesCentersCubit()),
        BlocProvider(create: (context) => MyResultsCubit()),
      ],
      child: const AppRoot(),
    ),
  );
}
/*
---

org.gradle.configuration-cache=false

---

flutter clean
rm -rf android/.gradle
rm -rf android/build
rm -rf build
flutter pub get

# 4. Rebuild the project
cd android
./gradlew clean
./gradlew build

flutter build apk --release
*/