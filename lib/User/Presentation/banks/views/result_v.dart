import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/shadows_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';
import 'package:moatmat_app/User/Core/widgets/fields/elevated_button_widget.dart';

class BankResultView extends StatelessWidget {
  const BankResultView({
    super.key,
    required this.showCorrectAnswers,
    required this.showWrongAnswers,
    required this.reOpen,
    required this.backToHome,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.result,
  });
  final String correctAnswers;
  final String wrongAnswers;
  final String result;
  final VoidCallback showCorrectAnswers;
  final VoidCallback showWrongAnswers;
  final VoidCallback reOpen;
  final VoidCallback backToHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.result),
        leading: IconButton(
          onPressed: backToHome,
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: SizesResources.s4),
            SizedBox(
              width: SpacingResources.mainWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: SpacingResources.mainHalfWidth(context),
                    height: SpacingResources.mainHalfWidth(context),
                    decoration: BoxDecoration(
                      color: ColorsResources.onPrimary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: ShadowsResources.mainBoxShadow,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: SizesResources.s4),
                        Text(
                          correctAnswers,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: ColorsResources.green,
                          ),
                        ),
                        const SizedBox(height: SizesResources.s1),
                        const Text(
                          TextsResources.correctAnswers,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: ColorsResources.blackText2,
                          ),
                        ),
                        if (correctAnswers != '0')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 20),
                              TextButton.icon(
                                onPressed: showCorrectAnswers,
                                icon: const Text(
                                  TextsResources.show,
                                  style: TextStyle(fontSize: 10),
                                ),
                                label: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 10,
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: SpacingResources.mainHalfWidth(context),
                    height: SpacingResources.mainHalfWidth(context),
                    decoration: BoxDecoration(
                      color: ColorsResources.onPrimary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: ShadowsResources.mainBoxShadow,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: SizesResources.s4),
                        Text(
                          wrongAnswers,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: ColorsResources.red,
                          ),
                        ),
                        const SizedBox(height: SizesResources.s1),
                        const Text(
                          TextsResources.wrongAnswers,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: ColorsResources.blackText2,
                          ),
                        ),
                        if (wrongAnswers != '0')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 20),
                              TextButton.icon(
                                onPressed: showWrongAnswers,
                                icon: const Text(
                                  TextsResources.show,
                                  style: TextStyle(fontSize: 10),
                                ),
                                label: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 10,
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SizesResources.s3),
            Container(
              width: SpacingResources.mainWidth(context),
              height: SpacingResources.mainHalfWidth(context),
              decoration: BoxDecoration(
                color: ColorsResources.onPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: ShadowsResources.mainBoxShadow,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: SizesResources.s4),
                  Text(
                    " %$result",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: ColorsResources.darkPrimary,
                    ),
                  ),
                  const SizedBox(height: SizesResources.s4),
                  const Text(
                    TextsResources.result,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ColorsResources.blackText2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SizesResources.s2),
            ElevatedButtonWidget(
              text: TextsResources.reOpen,
              onPressed: reOpen,
            ),
            const SizedBox(height: SizesResources.s2),
            ElevatedButtonWidget(
              text: TextsResources.backToHome,
              onPressed: backToHome,
            ),
          ],
        ),
      ),
    );
  }
}
