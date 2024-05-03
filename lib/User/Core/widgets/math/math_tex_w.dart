import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../Core/resources/colors_r.dart';

class MathTexWidget extends StatelessWidget {
  const MathTexWidget({super.key, required this.equation, this.color});
  final String equation;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Math.tex(
          equation,
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color ?? ColorsResources.blackText1,
          ),
          onErrorFallback: (errs) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                " الصيغة غير موجودة او تحتوي اخطاء ",
                style: TextStyle(color: ColorsResources.red),
              ),
            );
          },
        ),
      ),
    );
  }
}
