import 'package:flutter/material.dart';

class ShadowsResources {
  static get mainBoxShadow => [
        BoxShadow(
          blurRadius: 0.72,
          spreadRadius: 0,
          color: Colors.black.withOpacity(0.24),
        ),
        BoxShadow(
          blurRadius: 5.77,
          spreadRadius: 0.72,
          offset: const Offset(0, 2.17),
          color: Colors.black.withOpacity(0.05),
        ),
      ];
}
