import 'package:flutter/material.dart';
import '../../../Core/functions/parsers/date_to_text_f.dart';
import '../../../Core/functions/parsers/period_to_text_f.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Features/result/domain/entities/result.dart';

class ResultTileWidget extends StatelessWidget {
  const ResultTileWidget({
    super.key,
    required this.result,
    required this.onExploreResult,
    this.showResult = true,
  });
  final bool showResult;
  final Result result;
  final VoidCallback onExploreResult;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SpacingResources.mainWidth(context),
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s1,
          ),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary,
            boxShadow: ShadowsResources.mainBoxShadow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: SizesResources.s3,
                horizontal: SizesResources.s3,
              ),
              child: Row(
                children: [
                  //
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.testName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: ColorsResources.blackText1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (showResult) ...[
                            const SizedBox(height: SizesResources.s2),
                            Text(
                              "درجتك : %${result.mark}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: ColorsResources.blackText1,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                          if (result.bankId != null || result.testId != null) ...[
                            const SizedBox(height: SizesResources.s2),
                            Text(
                              "الوقت المنقضي : ${periodToTextFunction(result.period)}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: ColorsResources.blackText1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          if (result.bankId == null || result.testId == null || result.outerTestId == null) ...[
                            const SizedBox(height: SizesResources.s2),
                            Text(
                              "الدرجة : ${(result.mark)}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: ColorsResources.blackText1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          const SizedBox(height: SizesResources.s2),
                          Text(
                            "التاريخ : ${dateToTextFunction(result.date)}",
                            style: const TextStyle(
                              fontSize: 10,
                              color: ColorsResources.blackText1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //
                  if (result.bankId != null || result.testId != null || result.outerTestId != null)
                    TextButton(
                      onPressed: onExploreResult,
                      child: const Text(
                        "تفاصيل",
                        style: TextStyle(
                          fontSize: 10,
                          color: ColorsResources.primary,
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "نتيجة خارجية",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
