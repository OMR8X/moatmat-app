// import 'package:flutter/material.dart';
// import 'package:flutter_math_fork/flutter_math.dart';

// import '../../../Core/resources/colors_r.dart';
// import '../../../Core/resources/sizes_resources.dart';
// import '../../../Core/resources/spacing_resources.dart';
// import '../../../Features/tests/domain/entities/question.dart';
// import '../../../Features/tests/domain/entities/question_word_color.dart';


// class QuestionBodyWidget extends StatefulWidget {
//   const QuestionBodyWidget({super.key, required this.question});
//   final Question question;
//   @override
//   State<QuestionBodyWidget> createState() => _QuestionBodyWidgetState();
// }

// class _QuestionBodyWidgetState extends State<QuestionBodyWidget> {
//   @override
//   void didUpdateWidget(covariant QuestionBodyWidget oldWidget) {
//     setState(() {});
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Column(
//           children: [
//             //
//             if (widget.question.lowerImageText != null &&
//                 widget.question.lowerImageText != "") ...[
//               const SizedBox(height: SizesResources.s2),
//               QuestionTextBuilderWidget(
//                 text: widget.question.lowerImageText!,
//                 equations: const [],
//                 colors: const [],
//               ),
//             ],
//             //
//             if (widget.question.image != null &&
//                 widget.question.image != "") ...[
//               const SizedBox(height: SizesResources.s2),
//               QuestionImageBuilderWidget(image: widget.question.image!),
//               const SizedBox(height: SizesResources.s2),
//             ],
//             //
//             if (widget.question.upperImageText != null &&
//                 widget.question.upperImageText != "")
//               QuestionTextBuilderWidget(
//                 text: widget.question.upperImageText!,
//                 equations: widget.question.equations,
//                 colors: widget.question.colors,
//               ),
//             //
//           ],
//         ),
//       ],
//     );
//   }
// }

// class QuestionImageBuilderWidget extends StatelessWidget {
//   const QuestionImageBuilderWidget({
//     super.key,
//     required this.image,
//   });

//   final String image;

//   @override
//   Widget build(BuildContext context) {
//     if (image.contains("supabase")) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Image.network(
//           image,
//           width: SpacingResources.mainWidth(context) - 50,
//         ),
//       );
//     } else {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Image.asset(
//           image,
//           width: SpacingResources.mainWidth(context) - 50,
//         ),
//       );
//     }
//   }
// }

// class QuestionTextBuilderWidget extends StatefulWidget {
//   const QuestionTextBuilderWidget({
//     super.key,
//     required this.text,
//     required this.equations,
//     required this.colors,
//   });
//   final String text;
//   final List<String> equations;
//   final List<QuestionWordColor> colors;

//   @override
//   State<QuestionTextBuilderWidget> createState() =>
//       _QuestionTextBuilderWidgetState();
// }

// class _QuestionTextBuilderWidgetState extends State<QuestionTextBuilderWidget> {
//   late List<String> words;
//   late List<Color?> colors;
//   @override
//   void initState() {
//     //
//     words = widget.text.split(RegExp(r'(?<=\n)|(?=\n)| '));
//     //
//     colors = [];
//     //
//     for (int i = 0; i < words.length; i++) {
//       colors.add(null);
//     }
//     for (int i = 0; i < widget.colors.length; i++) {
//       colors[widget.colors[i].index] = widget.colors[i].color;
//     }
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(covariant QuestionTextBuilderWidget oldWidget) {
//     //
//     words = widget.text.split(RegExp(r'(?<=\n)|(?=\n)| '));
//     //
//     colors = [];
//     //
//     for (int i = 0; i < words.length; i++) {
//       colors.add(null);
//     }
//     for (int i = 0; i < widget.colors.length; i++) {
//       colors[widget.colors[i].index] = widget.colors[i].color;
//     }
//     setState(() {});
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: SpacingResources.mainWidth(context) - SpacingResources.sidePadding,
//       child: Wrap(
//         crossAxisAlignment: WrapCrossAlignment.center,
//         children: List.generate(words.length, (index) {
//           //
//           if (containsEscapeSequence(words[index])) {
//             //
//             String equation = getEquationByFromText(words[index]);
//             //
//             return MathTexWidget(equation: equation, color: colors[index]);
//             //
//           } else {
//             //
//             if (words[index] == '\n') {
//               //
//               return const NewLineWidget();
//               //
//             } else {
//               //
//               return TextWidget(text: words[index], color: colors[index]);
//               //
//             }
//           }
//         }),
//       ),
//     );
//   }

//   bool containsEscapeSequence(String input) {
//     RegExp regex = RegExp(r'\\[0-9]');
//     return regex.hasMatch(input);
//   }

//   String getEquationByFromText(String text) {
//     //
//     text = text.replaceAll("\\", "");
//     //
//     int index = int.tryParse(text) ?? 0;
//     //
//     if (index <= (widget.equations.length - 1) && widget.equations.isNotEmpty) {
//       text = widget.equations[index];
//     }
//     //
//     return text;
//   }
// }
