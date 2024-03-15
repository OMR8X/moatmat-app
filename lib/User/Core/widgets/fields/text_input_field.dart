import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resources/spacing_resources.dart';

class MyTextFormFieldWidget extends StatelessWidget {
  const MyTextFormFieldWidget({
    super.key,
    this.hintText,
    this.onSaved,
    this.initialValue,
    this.textInputAction,
    this.inputFormatters,
    this.maxLength,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.width,
    this.textAlign, this.onChanged,
  });
  final String? hintText;
  final String? initialValue;
  final int? maxLength;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final double? width;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width ?? SpacingResources.mainWidth(context),
          child: TextFormField(
            onSaved: onSaved,
            onChanged:onChanged ,
            inputFormatters: inputFormatters,
            initialValue: initialValue,
            obscureText: obscureText,
            textAlign: textAlign ?? TextAlign.start,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            validator: validator,
            maxLength: maxLength,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
