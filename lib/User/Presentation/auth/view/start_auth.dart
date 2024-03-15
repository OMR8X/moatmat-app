import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/texts_resources.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../state/auth_c/auth_cubit_cubit.dart';

class StartAuthView extends StatefulWidget {
  const StartAuthView({super.key});

  @override
  State<StartAuthView> createState() => _StartAuthViewState();
}

class _StartAuthViewState extends State<StartAuthView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.startAuth),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            const CircleAvatar(
              radius: 100,
              backgroundColor: ColorsResources.borders,
              child: Text(
                "ايقونة التطبيق",
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            const SizedBox(height: SizesResources.s2),
            ElevatedButtonWidget(
              text: TextsResources.signIn,
              onPressed: startSignIn,
            ),
            const SizedBox(height: SizesResources.s2),
            ElevatedButtonWidget(
              text: TextsResources.signUp,
              onPressed: startSignUp,
              isWhite: true,
            ),
            const SizedBox(height: SizesResources.s2),
            const Text(
              "قم ب${TextsResources.signIn} او ${TextsResources.signUp} من اجل ${AppBarTitles.startAuth}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: ColorsResources.blackText2,
              ),
            ),
            const SizedBox(height: SizesResources.s10),
          ],
        ),
      ),
    );
  }

  void startSignIn() {
    context.read<AuthCubit>().startSignIn();
  }

  void startSignUp() {
    context.read<AuthCubit>().startSignUp();
  }
}
