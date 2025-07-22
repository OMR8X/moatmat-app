import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Presentation/auth/view/enter_user_data_view.dart';
import 'package:moatmat_app/User/Presentation/auth/view/error_v.dart';
import 'package:moatmat_app/User/Presentation/offline/views/offline_view.dart';
import 'package:moatmat_app/User/Presentation/auth/view/signed_out_v.dart';
import 'package:moatmat_app/User/Presentation/auth/view/update_view.dart';

import '../../../Core/resources/colors_r.dart';
import '../../home/view/home_v.dart';
import '../state/auth_c/auth_cubit_cubit.dart';
import 'on_boarding_v.dart';
import 'sign_in_v.dart';
import 'sign_up_v.dart';
import 'sned_reset_code_v.dart';
import 'start_auth.dart';

class AuthViewsManager extends StatefulWidget {
  const AuthViewsManager({super.key});

  @override
  State<AuthViewsManager> createState() => _AuthViewsManagerState();
}

class _AuthViewsManagerState extends State<AuthViewsManager> {
  @override
  void initState() {
    context.read<AuthCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AuthOnBoarding) {
            return const OnBoardingView();
          } else if (state is AuthStartAuth) {
            return const StartAuthView();
          } else if (state is AuthSignIn) {
            return const SignInView();
          } else if (state is AuthSignUP) {
            return const SignUpView();
          } else if (state is AuthDone) {
            return const HomeView();
          } else if (state is AuthResetPassword) {
            return const SendResetCodeView();
          } else if (state is AuthError) {
            return ErrorView(error: state.error);
          } else if (state is AuthOfflineMode) {
            return OfflineView();
          } else if (state is EnterUserData) {
            return const EnterUserDataView();
          } else if (state is AuthSignedOut) {
            return SignedOutView(state: state);
          } else if (state is AuthUpdate) {
            return UpdateView(updateInfo: state.updateInfo);
          } else {
            return const Center(
              child: CupertinoActivityIndicator(
                color: Colors.white,
              ),
            );
          }
        },
      ),
    );
  }
}
