import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moatmat_app/User/Core/resources/images_r.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Presentation/auth/view/privacy_v.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/texts_resources.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../state/auth_c/auth_cubit_cubit.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
              text: "",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagesResources.googleIcon,
                    width: 18,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 2, right: SizesResources.s2),
                    child: Text("انشاء حساب او تسجيل دخول عن طريق غوغل"),
                  ),
                ],
              ),
              onPressed: () {
                startSignInWithGoogle();
              },
            ),
            const SizedBox(height: SizesResources.s2),
            ElevatedButtonWidget(
              text: TextsResources.signIn,
              onPressed: startSignIn,
            ),
            // const SizedBox(height: SizesResources.s2),
            // ElevatedButtonWidget(
            //   text: TextsResources.signUp,
            //   onPressed: startSignUp,
            //   isWhite: true,
            // ),
            const SizedBox(height: SizesResources.s2),
            RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontSize: 10,
                  ),
                  text: "عند الدخول للتطبيق ، انت توافق على ",
                  children: [
                    TextSpan(
                      style: TextStyle(
                        color: Colors.cyan,
                        fontFamily: "Tajawal",
                      ),
                      text: "شروط الاستخدام وسياسة الخصوصية",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PrivacyView(),
                            ),
                          );
                        },
                    ),
                  ]),
            ),
            const SizedBox(height: SizesResources.s10),
          ],
        ),
      ),
    );
  }

  void startSignInWithGoogle() {
    context.read<AuthCubit>().startSignInWithGoogle();
  }

  void startSignIn() {
    context.read<AuthCubit>().startSignIn();
  }

  void startSignUp() {
    context.read<AuthCubit>().startSignUp();
  }
}
