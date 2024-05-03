import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/old/test.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Features/tests/domain/entities/test.dart';
import '../view/tests/pick_test_v.dart';

class TestTileWidget extends StatelessWidget {
  const TestTileWidget({super.key, required this.test, required this.onPick});
  final Test test;
  final VoidCallback onPick;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: SpacingResources.mainHalfWidth(context),
        height: SpacingResources.mainHalfWidth(context),
        padding: const EdgeInsets.symmetric(
          vertical: SizesResources.s3,
        ),
        decoration: BoxDecoration(
          color: ColorsResources.onPrimary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: ShadowsResources.mainBoxShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              test.information.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorsResources.blackText2,
              ),
            ),
            getSubTitle(),
            Text(
              "${test.questions.length.toString()} سؤال",
              style: const TextStyle(
                fontSize: 10,
                color: ColorsResources.blackText2,
              ),
            ),
            FilledButton(
              onPressed: () {
                if (test.isPurchased()) {
                  //
                  if (test.information.password != null &&
                      test.information.password!.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => EnterTestPasswordWidget(
                        password: test.information.password!,
                        onOpen: () {
                          onPick();
                        },
                      ),
                    );
                  } else {
                    onPick();
                  }
                  //
                } else {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => BuyTestsWidget(
                      tests: [test],
                    ),
                  );
                }
              },
              child: test.isPurchased()
                  ? const Text(
                      "فتح",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorsResources.whiteText1),
                    )
                  : Text(
                      "${test.information.price} نقطة",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorsResources.whiteText1),
                    ),
            ),
          ],
        ));
  }

  Widget getSubTitle() {
    if (test.information.password != null &&
        test.information.password!.isNotEmpty) {
      return const Text(
        "كلمة السر مطلوبة",
        style: TextStyle(
          fontSize: 10,
          color: ColorsResources.darkPrimary,
        ),
      );
    }
    return const Text(
      "كلمة السر غير مطلوبة",
      style: TextStyle(
        fontSize: 10,
        color: ColorsResources.borders,
      ),
    );
  }
}
