import 'package:flutter/material.dart';

import '../../resources/fonts_r.dart';

class BoxLabelWidget extends StatelessWidget {
  const BoxLabelWidget({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: FontsResources.regularStyle(),
      textAlign: TextAlign.center,
    );
  }
}
