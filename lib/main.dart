import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:moatmat_app/User/Presentation/app_root.dart';
import 'package:moatmat_app/User/Presentation/banks/state/full_time_explore/full_time_explore_cubit.dart';
import 'package:moatmat_app/User/Presentation/banks/state/get_bank_c/get_bank_cubit.dart';
import 'package:moatmat_app/User/Presentation/banks/state/no_time_explore/no_time_explore_cubit.dart';
import 'package:moatmat_app/User/Presentation/banks/state/per_question_explore/per_question_explore_cubit.dart';
import 'package:moatmat_app/User/Presentation/home/state/cubit/notifications_cubit.dart';
import 'package:moatmat_app/User/Presentation/tests/state/get_test_c/get_test_cubit.dart';

import 'User/Core/injection/app_inj.dart';
import 'User/Core/services/supabase_s.dart';
import 'User/Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import 'User/Presentation/code/state/codes_c/codes_cubit.dart';
import 'User/Presentation/tests/state/full_time_explore/full_time_explore_cubit.dart';
import 'User/Presentation/tests/state/no_time_explore/no_time_explore_cubit.dart';
import 'User/Presentation/tests/state/per_question_explore/per_question_explore_cubit.dart';

void main() async {
  //
  //
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseServices.init();
  await Firebase.initializeApp();
  await initGetIt();
  FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => CodesCubit()),
        BlocProvider(create: (context) => GetBankCubit()),
        BlocProvider(create: (context) => NoTimeExploreCubit()),
        BlocProvider(create: (context) => PerQuestionExploreCubit()),
        BlocProvider(create: (context) => FullTimeExploreCubit()),
        BlocProvider(create: (context) => TestNoTimeExploreCubit()),
        BlocProvider(create: (context) => TestPerQuestionExploreCubit()),
        BlocProvider(create: (context) => TestFullTimeExploreCubit()),
        BlocProvider(create: (context) => GetTestCubit()),
        BlocProvider(create: (context) => NotificationsCubit()),
      ],
      child: const AppRoot(),
    ),
  );
}
