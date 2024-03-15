import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../../Core/constant/classes_list.dart';
import '../../../Core/constant/governorates_list.dart';
import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/texts_resources.dart';
import '../../../Core/validators/not_empty_v.dart';
import '../../../Core/widgets/fields/drop_down_w.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../../../Core/widgets/fields/text_input_field.dart';
import '../../../Features/auth/domain/entites/user_data.dart';
import '../../../Features/auth/domain/use_cases/update_user_data_uc.dart';

class UpdateUserDataView extends StatefulWidget {
  const UpdateUserDataView({super.key, required this.userData});
  final UserData userData;
  @override
  State<UpdateUserDataView> createState() => _UpdateUserDataViewState();
}

class _UpdateUserDataViewState extends State<UpdateUserDataView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String name;
  late String motherName;
  late String age;
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
    var userData = UserData(
      uuid: widget.userData.uuid,
      balance: widget.userData.balance,
      name: name,
      email: widget.userData.email,
      motherName: motherName,
      age: age,
      classroom: classroom,
      schoolName: schoolName,
      governorate: governorate,
      phoneNumber: phoneNumber,
      whatsappNumber: whatsappNumber,
      likes: [],
      tests: [],
    );
    var query = locator<UpdateUserDataUC>().call(
      userData: userData,
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
          if (!GetIt.instance.isRegistered<UserData>()) {
            locator.registerFactory<UserData>(() => userData);
          } else {
            GetIt.instance.unregister<UserData>();
            locator.registerFactory<UserData>(() => userData);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم تحديث البيانات بنجاح"),
            ),
          );
          Navigator.of(context).pop();
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
          AppBarTitles.updateUserData,
        ),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: SizesResources.s4),
                MyTextFormFieldWidget(
                  initialValue: widget.userData.name,
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
                  initialValue: widget.userData.motherName,
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
                  initialValue: widget.userData.schoolName,
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
                  initialValue: widget.userData.age,
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
                  initialValue: widget.userData.phoneNumber,
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
                  initialValue: widget.userData.whatsappNumber,
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
                  selectedItem: widget.userData.classroom,
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
                  selectedItem: widget.userData.governorate,
                  validator: (p0) {
                    return notEmptyValidator(text: p0);
                  },
                  onSaved: (p0) {
                    governorate = p0!;
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
                const SizedBox(height: SizesResources.s10 * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
