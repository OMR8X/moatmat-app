import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/validators/not_empty_v.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../../../Core/widgets/fields/text_input_field.dart';
import '../state/codes_c/codes_cubit.dart';


class AddCodeView extends StatefulWidget {
  const AddCodeView({super.key, this.code});
  final String? code;
  @override
  State<AddCodeView> createState() => _AddCodeViewState();
}

class _AddCodeViewState extends State<AddCodeView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? code;
  bool loading = false;
  void onFinishType() async {
    context.read<CodesCubit>().useCode(code!);
  }

  void onScanCode() async {
    context.read<CodesCubit>().scanCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: SizesResources.s2),
            Container(
              width: SpacingResources.mainWidth(context),
              padding: const EdgeInsets.symmetric(vertical: SizesResources.s6),
              decoration: BoxDecoration(
                color: ColorsResources.onPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: ShadowsResources.mainBoxShadow,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: SizesResources.s2),
                  Text(
                    "مسح الكود بالكاميرا",
                    style: FontsResources.boldStyle().copyWith(
                        color: ColorsResources.blackText1,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: SizesResources.s4),
                  const Icon(
                    Icons.qr_code,
                    size: 50,
                    color: ColorsResources.blackText2,
                  ),
                  const SizedBox(height: SizesResources.s4),
                  ElevatedButtonWidget(
                    width: 200,
                    onPressed: onScanCode,
                    text: ("مسح الكود"),
                  )
                ],
              ),
            ),
            const SizedBox(height: SizesResources.s4),
            Container(
              width: SpacingResources.mainWidth(context),
              padding: const EdgeInsets.symmetric(vertical: SizesResources.s6),
              decoration: BoxDecoration(
                color: ColorsResources.onPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: ShadowsResources.mainBoxShadow,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: SizesResources.s2),
                    Text(
                      "ادخال الكود",
                      style: FontsResources.boldStyle().copyWith(
                          color: ColorsResources.blackText1,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: SizesResources.s4),
                    MyTextFormFieldWidget(
                      width: SpacingResources.mainWidth(context) - 50,
                      initialValue: widget.code,
                      validator: (v) {
                        return notEmptyValidator(text: v);
                      },
                      onSaved: (p0) {
                        code = p0;
                      },
                    ),
                    const SizedBox(height: SizesResources.s4),
                    ElevatedButtonWidget(
                      width: 200,
                      loading: loading,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          onFinishType();
                        }
                      },
                      text: ("سحب الرصيد"),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
