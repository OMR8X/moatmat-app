import 'package:flutter/material.dart';

class SpacingResources {
  static const double sidePadding = 10.0;

  static double mainWidth(BuildContext context) {
    return MediaQuery.of(context).size.width - (2 * sidePadding);
  }

  static double mainHalfWidth(BuildContext context) {
    return ((MediaQuery.of(context).size.width - (2 * sidePadding)) / 2) -
        (sidePadding / 2);
  }

  static EdgeInsetsDirectional mainSidePadding(BuildContext context) {
    return const EdgeInsetsDirectional.symmetric(
      horizontal: (sidePadding),
    );
  }
}
