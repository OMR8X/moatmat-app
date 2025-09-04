import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/texts_resources.dart';
import '../../../Core/validators/not_empty_v.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../../../Core/widgets/fields/text_input_field.dart';
import '../state/auth_c/auth_cubit_cubit.dart';
import 'forget_password_v.dart';

class SendResetCodeView extends StatefulWidget {
  const SendResetCodeView({super.key});

  @override
  State<SendResetCodeView> createState() => _SendResetCodeViewState();
}

class _SendResetCodeViewState extends State<SendResetCodeView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.forgetPassword),
        leading: IconButton(
          onPressed: () {
            context.read<AuthCubit>().startAuth();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: SizesResources.s2),
              MyTextFormFieldWidget(
                hintText: "بريدك الالكتروني",
                validator: (text) {
                  return notEmptyValidator(text: text);
                },
                onSaved: (p0) {
                  email = p0;
                },
              ),
              const SizedBox(height: SizesResources.s2),
              ElevatedButtonWidget(
                text: "استلام رمز عبر البريد",
                loading: loading,
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    setState(() {
                      loading = true;
                    });
                    var query = locator<SupabaseClient>()
                        .auth
                        .resetPasswordForEmail(email!);
                    try {
                      await query.then((value) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ForgetPasswordView(
                              email: email!,
                            ),
                          ),
                        );
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("تم ارسال رمز التحقق"),
                        ),
                      );
                    } on Exception {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("حدث خطآ ما"),
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
