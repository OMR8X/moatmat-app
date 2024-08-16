import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moatmat_app/User/Core/resources/images_r.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';

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
      backgroundColor: ColorsResources.primary,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: ColorsResources.primary,
        title: const Text(
          AppBarTitles.letUsStart,
          style: TextStyle(
            color: ColorsResources.whiteText1,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            SizedBox(
              width: SpacingResources.mainHalfWidth(context),
              child: SvgPicture.asset(
                ImagesResources.appIcon,
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
                color: ColorsResources.whiteText1,
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
