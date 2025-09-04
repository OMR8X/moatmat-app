import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/texts_resources.dart';
import '../../../Core/validators/not_empty_v.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../../../Core/widgets/fields/text_input_field.dart';
import '../../../Features/auth/domain/entites/user_data.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key, required this.userData});
  final UserData userData;
  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String password = "";
  bool loading = false;
  onFinish() async {
    setState(() {
      loading = true;
    });

    final attributes = UserAttributes(password: password);
    final query = locator<SupabaseClient>().auth.updateUser(attributes);
    try {
      var res = await query;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم تغيير الرمز السري بنجاح"),
          ),
        );
        Navigator.of(context).pop();
      }
    } on AuthException catch (e) {
      if (mounted) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.statusCode == "422"
                  ? "يرجى استخدام رمز سري جديد"
                  : "حدث خطا ما",
            ),
          ),
        );
      }
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("حدث خطا ما"),
          ),
        );
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.changePassword),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: SizesResources.s4),
              MyTextFormFieldWidget(
                validator: (p0) {
                  return notEmptyValidator(text: p0, lenght: 8);
                },
                hintText: "كلمة السر الجديدة",
                textInputAction: TextInputAction.next,
                maxLength: 30,
                obscureText: true,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30),
                ],
                onChanged: (p0) {
                  password = p0 ?? "";
                },
                onSaved: (p0) {
                  password = p0!;
                },
              ),
              const SizedBox(height: SizesResources.s4),
              MyTextFormFieldWidget(
                validator: (p0) {
                  if (password != p0) {
                    return "كلمات المرور غير متطابقة";
                  }
                  return notEmptyValidator(text: p0, lenght: 8);
                },
                hintText: "تاكيد كلمة السر الجديدة",
                textInputAction: TextInputAction.next,
                maxLength: 30,
                obscureText: true,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30),
                ],
                onSaved: (p0) {
                  password = p0!;
                },
              ),
              const SizedBox(height: SizesResources.s4),
              ElevatedButtonWidget(
                text: TextsResources.update,
                loading: loading,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    onFinish();
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
