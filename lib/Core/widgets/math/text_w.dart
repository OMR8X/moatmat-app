import 'package:flutter/material.dart';

import '../../resources/colors_r.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({super.key, required this.text, this.color});
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic(text) ? TextDirection.rtl : TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Text(
          " $text ",
          style: TextStyle(
            fontSize: 16,
            color: color ?? ColorsResources.blackText1,
          ),
        ),
      ),
    );
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
