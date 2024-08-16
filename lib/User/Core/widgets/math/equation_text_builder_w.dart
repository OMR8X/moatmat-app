import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/spacing_resources.dart';
import 'math_tex_w.dart';
import 'text_w.dart';

class EquationTextBuilderWidget extends StatelessWidget {
  const EquationTextBuilderWidget(
      {super.key, required this.text, required this.equations});
  final String text;
  final List<String> equations;

  @override
  Widget build(BuildContext context) {
    List<String> words = text.split(RegExp(r'(?<=\n)|(?=\n)| '));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingResources.sidePadding,
            vertical: SpacingResources.sidePadding,
          ),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary,
            border: Border.all(color: ColorsResources.borders),
            borderRadius: BorderRadius.circular(10),
          ),
          width: SpacingResources.mainWidth(context),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: words.map<Widget>((e) {
              //
              if (containsEscapeSequence(e)) {
                //
                String equation = getEquationByFromText(e);
                //
                return FittedBox(child: MathTexWidget(equation: equation));
                //
              } else {
                //
                if (e == '\n') {
                  //
                  return const NewLineWidget();
                  //
                } else {
                  //
                  return TextWidget(text: e);
                  //
                }
              }
            }).toList(),
          ),
        ),
      ],
    );
  }

  bool containsEscapeSequence(String input) {
    RegExp regex = RegExp(r'\\[0-9]');
    return regex.hasMatch(input);
  }

  String getEquationByFromText(String text) {
    //
    text = text.replaceAll("\\", "");
    //
    int index = int.tryParse(text) ?? 0;
    //
    if (index <= (equations.length - 1) && equations.isNotEmpty) {
      text = equations[index];
    }
    //
    return text;
  }
}

class NewLineWidget extends StatelessWidget {
  const NewLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: MediaQuery.of(context).size.width);
  }
}
