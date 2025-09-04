import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Core/resources/images_r.dart';
import 'package:moatmat_app/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/Presentation/folders/state/cubit/folders_manager_cubit.dart';
import 'package:moatmat_app/Presentation/tests/view/downloading/download_test_view.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Features/tests/domain/entities/test.dart';
import '../view/tests/pick_test_v.dart';

class TestTileWidget extends StatelessWidget {
  const TestTileWidget({super.key, required this.test, required this.onPick, this.onBuy, this.onDelete, this.isCached = false});
  final Test test;
  final bool isCached;
  final VoidCallback onPick;
  final VoidCallback? onDelete;
  final VoidCallback? onBuy;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SpacingResources.mainWidth(context),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: Colors.white24,
                width: 0.5,
              ),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onTap(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s2,
                  horizontal: SizesResources.s2,
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: SizesResources.s2,
                    ),
                    Image.asset(
                      ImagesResources.testIcon,
                      width: 26,
                      color: ColorsResources.blueText,
                    ),
                    const SizedBox(
                      width: SizesResources.s2,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            test.information.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: ColorsResources.whiteText1,
                            ),
                          ),
                          const SizedBox(height: SizesResources.s1),
                          getSubTitle(),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        onTap(context);
                      },
                      child: test.isPurchased() || isCached
                          ? const Text(
                              "فتح",
                              style: TextStyle(
                                color: ColorsResources.whiteText1,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (test.information.password != null && test.information.password!.isNotEmpty) ...[
                                  const Icon(
                                    Icons.lock,
                                    size: 10,
                                  ),
                                  const SizedBox(width: SizesResources.s2),
                                ],
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    "${test.information.price} نقطة",
                                    style: const TextStyle(
                                      color: ColorsResources.whiteText1,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
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

  onTap(BuildContext context) {
    if (kDebugMode) {
      onPick();
      return;
    }
    if (test.isPurchased() || isCached) {
      //
      if (test.information.password != null && test.information.password!.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => EnterTestPasswordWidget(
            password: test.information.password!,
            onOpen: () {
              Navigator.of(context).pop();
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
        builder: (context) => BuyTestWidget(
          test: test,
          onDownload: (testId) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DownloadTestView(testId: testId),
              ),
            );
          },
        ),
      ).then((f) {
        context.read<FoldersManagerCubit>().refresh();
        if (onBuy != null) {
          onBuy!();
        }
      });
    }
  }

  Widget getSubTitle() {
    if (kDebugMode) {
      return Text(
        "${test.information.videos?.length.toString() ?? "0"} , ${test.information.files?.length.toString() ?? "0"}",
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white54,
        ),
      );
    }
    if (test.information.password != null && test.information.password!.isNotEmpty) {
      return const Text(
        "كلمة السر مطلوبة",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10,
          color: Colors.white54,
        ),
      );
    }
    return const Text(
      "كلمة السر غير مطلوبة",
      style: TextStyle(
        fontSize: 10,
        color: Colors.white54,
      ),
    );
  }
}
