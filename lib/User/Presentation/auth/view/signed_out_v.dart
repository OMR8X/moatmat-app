import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_app/User/Presentation/auth/state/auth_c/auth_cubit_cubit.dart';

class SignedOutView extends StatefulWidget {
  const SignedOutView({super.key, required this.state});
  final AuthSignedOut state;

  @override
  State<SignedOutView> createState() => _SignedOutViewState();
}

class _SignedOutViewState extends State<SignedOutView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      if (widget.state.forced) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 10),
            content: Text("تم تسجيل الدخول بجهاز مختلف على هذا الحساب"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم تسجيل الخروج"),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "تم تسجيل الخروج.",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.state.forced) ...[
              const SizedBox(height: SizesResources.s2),
              const Text(
                "تم تسجيل الدخول الى حسابك من جهاز اخر",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: SizesResources.s1),
              const Text(
                " سيتم حظر الحساب في حال تكرار استخدام الحساب من جهاز آخر",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButtonWidget(
          text: "الصفحة الرئيسية",
          onPressed: () {
            context.read<AuthCubit>().startAuth();
          },
        ),
      ),
    );
  }
}
