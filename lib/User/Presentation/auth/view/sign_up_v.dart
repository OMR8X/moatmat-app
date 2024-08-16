import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../Core/constant/classes_list.dart';
import '../../../Core/constant/governorates_list.dart';
import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/texts_resources.dart';
import '../../../Core/validators/email_v.dart';
import '../../../Core/validators/not_empty_v.dart';
import '../../../Core/widgets/fields/drop_down_w.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../../../Core/widgets/fields/text_input_field.dart';
import '../../../Features/auth/domain/entites/user_data.dart';
import '../../../Features/auth/domain/use_cases/sign_up_uc.dart';
import '../state/auth_c/auth_cubit_cubit.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String name;
  late String motherName;
  late String age;
  late String email;
  late String password;
  //
  late String phoneNumber;
  late String whatsappNumber;
  //
  late String schoolName;
  late String classroom;
  late String governorate;
  //
  bool loading = false;
  //
  void onFinish() async {
    setState(() {
      loading = true;
    });
    UserData userData = UserData(
        id: 0,
        uuid: "",
        deviceId: "",
        balance: 0,
        name: name,
        email: email,
        motherName: motherName,
        age: age,
        classroom: classroom,
        schoolName: schoolName,
        governorate: governorate,
        phoneNumber: phoneNumber,
        whatsappNumber: whatsappNumber,
        likes: [],
        tests: [],
        notifications: []);
    var query = locator<SignUpUC>().call(
      userData: userData,
      password: password,
    );
    await query.then((value) {
      value.fold(
        (l) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.text),
            ),
          );
        },
        (r) {
          //
          if (!GetIt.instance.isRegistered<UserData>()) {
            locator.registerFactory<UserData>(() => r);
          } else {
            GetIt.instance.unregister<UserData>();
            locator.registerFactory<UserData>(() => r);
          }
          //
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم آنشاء حساب بنجاح"),
            ),
          );
          context.read<AuthCubit>().finishAuth();
        },
      );
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppBarTitles.signUp,
        ),
        leading: IconButton(
          onPressed: () {
            context.read<AuthCubit>().startAuth();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: SizesResources.s4),
                MyTextFormFieldWidget(
                  validator: (p0) {
                    return notEmptyValidator(text: p0);
                  },
                  hintText: "الاسم الثلاثي",
                  textInputAction: TextInputAction.next,
                  maxLength: 30,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  onSaved: (p0) {
                    name = p0!;
                  },
                ),
                const SizedBox(height: SizesResources.s2),
                MyTextFormFieldWidget(
                  validator: (p0) {
                    return notEmptyValidator(text: p0);
                  },
                  hintText: "اسم الام",
                  textInputAction: TextInputAction.next,
                  maxLength: 30,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  onSaved: (p0) {
                    motherName = p0!;
                  },
                ),
                const SizedBox(height: SizesResources.s2),
                MyTextFormFieldWidget(
                  validator: (p0) {
                    return notEmptyValidator(text: p0);
                  },
                  hintText: "اسم المدرسة",
                  textInputAction: TextInputAction.next,
                  maxLength: 30,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  onSaved: (p0) {
                    schoolName = p0!;
                  },
                ),
                const SizedBox(height: SizesResources.s2),
                MyTextFormFieldWidget(
                  validator: (p0) {
                    return notEmptyValidator(text: p0);
                  },
                  hintText: "العمر",
                  textInputAction: TextInputAction.next,
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩]')),
                  ],
                  onSaved: (p0) {
                    age = p0!;
                  },
                ),
                const SizedBox(height: SizesResources.s2),
                MyTextFormFieldWidget(
                  validator: (p0) {
                    return emailValidator(text: p0);
                  },
                  hintText: "البريد الالكتروني",
                  textInputAction: TextInputAction.next,
                  maxLength: 45,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(45),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z@.]')),
                  ],
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (p0) {
                    email = p0!;
                  },
                ),
                const SizedBox(height: SizesResources.s2),
                MyTextFormFieldWidget(
                  validator: (p0) {
                    return notEmptyValidator(text: p0, lenght: 6);
                  },
                  hintText: "الرمز السري",
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (p0) {
                    password = p0!;
                  },
                ),
                const SizedBox(height: SizesResources.s2),
                MyTextFormFieldWidget(
                  validator: (p0) {
                    return notEmptyValidator(text: p0, lenght: 10);
                  },
                  hintText: "رقم الهاتف",
                  textInputAction: TextInputAction.next,
                  maxLength: 14,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(14),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩+]')),
                  ],
                  onSaved: (p0) {
                    phoneNumber = p0!;
                  },
                ),
                const SizedBox(height: SizesResources.s2),
                MyTextFormFieldWidget(
                  validator: (p0) {
                    return notEmptyValidator(text: p0, lenght: 10);
                  },
                  hintText: "رقم الواتساب",
                  textInputAction: TextInputAction.done,
                  maxLength: 14,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(14),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩+]')),
                  ],
                  onSaved: (p0) {
                    whatsappNumber = p0!;
                  },
                ),
                const SizedBox(height: SizesResources.s2),
                DropDownWidget(
                  hint: "الصف الدراسي",
                  items: classesLst,
                  validator: (p0) {
                    return notEmptyValidator(text: p0);
                  },
                  onSaved: (p0) {
                    classroom = p0!;
                  },
                ),
                const SizedBox(height: SizesResources.s2),
                DropDownWidget(
                  hint: "المحافظة",
                  items: governoratesLst,
                  validator: (p0) {
                    return notEmptyValidator(text: p0);
                  },
                  onSaved: (p0) {
                    governorate = p0!;
                  },
                ),
                const SizedBox(height: SizesResources.s4),
                ElevatedButtonWidget(
                  text: TextsResources.signUp,
                  loading: loading,
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      onFinish();
                    }
                  },
                ),
                const SizedBox(height: SizesResources.s2),
                const Text(
                  "قم ب${TextsResources.signUp} من اجل ${TextsResources.startUsingApp}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: ColorsResources.blackText2,
                  ),
                ),
                const SizedBox(height: SizesResources.s10 * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
