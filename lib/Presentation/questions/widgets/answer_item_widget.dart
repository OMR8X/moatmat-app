import 'package:flutter/material.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Features/tests/domain/entities/answer.dart';
import '../../tests/widgets/answer_body_w.dart';

class AnswerItemWidget extends StatelessWidget {
  const AnswerItemWidget({
    super.key,
    required this.answer,
    this.onTap,
    this.onDelete,
    this.selected = false,
  });

  final Answer answer;
  final VoidCallback? onTap, onDelete;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SpacingResources.mainWidth(context),
          margin: const EdgeInsets.symmetric(
            vertical: SpacingResources.sidePadding / 2,
          ),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary,
            border: Border.all(
              color:
                  selected ? ColorsResources.primary : ColorsResources.borders,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SpacingResources.sidePadding / 2,
                ),
                child: Column(
                  children: [
                    AnswerBodyWidget(answer: answer),
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
        ),
      ],
    );
  }
}
