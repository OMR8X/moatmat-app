import 'package:flutter/material.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/widgets/math/question_body_w.dart';
import '../../../Features/tests/domain/entities/question.dart';

class QuestionItemWidget extends StatelessWidget {
  const QuestionItemWidget({
    super.key,
    required this.question,
    this.onTap,
    this.onDelete,
  });

  final Question question;
  final VoidCallback? onTap, onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SpacingResources.mainWidth(context),
      margin: const EdgeInsets.symmetric(
        vertical: SpacingResources.sidePadding / 2,
      ),
      decoration: BoxDecoration(
        color: ColorsResources.onPrimary,
        border: Border.all(color: ColorsResources.borders),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: SpacingResources.sidePadding,
            ),
            child: Column(
              children: [
                QuestionBodyWidget(question: question),
                if (onDelete != null)
                  TextButton(
                    onPressed: onDelete,
                    child: Text(
                      "حذف",
                      style: FontsResources.boldStyle().copyWith(
                        color: ColorsResources.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
