import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Core/services/device_s.dart';
import 'package:moatmat_app/Features/notifications/domain/usecases/initialize_firebase_notifications_usecase.dart';
import 'package:moatmat_app/Features/notifications/domain/usecases/initialize_local_notifications_usecase.dart';

import 'package:moatmat_app/Presentation/app_root.dart';
import 'package:moatmat_app/Presentation/banks/state/full_time_explore/full_time_explore_cubit.dart';
import 'package:moatmat_app/Presentation/banks/state/get_bank_c/get_bank_cubit.dart';
import 'package:moatmat_app/Presentation/banks/state/no_time_explore/no_time_explore_cubit.dart';
import 'package:moatmat_app/Presentation/banks/state/per_question_explore/per_question_explore_cubit.dart';
import 'package:moatmat_app/Presentation/notifications/state/initialize_notifications_cubit/initialize_notifications_cubit.dart';
import 'package:moatmat_app/Presentation/notifications/state/notifications_bloc/notifications_bloc.dart';
import 'package:moatmat_app/Presentation/tests/state/get_test_c/get_test_cubit.dart';
import 'package:no_screenshot/no_screenshot.dart';

import 'Core/debug/bloc_observer.dart';
import 'Core/injection/app_inj.dart';
import 'Core/services/cache/cache_manager.dart';
import 'Core/services/supabase_s.dart';
import 'Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import 'Presentation/code/state/centers/codes_centers_cubit.dart';
import 'Presentation/code/state/codes_c/codes_cubit.dart';
import 'Presentation/folders/state/cubit/folders_manager_cubit.dart';
import 'Presentation/results/state/results/my_results_cubit.dart';
import 'Presentation/tests/state/full_time_explore/full_time_explore_cubit.dart';
import 'Presentation/tests/state/no_time_explore/no_time_explore_cubit.dart';
import 'Presentation/tests/state/per_question_explore/per_question_explore_cubit.dart';
import 'Presentation/school/state/cubit/school_cubit.dart';
import 'firebase_options.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  //
  try {
    //
    await SupabaseServices.init();
    //
    await initGetIt();
    //
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //
    await DeviceService().init();

    /// init app cache
    await locator<CacheManager>().init();
    //
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    //
    // bloc observer -> for debugging only
    if (kDebugMode) {
      Bloc.observer = MyBlocObserver();
    }
    // if (!kDebugMode) {
    await NoScreenshot.instance.screenshotOff();
  } on Exception catch (e, stackTrace) {
    final String errorDump = 'Exception: $e\n$stackTrace';
    await Clipboard.setData(ClipboardData(text: errorDump));
    debugPrint("error: $e");
  }
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
        BlocProvider(create: (context) => CodesCentersCubit()),
        BlocProvider(create: (context) => MyResultsCubit()),
        BlocProvider(create: (context) => SchoolCubit()),
        BlocProvider(create: (context) => locator<InitializeNotificationsCubit>()..initialize()),
        BlocProvider(create: (context) => locator<NotificationsBloc>()),
      ],
      child: const AppRoot(),
    ),
  );
  debugPrint("app root initialized");
}
