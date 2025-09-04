import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resources/colors_r.dart';
import '../../resources/sizes_resources.dart';
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
    // this.minLines,
    // this.maxLines,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.width,
    this.textAlign,
    this.onChanged,
    this.controller,
    this.suffix,
  });
  final TextEditingController? controller;
  final String? hintText;
  final String? initialValue;
  final int? maxLength;
  // final int? minLines, maxLines;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final double? width;
  final TextAlign? textAlign;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width ?? SpacingResources.mainWidth(context),
          child: TextFormField(
            controller: controller,
            onSaved: onSaved,
            onChanged: onChanged,
            // maxLines: obscureText ? maxLines : null,
            // minLines: obscureText ? minLines : null,
            inputFormatters: inputFormatters,
            initialValue: initialValue,
            obscureText: obscureText,
            textAlign: textAlign ?? TextAlign.start,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            validator: validator,
            maxLength: maxLength,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                top: SizesResources.s4,
                bottom: SizesResources.s3,
                left: SizesResources.s2,
                right: SizesResources.s2,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorsResources.borders,
                  width: 0.5,
                ),
              ),
              suffixIcon: suffix,
              label: hintText != null ? Text(hintText!) : null,
              filled: true,
              fillColor: ColorsResources.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
