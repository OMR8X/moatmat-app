import 'package:flutter/material.dart';

import 'colors_r.dart';

class FontsResources {
  // extra bold
  static TextStyle extraBoldStyle() {
    return const TextStyle(
      fontFamily: "Tajawal",
      fontWeight: FontWeight.w400,
      color: ColorsResources.blackText1,
    );
  }

  // bold
  static TextStyle boldStyle() {
    return const TextStyle(
      fontFamily: "Tajawal",
      fontWeight: FontWeight.w300,
      color: ColorsResources.blackText1,
    );
  }

  // reqular
  static TextStyle regularStyle() {
    return const TextStyle(
      fontFamily: "Tajawal",
      fontWeight: FontWeight.w200,
      color: ColorsResources.blackText1,
    );
  }

  // light
  static TextStyle lightStyle() {
    return const TextStyle(
      fontFamily: "Tajawal",
      fontWeight: FontWeight.w100,
      color: ColorsResources.blackText1,
    );
  }

  static TextStyle styleExtraLight({Color? color, double? size}) {
    return TextStyle(
      fontFamily: "Tajawal",
      fontSize: size,
      fontWeight: FontWeight.w100,
      color: color ?? ColorsResources.blackText1,
    );
  }

  // extra bold
  static TextStyle styleLight({Color? color, double? size}) {
    return TextStyle(
      fontFamily: "Tajawal",
      fontSize: size,
      fontWeight: FontWeight.w200,
      color: color ?? ColorsResources.blackText1,
    );
  }

  // extra bold
  static TextStyle styleRegular({Color? color, double? size}) {
    return TextStyle(
      fontFamily: "Tajawal",
      fontSize: size,
      fontWeight: FontWeight.w300,
      color: color ?? ColorsResources.blackText1,
    );
  }

  // extra bold
  static TextStyle styleMedium({Color? color, double? size, TextDecoration? decoration}) {
    return TextStyle(
      fontFamily: "Tajawal",
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color ?? ColorsResources.blackText1,
      decoration: decoration,
    );
  }

  // extra bold
  static TextStyle styleBold({Color? color, double? size}) {
    return TextStyle(
      fontFamily: "Tajawal",
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: color ?? ColorsResources.blackText1,
    );
  }

  // extra bold
  static TextStyle styleExtraBold({Color? color, double? size}) {
    return TextStyle(
      fontFamily: "Tajawal",
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color ?? ColorsResources.blackText1,
    );
  }

  // extra bold
  static TextStyle styleBlack({Color? color, double? size}) {
    return TextStyle(
      fontFamily: "Tajawal",
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color ?? ColorsResources.blackText1,
    );
  }
}
