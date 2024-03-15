import 'package:flutter/material.dart';

import 'colors_r.dart';

class FontsResources {
  // extra bold
  static TextStyle extraBoldStyle() {
    return const TextStyle(
      fontFamily: "Almarai",
      fontWeight: FontWeight.w400,
      color: ColorsResources.blackText1,
    );
  }

  // bold
  static TextStyle boldStyle() {
    return const TextStyle(
      fontFamily: "Almarai",
      fontWeight: FontWeight.w300,
      color: ColorsResources.blackText1,
    );
  }

  // reqular
  static TextStyle reqularStyle() {
    return const TextStyle(
      fontFamily: "Almarai",
      fontWeight: FontWeight.w200,
      color: ColorsResources.blackText1,
    );
  }

  // light
  static TextStyle lightStyle() {
    return const TextStyle(
      fontFamily: "Almarai",
      fontWeight: FontWeight.w100,
      color: ColorsResources.blackText1,
    );
  }
}
