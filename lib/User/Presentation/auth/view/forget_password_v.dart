import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Presentation/auth/view/auth_views_manager.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/texts_resources.dart';
import '../../../Core/validators/not_empty_v.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../../../Core/widgets/fields/text_input_field.dart';
import '../../../Features/auth/domain/use_cases/reset_password_uc.dart';
import '../state/auth_c/auth_cubit_cubit.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key, required this.email});
  final String email;
  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  String? token;
  String? password;
  resetPassword() async {
    setState(() {
      loading = true;
    });
    await locator<ResetPasswordUC>()
        .call(email: widget.email, password: password!, token: token!)
        .then((value) {
      value.fold(
        (l) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.text),
            ),
          );
          setState(() {
            loading = false;
          });
        },
        (r) {
          //
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم تغيير كلمة المرور بنجاح حساب بنجاح"),
            ),
          );
          //
          context.read<AuthCubit>().init();
          //
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const AuthViewsManager(),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.forgetPassword),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AuthViewsManager(),
                ),
              );
            },
            icon: const Icon(Icons.close)),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: SizesResources.s2),
            MyTextFormFieldWidget(
              hintText: "رمز التحقق",
              validator: (text) {
                return notEmptyValidator(text: text);
              },
              onSaved: (p0) {
                token = p0;
              },
            ),
            const SizedBox(height: SizesResources.s2),
            MyTextFormFieldWidget(
              hintText: "كلمة المرور الجديدة",
              validator: (text) {
                return notEmptyValidator(text: text);
              },
              onSaved: (p0) {
                password = p0;
              },
            ),
            const SizedBox(height: SizesResources.s4),
            ElevatedButtonWidget(
              text: "تغيير كلمة السر",
              loading: loading,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  resetPassword();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
